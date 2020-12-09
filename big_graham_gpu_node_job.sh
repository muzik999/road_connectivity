#!/bin/bash
module load python/3.7
source $HOME/road_pytorchPy37/bin/activate
salloc --nodes=1 --gres=gpu:2 --time=03:00:00 --ntasks=1 --cpus-per-task=18 --mem=127518M --account=def-ka3scott #srun $VIRTUAL_ENV/bin/notebook.sh

# CUDA_VISIBLE_DEVICES=0,1 python train_mtl.py --config test_config.json --dataset stratford --model_name "StackHourglassNetMTL" --exp dg_stak_mtl_TESTING