#!/bin/bash
# ==========================================================
# Zadanie wsadowe z wieloma rdzeniami: skrypt 07_R_na_HPC.R
# Uruchom Z FOLDERU PROJEKTU:
#     sbatch hpc/02_rownolegle.sbatch
# ==========================================================
#SBATCH --job-name=r_rownolegle
#SBATCH --account=NAZWA_GRANTU        # TODO
#SBATCH --partition=NAZWA_PARTYCJI    # TODO
#SBATCH --time=00:15:00
#SBATCH --ntasks=1                    # JEDEN proces R...
#SBATCH --cpus-per-task=4             # ...który dostaje 4 rdzenie (R odczyta to z SLURM_CPUS_PER_TASK)
#SBATCH --mem=4G
#SBATCH --output=logi/%x_%j.out

set -euo pipefail
cd "$SLURM_SUBMIT_DIR"
module load R    # TODO: np. module load R/4.4.1

echo "Start: $(date) | węzeł: $(hostname) | rdzenie: $SLURM_CPUS_PER_TASK"
Rscript skrypty/07_R_na_HPC.R
echo "Koniec: $(date)"
