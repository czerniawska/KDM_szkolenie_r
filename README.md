# KDM_szkolenie_r
Wprowadzenie do R - Tidyverse first

---

## Jak pobrać materiały z GitHuba?

Nie musisz mieć konta na GitHubie ani znać programu Git. Wystarczy pobrać jeden plik ZIP.

### Sposób 1: Pobranie pliku ZIP (polecany)

1. Wejdź na stronę repozytorium: **https://github.com/czerniawska/KDM_szkolenie_r**
2. Kliknij zielony przycisk **`<> Code`** (nad listą plików, po prawej stronie).
3. W menu, które się rozwinie, wybierz **Download ZIP**.
4. Znajdź pobrany plik `KDM_szkolenie_r-main.zip` (zwykle w folderze *Pobrane*).
5. **Rozpakuj** archiwum:
   - **Windows:** kliknij plik prawym przyciskiem myszy → *Wyodrębnij wszystkie...* → *Wyodrębnij*.
   - **macOS:** kliknij plik dwukrotnie.
6. Przenieś rozpakowany folder w wygodne miejsce, np. na *Pulpit* lub do *Dokumentów*.

> **Uwaga:** nie otwieraj plików bezpośrednio z archiwum ZIP (bez rozpakowania).
> R nie zobaczy wtedy folderu `dane` i wczytywanie plików zakończy się błędem.

### Sposób 2: Bezpośrednio z R (dla chętnych)

Wklej poniższy kod do konsoli RStudio. R sam pobierze, rozpakuje i otworzy projekt:

```r
install.packages("usethis")   # tylko za pierwszym razem
usethis::use_course("czerniawska/KDM_szkolenie_r")
```

R zapyta, czy zapisać folder w proponowanym miejscu. Odpowiedz, wpisując numer opcji oznaczającej zgodę (np. „Yes”).

### Co dalej? Otwórz projekt

1. Wejdź do rozpakowanego folderu `KDM_szkolenie_r-main` (nazwę folderu możesz zmienić, np. na `warsztaty_R`).
2. Kliknij dwukrotnie plik **`kdm_warsztaty_r.Rproj`**. Otworzy się RStudio.
3. Sprawdź w prawym górnym rogu RStudio, czy widnieje nazwa projektu `kdm_warsztaty_r` (a nie *Project: (None)*).
4. W panelu *Files* (prawy dolny róg) otwórz folder `skrypty` i zacznij od pliku `01_warsztat_start.R`.

Zawsze otwieraj materiały przez plik `.Rproj`. Dzięki temu R „wie”, gdzie jest folder projektu, i ścieżki typu `"dane/ssaki.csv"` działają bez zmian.

### Co jest w środku?

| Folder / plik | Zawartość |
|---|---|
| `skrypty/` | Skrypty do kolejnych lekcji (01–07) |
| `hpc/` | Wzory zadań SLURM (`.sbatch`) i ściągawka do pracy na klastrze |
| `logi/` | Tu SLURM zapisuje logi zadań (folder musi istnieć – nie usuwaj go) |
| `dane/` | Dane do ćwiczeń (`ssaki.csv`, `ssaki.xlsx`) |
| `zadanie/` | Zadanie do samodzielnego wykonania wraz z danymi |
| `kdm_warsztaty_r.Rproj` | Plik projektu – od niego zaczynamy |

### Pobieranie aktualizacji

Jeśli materiały zostaną poprawione, najprościej pobrać ZIP jeszcze raz (Sposób 1) i rozpakować go do nowego folderu.
Swoje notatki i wyniki skopiuj ze starego folderu do nowego.

---

## Jak ćwiczyć z AI?

Asystenci AI (np. ChatGPT, Claude, Gemini, Copilot) mogą przyspieszyć naukę R, ale tylko wtedy, gdy traktujesz ich jak **korepetytora**, a nie jak kogoś, kto odrabia za Ciebie pracę domową.
W skryptach znajdziesz ramki **`[ĆWICZ Z AI]`** z gotowymi poleceniami (promptami) do wypróbowania.

### Pięć sprawdzonych sposobów

| Cel | Przykładowe polecenie |
|---|---|
| **Wyjaśnienie** | „Wyjaśnij linijka po linijce, co robi ten kod: [kod]. Na koniec zadaj mi 2 pytania sprawdzające.” |
| **Ćwiczenia** | „Wymyśl 5 zadań na funkcję filter() dla tabeli z kolumnami: [lista]. Bez rozwiązań.” |
| **Wskazówka zamiast gotowca** | „Utknęłam/utknąłem przy [opis]. Nie podawaj kodu, tylko podpowiedz, której funkcji użyć.” |
| **Zrozumienie błędu** | „Co oznacza ten błąd: [pełny komunikat]? Wyjaśnij przyczynę, zanim podasz poprawkę.” |
| **Recenzja kodu** | „Zrób code review mojego skryptu. Nie przepisuj go, wypisz uwagi w punktach.” |

### Zasady bezpieczeństwa

- **Sprawdzaj w R.** AI potrafi wymyślić nieistniejącą funkcję lub argument. Uruchom kod i zajrzyj do pomocy (`?nazwa_funkcji`).
- **Nie wklejaj danych wrażliwych.** Żadnych danych pacjentów, danych osobowych ani nieopublikowanych wyników. Wystarczą nazwy kolumn i kilka zmyślonych wierszy (możesz je przygotować przez `dput(head(dane))` na danych przykładowych).
- **Nie wklejaj haseł, kluczy SSH ani tokenów**, także przy pytaniach o klaster HPC.
- **Rozumiesz – używasz.** Nie wklejaj do swojej analizy kodu, którego nie potrafisz wyjaśnić.

### AI w RStudio

RStudio ma wbudowaną integrację z GitHub Copilot (*Tools → Global Options → Copilot*), który podpowiada kod w trakcie pisania.
**Na początku nauki warto go wyłączyć.** Podpowiedzi pojawiają się szybciej, niż zdążysz pomyśleć, a ręczne pisanie pierwszych skryptów najlepiej utrwala składnię.
Wróć do niego, gdy podstawy będą już pewne.

