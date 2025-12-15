# ==========================================================
# LEKCJA 2: Import i przetwarzanie danych (Data Wrangling)
# ==========================================================

library(tidyverse) 
install.packages('readxl')
library(readxl) 
install.packages('writexl')
library(writexl)

# 1. IMPORT DANYCH 
# Tak by to wyglądało, gdybyśmy mieli plik na dysku:
ssaki <- read_csv("dane/ssaki.csv")
ssaki_excel <- read_excel("dane/ssaki.xlsx")

# Usuńmy obiekt ssaki_excel
rm(ssaki_excel)

# Zobaczmy te dane
print(ssaki) # Klasyczna funkcja 
glimpse(ssaki) # Można zobaczyć każdą kolumnę w tabeli
head(ssaki) # Pokazuje pierwsze 5 wierszy i tyle kolumn ile wejdzie
summary(ssaki) # Daje podsumowanie wartości zmiennej
# View(ssaki) # Otwiera tabelę w nowym oknie

# 2. OPERATOR PIPE (%>%) -----------------------------------
# Skrót: Ctrl + Shift + M
# Czytamy: "Weź ssaki, A NASTĘPNIE wybierz kolumny..."
# Wynik zostanie wydrukowany, ale nie przypisany do żadnego obiektu

ssaki %>% 
  select(name, sleep_total)

# 3. SELECT - Wybieranie kolumn 
# Chcemy tylko: nazwę, rodzaj diety (vore), sen i masę ciała
# Wynik zostanie przypisany do nowego obiektu ssaki_wybrane

ssaki_wybrane <- ssaki %>% 
  select(name, vore, sleep_total, bodywt)

# Możemy też usuwać kolumny minusem:
# Czytaj: pokaż wszystkie kolumny z pominięciem conservation
ssaki %>% select(-conservation)

# 4. FILTER - Wybieranie wierszy ---------------------------
# To jest sito. Zostają tylko te wiersze, które spełniają warunek.

# Tylko roślinożercy (herbi)
# UWAGA: Używamy podwójnego "==" do porównania!
ssaki_wybrane %>% 
  filter(vore == "herbi")

# Roślinożercy, którzy ważą więcej niż 50 kg
ssaki_wybrane %>% 
  filter(vore == "herbi", bodywt > 50)

# Operator LUB ("|") - roślinożercy LUB owadożercy (insecti)
ssaki_wybrane %>% 
  filter(vore == "herbi" | vore == "insecti")


# 5. MUTATE - Tworzenie nowych kolumn 
# Chcemy policzyć:
# - wagę w gramach (bodywt * 1000)
# - frakcję snu (jaka część doby jest przespana)

ssaki_przetworzone <- ssaki_wybrane %>% 
  mutate(
    bodywt_g = bodywt * 1000,
    sleep_ratio = sleep_total / 24,
    log_bodywt = log(bodywt) # Logarytmowanie 
  )

# Sprawdźmy, czy nowe kolumny są na końcu
glimpse(ssaki_przetworzone)


# 6. SUMMARISE & GROUP_BY - Statystyki w grupach 
# Pytanie badawcze: Czy dieta wpływa na długość snu?

# A. Statystyka dla całej grupy (mało ciekawe)
ssaki_przetworzone %>% 
  summarise(sredni_sen = mean(sleep_total))

# B. Statystyka w podgrupach (Split-Apply-Combine)


wyniki_grupowe <- ssaki_przetworzone %>% 
  drop_na(vore) %>%                # 1. Wyrzuć braki danych w diecie - każdy wiersz, gdzie mamy brak danych w kolumnie vore
  group_by(vore) %>%               # 2. Podziel na grupy
  summarise(                       # 3. Policz statystyki dla grup
    liczba_n = n(),                # Liczebność grupy
    srednia = mean(sleep_total, na.rm = TRUE),   # Średnia, pomiń braki danych
    mediana = median(sleep_total), # Mediana
    odchylenie = sd(sleep_total)   # SD
  ) %>% 
  arrange(desc(srednia))           # 4. Posortuj malejąco

# Zobacz wynik
print(wyniki_grupowe)

# 7. Zapisywanie danych do pliku

# Zapiszmy wyniki w pliku
writexl::write_xlsx(wyniki_grupowe, 'wyniki/wyniki_grupowe.xlsx') #korzystamy z biblioteki writexl
# Stwórz folder wyniki i zapisz
dir.create('wyniki') 
# Możesz też zapisać w formie pliku csv
write_csv(wyniki_grupowe, 'wyniki/wyniki_grupowe.csv')


# 8. Wczytywanie innych typów plików

# Wersja standardowa (przecinek rozdziela kolumny)
dane <- read_csv("data/dane_usa.csv")

# Wersja "Polska" (średnik rozdziela kolumny, przecinek to ułamek)
# Jeśli Twój plik CSV wygląda dziwnie po wczytaniu - spróbuj tego!
dane_pl <- read_csv2("data/dane_polska.csv")

# Wersja uniwersalna (sami ustalamy separator)
dane_txt <- read_delim("data/plik_tekstowy.txt", delim = "\t") # np. tabulator

# Pliki natywne
# Zapisywanie (np. po czyszczeniu danych)
write_rds(dane_przetworzone, "output/czyste_dane.rds")

# Wczytywanie (działa błyskawicznie)
dane_szybkie <- read_rds("output/czyste_dane.rds")

