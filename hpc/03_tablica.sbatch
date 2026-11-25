#!/bin/bash
# ==========================================================
# Zadanie tablicowe (array job): 4 kopie skryptu naraz,
# każda liczy inną grupę diety.
# Uruchom Z FOLDERU PROJEKTU:
#     sbatch hpc/03_tablica.sbatch
# ==========================================================
#SBATCH --job-name=r_tablica
#SBATCH --account=NAZWA_GRANTU        # TODO
#SBATCH --partition=NAZWA_PARTYCJI    # TODO
#SBATCH --time=00:10:00               # limit dla KAŻDEJ kopii osobno
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=2G
#SBATCH --array=1-4                   # numery zadań: 1, 2, 3, 4
#SBATCH --output=logi/%x_%A_%a.out    # %A = numer całej tablicy, %a = numer kopii

set -euo pipefail
cd "$SLURM_SUBMIT_DIR"
module load R    # TODO: np. module load R/4.4.1

echo "Kopia nr $SLURM_ARRAY_TASK_ID | węzeł: $(hostname)"
Rscript skrypty/07b_zadanie_tablicowe.R
