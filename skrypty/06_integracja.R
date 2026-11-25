# ==============================================================================
# PROJEKT: Analiza snu ssaków
# DATA: 2024-12-16
# OPIS: Skrypt pobiera dane, czyści je, liczy statystyki i generuje wykres.
# ==============================================================================

# 1. Konfiguracja i pakiety 
library(tidyverse)
library(gtsummary)

# Tworzymy folder na wyniki (Programming Defensively)
if (!dir.exists("wyniki")) dir.create("wyniki")

# 2. Import Danych 
# Wczytujemy dane z pliku CSV (ścieżka względem folderu projektu)
raw_data <- read_csv('dane/ssaki.csv')

# 3. Czyszczenie (Data Wrangling) 
# Usuwamy braki w diecie i wybieramy interesujące kolumny
clean_data <- raw_data %>% 
  drop_na(vore) %>% 
  select(name, vore, sleep_total, bodywt) %>% 
  mutate(log_bodywt = log(bodywt))

# 4. Analiza Statystyczna
# Tabela do publikacji
stat_table <- clean_data %>% 
  tbl_summary(by = vore, include = c(sleep_total, bodywt)) %>% 
  add_p()

# Zapis tabeli do Worda
stat_table %>% 
  as_flex_table() %>% 
  save_as_docx(path = "wyniki/tabela_koncowa.docx")

# 5. Wizualizacja 
# Wykres pudełkowy
final_plot <- ggplot(clean_data, aes(x = vore, y = sleep_total, fill = vore)) +
  geom_boxplot() +
  geom_jitter(alpha = 0.3) +
  labs(
    title = "Sen a dieta ssaków",
    x = "Rodzaj diety",
    y = "Czas snu (h)"
  ) +
  theme_minimal()

# Zapis wykresu
ggsave("wyniki/wykres_koncowy.png", plot = final_plot, dpi = 300)

# ----------------------------------------------------------
# [ĆWICZ Z AI] Code review
# Przykładowe polecenie (prompt) dla asystenta AI:
#   "Zrób code review mojego skryptu: [wklej cały skrypt]. Oceń czytelność,
#    nazwy zmiennych i powtarzalność analizy. NIE przepisuj kodu - wypisz
#    uwagi w punktach, od najważniejszej. Poprawki wprowadzę sama/sam."
#
#   Gdy skrypt działa, poproś: "Jak zamienić ten skrypt w funkcję, która
#   przyjmuje nazwę pliku z danymi?" - to dobry kolejny krok w nauce.
# ----------------------------------------------------------

# ==============================================================================
# KONIEC SKRYPTU
# ==============================================================================