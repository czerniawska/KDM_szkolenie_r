# ==========================================================
# LEKCJA 7: R na klastrze HPC
# ==========================================================
# Ten skrypt można uruchamiać na dwa sposoby:
#  a) interaktywnie (RStudio / sesja srun) - linijka po linijce,
#  b) jako zadanie wsadowe:  sbatch hpc/02_rownolegle.sbatch
# W trybie wsadowym nikt nie patrzy na ekran - wszystko, co R
# "wydrukuje", trafi do pliku z logiem w folderze logi/.

library(tidyverse)
library(parallel) # pakiet wbudowany w R - nie trzeba go instalować

ssaki <- read_csv("dane/ssaki.csv", show_col_types = FALSE)
if (!dir.exists("wyniki")) dir.create("wyniki")


# 1. GDZIE I JAK DZIAŁAM? ----------------------------------

# Czy ktoś siedzi przed ekranem (TRUE), czy to zadanie wsadowe (FALSE)?
interactive()

# Na jakim komputerze jestem? Na klastrze zobaczysz nazwę węzła,
# np. "login01" (węzeł logowania) albo "c0123" (węzeł obliczeniowy).
Sys.info()[["nodename"]]

# Czy jestem wewnątrz zadania SLURM? Jeśli tak, mam numer zadania.
Sys.getenv("SLURM_JOB_ID", unset = "brak - nie jestem w zadaniu SLURM")


# 2. ILE RDZENI NAPRAWDĘ DOSTAŁAM/DOSTAŁEM? -----------------

# PUŁAPKA: detectCores() pokazuje WSZYSTKIE rdzenie węzła (np. 48),
# a nie te, które przydzielił nam SLURM (np. 4).
detectCores()

# Poprawnie: czytamy liczbę rdzeni z ustawień zadania (--cpus-per-task).
# Poza SLURM-em (np. na laptopie) zmienna nie istnieje, więc bierzemy 1.
liczba_rdzeni <- as.integer(Sys.getenv("SLURM_CPUS_PER_TASK", unset = "1"))
cat("Liczba rdzeni do dyspozycji:", liczba_rdzeni, "\n")


# 3. OBLICZENIA RÓWNOLEGŁE - IDEA --------------------------
# Mamy 8 niezależnych zadań, każde trwa 1 sekundę.
# Jeden rdzeń robi je po kolei (8 s), 4 rdzenie - po 2 naraz na każdym (ok. 2 s).

wolne_obliczenie <- function(i) {
  Sys.sleep(1) # udajemy ciężkie obliczenia
  i^2
}

# A. Po kolei (lapply = "zastosuj funkcję do każdego elementu")
czas_sekwencyjnie <- system.time(
  wynik_1 <- lapply(1:8, wolne_obliczenie)
)

# B. Równolegle (mclapply = to samo, ale na wielu rdzeniach)
czas_rownolegle <- system.time(
  wynik_2 <- mclapply(1:8, wolne_obliczenie, mc.cores = liczba_rdzeni)
)

cat("Po kolei:   ", czas_sekwencyjnie[["elapsed"]], "s\n")
cat("Równolegle: ", czas_rownolegle[["elapsed"]], "s\n")

# Wynik jest identyczny - zmienia się tylko czas:
identical(wynik_1, wynik_2)

# UWAGA (Windows): mclapply nie działa równolegle na Windowsie.
# Na klastrze (Linux) i na macOS - działa. Alternatywa dla wszystkich
# systemów: pakiety future + furrr (funkcja future_map).


# ----------------------------------------------------------
# [ĆWICZ Z AI] Czy moje zadanie da się zrównoleglić?
# Przykładowe polecenie (prompt) dla asystenta AI:
#   "Opiszę moją analizę: [np. dla każdego z 200 plików liczę model i zapisuję
#    wynik]. Czy da się ją zrównoleglić? Lepszy będzie mclapply na wielu
#    rdzeniach czy zadanie tablicowe SLURM (--array)? Uzasadnij."
# ----------------------------------------------------------

# 4. PRZYKŁAD NAUKOWY: BOOTSTRAP ---------------------------
# Pytanie: jak bardzo pewna jest średnia długość snu roślinożerców?
# Bootstrap: losujemy ze zwracaniem tysiące "nowych prób" i liczymy
# średnią w każdej. Każde losowanie jest niezależne -> idealne do zrównoleglenia.

sen_roslinozercow <- ssaki %>%
  filter(vore == "herbi") %>%
  pull(sleep_total) # pull() wyciąga kolumnę jako zwykły wektor liczb

jedna_proba_bootstrap <- function(i) {
  mean(sample(sen_roslinozercow, replace = TRUE))
}

# Losowanie na wielu rdzeniach wymaga specjalnego generatora liczb losowych,
# żeby wyniki były powtarzalne (ten sam seed = te same wyniki).
RNGkind("L'Ecuyer-CMRG")
set.seed(123)

srednie_bootstrap <- mclapply(1:10000, jedna_proba_bootstrap,
                              mc.cores = liczba_rdzeni) %>%
  unlist() # mclapply zwraca listę - zamieniamy ją na wektor liczb

# 95% przedział ufności dla średniej
przedzial <- quantile(srednie_bootstrap, probs = c(0.025, 0.975))
print(przedzial)


# 5. PRACA BEZ EKRANU --------------------------------------
# W zadaniu wsadowym:
#  - View() nie zadziała (nie ma okna),
#  - wykres wyświetlony na ekranie po prostu zniknie,
#  - print() i cat() trafią do pliku z logiem.
# Dlatego WSZYSTKO, co chcemy zachować, zapisujemy do plików.

if (interactive()) {
  View(ssaki) # wykona się tylko, gdy ktoś patrzy na ekran
}

wykres_bootstrap <- tibble(srednia = srednie_bootstrap) %>%
  ggplot(aes(x = srednia)) +
  geom_histogram(bins = 50, fill = "grey70", colour = "white") +
  geom_vline(xintercept = przedzial, linetype = "dashed") +
  labs(
    title = "Bootstrap: średni czas snu roślinożerców",
    x = "Średnia (h)", y = "Liczba prób"
  ) +
  theme_bw()

ggsave("wyniki/bootstrap_histogram.png", plot = wykres_bootstrap,
       width = 7, height = 5, dpi = 300)

write_csv(tibble(dolna = przedzial[[1]], gorna = przedzial[[2]]),
          "wyniki/bootstrap_przedzial.csv")

# Przydatny "ślad" w logu - po fakcie wiadomo, co i gdzie się policzyło
cat("Gotowe. Węzeł:", Sys.info()[["nodename"]],
    "| rdzenie:", liczba_rdzeni,
    "| czas:", format(Sys.time()), "\n")

# Informacja o wersji R i pakietów - bardzo przydatna przy problemach
sessionInfo()

# ----------------------------------------------------------
# [ĆWICZ Z AI] Zadanie nie działa na klastrze
# Przykładowe polecenie (prompt) dla asystenta AI:
#   "Oto mój plik .sbatch: [wklej] i ostatnie 30 linijek logu: [wklej].
#    Zadanie zakończyło się statusem [z sacct, np. OUT_OF_MEMORY].
#    Co poszło nie tak i co zmienić?"
#
#   UWAGA: nigdy nie wklejaj haseł, kluczy SSH ani tokenów dostępu.
#   Nazwę grantu i ścieżki możesz zastąpić np. MOJ_GRANT, /home/LOGIN.
# ----------------------------------------------------------

# ==========================================================
# KONIEC SKRYPTU
# ==========================================================
