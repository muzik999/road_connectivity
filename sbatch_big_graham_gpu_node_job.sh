#!/bin/bash
#SBATCH --gres=gpu:2
#SBATCH --cpus-per-task=18
#SBATCH --mem=127518M
#SBATCH --time=2:58:55
#SBATCH --account=def-ka3scott

module load python/3.7
source $HOME/road_pytorchPy37/bin/activate
CUDA_VISIBLE_DEVICES=0,1 python train_mtl.py --config test_config.json --dataset stratford --model_name "StackHourglassNetMTL" --exp dg_stak_mtl_24hr_stratford2_TESING__