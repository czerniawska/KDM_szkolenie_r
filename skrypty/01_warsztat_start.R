# ==========================================================
# LEKCJA 1: Rozgrzewka i środowisko
# ==========================================================

# 1. Testowanie Konsoli vs skryptu
# Ustaw kursor w linii poniżej i wciśnij Ctrl+Enter (Cmd+Enter)
2 * 50

# Zobacz, że wynik pojawił się na dole (Console), 
# ale nie został zapamiętany w pamięci komputera.

# 2. Tworzenie zmiennych (Przypisanie) 
# Operator przypisania to strzałka "<-" (skrót: Alt + minus lub Option + minus)
# Możecie również używać pojedynczego znaku =
wynik_eksperymentu <- 105.5

# Spójrz w prawo na panel "Environment". Widzisz tam tę zmienną?
# Teraz R "pamięta" tę liczbę.

wynik_eksperymentu * 2

# 3. Sprawdzenie "Gdzie ja jestem?" (R Projects) 
getwd() 
# Powinieneś widzieć ścieżkę do folderu, w którym masz ten projekt.
# To jest nasza "baza".

# 4. Ładowanie Pakietów 
# Pakiety instalujemy tylko raz (install.packages), 
# ale włączamy (library) za każdym razem po włączeniu RStudio.

#install.packages('tidyverse')
library(tidyverse)

# Jeśli widzisz komunikat "Conflicts" - nie panikuj. 
# To normalna informacja, że tidyverse nadpisuje niektóre stare funkcje R.