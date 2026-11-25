# ==========================================================
# LEKCJA 5: Tabele do publikacji (Raportowanie)
# ==========================================================

# Instalacja
# install.packages(c("gtsummary", "flextable", "gt"))

library(tidyverse)
library(gtsummary)
library(flextable)
library(gt)

# Wczytajmy dane (każdy skrypt powinien działać samodzielnie)
ssaki <- read_csv("dane/ssaki.csv")

# Folder na wyniki (jeśli jeszcze nie istnieje)
if (!dir.exists("wyniki")) dir.create("wyniki")

# Przygotujmy dane (wybierzmy kilka ciekawych kolumn)
dane_do_tabeli <- ssaki %>% 
  select(vore, sleep_total, bodywt, conservation)

# 1. TABELA 1 - Statystyki opisowe w 3 sekundy 
# Funkcja tbl_summary() automatycznie rozpoznaje typ danych!

tabela1 <- dane_do_tabeli %>% 
  tbl_summary(
    by = vore, # Podział na grupy (kolumny tabeli)
    statistic = list(all_continuous() ~ "{mean} ({sd})"), # Format średnia (SD)
    label = list(
      sleep_total ~ "Całkowity czas snu (h)",
      bodywt ~ "Masa ciała (kg)",
      conservation ~ "Status ochrony"
    )
  ) %>% 
  add_p() %>%      # Dodaj testy statystyczne (p-value)!
  add_overall() %>% # Dodaj kolumnę "Ogółem"
  bold_labels()    # Pogrubione nazwy zmiennych

# Zobacz wynik w panelu Viewer (obok Plots)
print(tabela1)


# R sam dobrał test (np. Kruskal-Wallis, Chi-kwadrat) 
# w zależności od danych. Można to zmienić ręcznie, ale domyślnie działa świetnie.


# ----------------------------------------------------------
# [ĆWICZ Z AI] Sprawdzaj, nie ufaj na ślepo
# Przykładowe polecenie (prompt) dla asystenta AI:
#   "Recenzent pyta, jakim testem policzono p-value w mojej tabeli z gtsummary
#    (add_p()). Jak to sprawdzić w R i jak zmienić test na test t-Studenta?"
#
#   UWAGA: AI potrafi wymyślić nieistniejące argumenty funkcji. Każdą
#   podpowiedź sprawdź w pomocy R:  ?add_p  albo  ?tbl_summary
#   i zawsze uruchom kod - to R ma ostatnie słowo, nie AI.
# ----------------------------------------------------------

# 2. EKSPORT DO WORDA 
# gtsummary tworzy tabelę HTML. Żeby wrzucić ją do Worda, 
# musimy zamienić ją na obiekt "flextable".

tabela1 %>% 
  as_flex_table() %>%                 # Konwersja
  save_as_docx(path = "wyniki/Tabela_1_wyniki.docx")

# Sprawdźcie folder "wyniki". Macie gotowy plik Word!


# 3. ZWYKŁA TABELA Z DANYMI (nie statystyczna) 
# Jeśli chcecie po prostu ładnie wydrukować fragment danych (np. 5 wierszy)

top_ssaki <- ssaki %>% 
  slice_head(n = 5) %>% 
  select(name, genus, sleep_total)

# Zwykły brzydki druk:
# print(top_ssaki)

# Ładna tabela flextable:
tabela_ladna <- top_ssaki %>% 
  flextable() %>% 
  theme_vanilla() %>%             # Gotowy styl (np. vanilla, box, alafoli)
  autofit() %>%                   # Dopasuj szerokość kolumn
  bg(i = 1, j = 1, bg = "yellow") # Można kolorować komórki (wiersz 1, kol 1)

# Zapis do Worda
save_as_docx(tabela_ladna, path = "wyniki/lista_ssakow.docx")


# Zapis do LaTeX

# Przypomnijmy: 'tabela1' to nasz obiekt z gtsummary stworzony przed chwilą.

# Krok 1: Konwersja gtsummary na obiekt 'gt' (baza graficzna)
# Krok 2: Konwersja na kod LaTeX

kod_latex <- tabela1 %>% 
  as_gt() %>%       # Zamień gtsummary na gt
  as_latex()        # Wygeneruj kod LaTeX

# Możesz też zapisać to bezpośrednio do pliku .tex
tabela1 %>% 
  as_gt() %>% 
  as_latex() %>% 
  as.character() %>%    # Zamień na czysty tekst
  write_lines("wyniki/tabela1.tex") # Zapisz do pliku

# Teraz wystarczy otworzyć plik 'tabela1.tex' notatnikiem, 
# skopiować wszystko i wkleić do Overleafa.
