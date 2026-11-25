#!/bin/bash
# ==========================================================
# Zadanie wsadowe: cała analiza ze skryptu 06_integracja.R
# Uruchom Z FOLDERU PROJEKTU (tam, gdzie jest plik .Rproj):
#     sbatch hpc/01_analiza.sbatch
# ==========================================================
#SBATCH --job-name=analiza_ssaki      # nazwa widoczna w squeue
#SBATCH --account=NAZWA_GRANTU        # TODO: Twój grant obliczeniowy
#SBATCH --partition=NAZWA_PARTYCJI    # TODO: np. kolejka CPU (sprawdź: sinfo)
#SBATCH --time=00:10:00               # maks. czas (gg:mm:ss) - potem SLURM przerwie zadanie
#SBATCH --ntasks=1                    # jeden proces R
#SBATCH --cpus-per-task=1             # jeden rdzeń wystarczy
#SBATCH --mem=2G                      # pamięć RAM
#SBATCH --output=logi/%x_%j.out       # log: %x = nazwa zadania, %j = numer zadania

# Zatrzymaj skrypt przy pierwszym błędzie
set -euo pipefail

# Przejdź do folderu, z którego wysłano zadanie (= folder projektu)
cd "$SLURM_SUBMIT_DIR"

# Załaduj R (dokładną nazwę modułu sprawdzisz poleceniem: module avail R)
module load R    # TODO: np. module load R/4.4.1

echo "Start: $(date) | węzeł: $(hostname)"
Rscript skrypty/06_integracja.R
echo "Koniec: $(date)"
