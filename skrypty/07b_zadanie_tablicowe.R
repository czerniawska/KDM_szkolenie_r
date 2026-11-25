# ==========================================================
# LEKCJA 7b: Zadanie tablicowe (SLURM array job)
# ==========================================================
# Ten skrypt uruchamiamy przez:  sbatch hpc/03_tablica.sbatch
# SLURM uruchomi go 4 razy NARAZ, za każdym razem z innym numerem
# w zmiennej SLURM_ARRAY_TASK_ID (1, 2, 3, 4).
# Każda kopia liczy bootstrap dla innej grupy diety.
#
# Ten sam wzorzec działa dla 4 grup, 100 genów albo 1000 symulacji.

library(tidyverse)

ssaki <- read_csv("dane/ssaki.csv", show_col_types = FALSE)
if (!dir.exists("wyniki")) dir.create("wyniki")

# 1. Który to numer zadania? -------------------------------
# Poza SLURM-em (do testów na laptopie) przyjmujemy numer 1.
numer_zadania <- as.integer(Sys.getenv("SLURM_ARRAY_TASK_ID", unset = "1"))

# 2. Numer zadania -> grupa do policzenia --------------------
grupy <- c("carni", "herbi", "insecti", "omni")
moja_grupa <- grupy[numer_zadania]

cat("Zadanie nr", numer_zadania, "liczy grupę:", moja_grupa, "\n")

# 3. Obliczenia tylko dla "swojej" grupy ---------------------
sen <- ssaki %>%
  filter(vore == moja_grupa) %>%
  pull(sleep_total)

set.seed(numer_zadania) # inny, ale powtarzalny seed dla każdego zadania
srednie <- replicate(10000, mean(sample(sen, replace = TRUE)))

wynik <- tibble(
  grupa   = moja_grupa,
  n       = length(sen),
  srednia = mean(sen),
  dolna   = quantile(srednie, 0.025),
  gorna   = quantile(srednie, 0.975)
)
print(wynik)

# 4. Każde zadanie zapisuje SWÓJ plik ------------------------
# (Gdyby wszystkie pisały do jednego pliku, nadpisywałyby się nawzajem!)
write_csv(wynik, paste0("wyniki/bootstrap_", moja_grupa, ".csv"))

# 5. Po zakończeniu wszystkich zadań łączymy wyniki ----------
# (uruchom interaktywnie, gdy squeue nie pokazuje już zadań):
#
# list.files("wyniki", pattern = "^bootstrap_.*\\.csv$", full.names = TRUE) %>%
#   setdiff("wyniki/bootstrap_przedzial.csv") %>%
#   map(read_csv) %>%
#   bind_rows()
