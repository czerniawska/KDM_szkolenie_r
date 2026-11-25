# R na klastrze HPC – ściągawka

## 1. Węzeł logowania to „recepcja”, nie „laboratorium”

Po zalogowaniu (`ssh`) trafiasz na **węzeł logowania**. Jest jeden dla wszystkich użytkowników.

| Na węźle logowania **wolno** | Na węźle logowania **nie wolno** |
|---|---|
| edytować pliki, kopiować dane | uruchamiać analiz (`Rscript analiza.R`) |
| instalować pakiety R (tu jest internet) | liczyć czegokolwiek dłużej niż minutę |
| wysyłać zadania (`sbatch`) | uruchamiać R z wieloma rdzeniami |
| sprawdzać kolejkę (`squeue`) | |

Obliczenia odbywają się na **węzłach obliczeniowych**. Dostajesz je na dwa sposoby:

- **zadanie wsadowe** – piszesz plik `.sbatch` i wysyłasz go do kolejki (sposób podstawowy),
- **sesja interaktywna** – do testów i nauki:

```bash
srun --account=NAZWA_GRANTU --partition=NAZWA_PARTYCJI \
     --time=01:00:00 --cpus-per-task=2 --mem=4G --pty bash
module load R
R            # teraz pracujesz na węźle obliczeniowym
```

Po zakończeniu wpisz `exit`, żeby zwolnić zasoby.

> Uwaga: węzły obliczeniowe często **nie mają dostępu do internetu**.
> Pakiety instaluj na węźle logowania (`install.packages()`), zanim wyślesz zadanie.

## 2. Zadania wsadowe (SLURM)

Pliki w tym folderze to gotowe wzory. Przed pierwszym użyciem uzupełnij w nich miejsca oznaczone `TODO`:
nazwę grantu, partycję i wersję modułu R.

| Plik | Co robi |
|---|---|
| `01_analiza.sbatch` | uruchamia `skrypty/06_integracja.R` na 1 rdzeniu |
| `02_rownolegle.sbatch` | uruchamia `skrypty/07_R_na_HPC.R` na 4 rdzeniach |
| `03_tablica.sbatch` | uruchamia 4 kopie `skrypty/07b_zadanie_tablicowe.R` naraz |

Zadania wysyłaj **z folderu projektu** (tam, gdzie leży plik `.Rproj`):

```bash
cd ~/KDM_szkolenie_r
sbatch hpc/01_analiza.sbatch
```

### Najważniejsze polecenia

| Polecenie | Do czego służy |
|---|---|
| `sbatch plik.sbatch` | wyślij zadanie do kolejki |
| `squeue -u $USER` | moje zadania: `PD` = czeka, `R` = działa |
| `scancel 123456` | anuluj zadanie o numerze 123456 |
| `sacct -j 123456 --format=JobID,State,Elapsed,MaxRSS` | jak poszło zadanie (czas, zużyta pamięć) |
| `sinfo` | dostępne partycje (kolejki) |
| `module avail R` | dostępne wersje R |
| `cat logi/analiza_ssaki_123456.out` | podgląd logu |
| `tail -f logi/analiza_ssaki_123456.out` | podgląd logu na żywo (wyjście: Ctrl+C) |

### Najważniejsze opcje `#SBATCH`

| Opcja | Znaczenie | Co się stanie, gdy za mało? |
|---|---|---|
| `--time=01:00:00` | maks. czas działania | SLURM przerwie zadanie (`TIMEOUT`) |
| `--mem=4G` | pamięć RAM | zadanie zostanie zabite (`OUT_OF_MEMORY`) |
| `--cpus-per-task=4` | rdzenie dla jednego procesu R | R policzy wolniej, ale poprawnie |
| `--array=1-10` | 10 kopii zadania | – |
| `--output=logi/%x_%j.out` | plik z logiem | – |

Zasada: prosimy o trochę więcej, niż potrzeba, ale nie o dużo więcej. Większe żądania dłużej czekają w kolejce.
Ile zadanie naprawdę zużyło, pokaże `sacct`.

## 3. Obliczenia równoległe w R

```r
library(parallel)

# NIE: detectCores() - pokazuje wszystkie rdzenie węzła, nie Twoje
# TAK: liczba rdzeni przydzielona przez SLURM
liczba_rdzeni <- as.integer(Sys.getenv("SLURM_CPUS_PER_TASK", unset = "1"))

wyniki <- mclapply(1:1000, moja_funkcja, mc.cores = liczba_rdzeni)
```

Kiedy co wybrać?

- **Jeden skrypt, wiele rdzeni** (`--cpus-per-task` + `mclapply`) – gdy w jednej analizie są tysiące niezależnych powtórzeń (bootstrap, permutacje, symulacje).
- **Zadanie tablicowe** (`--array` + `SLURM_ARRAY_TASK_ID`) – gdy tę samą analizę trzeba powtórzyć dla wielu niezależnych kawałków (grupy, pliki, geny, parametry).

## 4. Praca bez ekranu

W zadaniu wsadowym nikt nie patrzy na ekran:

- `View()` nie działa. Owiń je w `if (interactive()) { ... }`.
- Wykresy **zapisuj** przez `ggsave("wyniki/wykres.png", ...)`. Wyświetlony wykres po prostu zniknie.
- Tabele zapisuj przez `write_csv()`, a obiekty R przez `write_rds()`.
- Wszystko, co R wypisuje (`print()`, `cat()`, komunikaty, **błędy**), trafia do pliku w `logi/`. Gdy coś nie działa, zacznij od logu.
- Na końcu skryptu warto dodać `sessionInfo()`. Wtedy w logu zostaje informacja o wersjach R i pakietów.

### Jak skopiować wyniki z klastra na swój komputer?

Polecenie wpisz **na swoim komputerze** (nie na klastrze):

```bash
# cały folder wyniki/
scp -r LOGIN@ADRES_KLASTRA:~/KDM_szkolenie_r/wyniki ./wyniki_z_klastra

# lub (szybciej przy wielu plikach, kopiuje tylko zmiany)
rsync -av LOGIN@ADRES_KLASTRA:~/KDM_szkolenie_r/wyniki/ ./wyniki_z_klastra/
```

Można też użyć programu graficznego, np. WinSCP (Windows) lub Cyberduck (macOS),
albo przeglądarki plików w Open OnDemand, jeśli klaster go udostępnia.
