#!/bin/bash
#SBATCH --gres=gpu:v100:1
#SBATCH --ntasks-per-node=32
#SBATCH --mem=127000M
#SBATCH --time=3:00:00
#SBATCH --account=def-ka3scott

module load python/3.7
source $HOME/road_pytorchPy37/bin/activate

nvidia-smi