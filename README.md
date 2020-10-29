## Improved Road Connectivity by Joint Learning of Orientation and Segmentation ##
#### In CVPR 2019 [[pdf]](https://anilbatra2185.github.io/papers/RoadConnectivityCVPR2019.pdf) [[supplementary]](https://anilbatra2185.github.io/papers/RoadConnectivity_CVPR_Supplementary.pdf)

## Overview
<img src='https://github.com/anilbatra2185/road_connectivity/blob/master/assests/images/overview.png' width="800">

## Requirements
* [PyTorch](https://pytorch.org/) (version = 1.6.0) working, (version = 0.3.0) original
* Torchvision (version = 0.7.0) working
* [sknw](https://github.com/yxdragon/sknw)
* [networkx](https://networkx.github.io/) (version = 2.4)
* json
* skimage
* numpy
* tqdm

## Data Preparation

#### PreProcess Spacenet Data
- Convert Spacenet 11-bit images to 8-bit Images, country wise.
- Create Gaussian Road Masks, country wise.
- Move all data to single folder.

*Default Spacenet3 tree structure assumed.*
```
spacenet3
│
└───AOI_2_Vegas_Train
│   └───RGB-PanSharpen
│   └───geojson
│   └───summaryData
│
└───AOI_3_Paris_Train
│   └───RGB-PanSharpen
│   └───geojson
│   └───summaryData
|
└───AOI_4_Shanghai_Train
|   .
|
└───AOI_5_Khartoum_Train
|   .
|
```

```
cd preprocessing
bash prepare_spacenet.sh /spacenet3
```
#### Split Datasets
*Spacenet tree structure created by preprocessing.*
```
spacenet3
|
└───full
│   └───gt
│   └───images
```

```
*Script to split and save in **'/data/spacenet'**.*
```
bash split_data.sh /spacenet3/full /data/spacenet/ .png .png
```
#### Create Crops

```
data/spacenet
|   train.txt
|   val.txt
|   train_crops.txt   # created by script
|   val_crops.txt     # created by script
|
└───train
│   └───gt
│   └───images
└───val
│   └───gt
│   └───images
└───train_crops       # created by script
│   └───gt
│   └───images
└───val_crops         # created by script
│   └───gt
│   └───images
```
```
python create_crops.py --base_dir /data/spacenet/ --crop_size 650 --crop_overlap 215 --im_suffix .png --gt_suffix .png
```
## Visualize Data
* Road Orientation - [Notebook](/road_connectivity/blob/master/visualize_tasks.ipynb)
* Training Dataset - [Notebook](/road_connectivity/blob/master/visualize_dataset.ipynb)
* Linear Corruption (Connectivity Refinement) - [Notebook](/road_connectivity/blob/master/visualize_dataset_corrupt.ipynb)

## Training

Train Multi-Task learning framework to predict road segmentation and road orientation.

__Training MTL Help__
```
usage: train_mtl.py [-h] --config CONFIG
                    --model_name {StackHourglassNetMTL}
                    --dataset {spacenet}
                    --exp EXP
                    [--resume RESUME]
                    [--model_kwargs MODEL_KWARGS]
                    [--multi_scale_pred MULTI_SCALE_PRED]

optional arguments:
  -h, --help            show this help message and exit
  --config CONFIG       config file path
  --model_name 			{StackHourglassNetMTL}
                        Name of Model = ['StackHourglassNetMTL']
  --exp EXP             Experiment Name/Directory
  --resume RESUME       path to latest checkpoint (default: None)
  --dataset 			{spacenet}
                        select dataset name from ['spacenet'].
  --model_kwargs 		MODEL_KWARGS
                        parameters for the model
  --multi_scale_pred 	MULTI_SCALE_PRED
                        perform multi-scale prediction (default: True)
```

__Sample Usage__

* Training with StackModule
```
CUDA_VISIBLE_DEVICES=0,1 python train_mtl.py --config config.json --dataset spacenet --model_name "StackHourglassNetMTL" --exp dg_stak_mtl
```

## Evaluate APLS

* Please use Java implementation to compute APLS provided by Spacenet Challenge. - [Visualizer tool](https://drive.google.com/file/d/1rwbj_o-ELBfruPZuVkCnEQxAX2-Pz5DX/view)
* For more info refer issue [#13](https://github.com/anilbatra2185/road_connectivity/issues/13)


## Connectivity Refinement

* Training with Linear Artifacts/Corruption (using LinkNe34 Architecture)
```
CUDA_VISIBLE_DEVICES=0,1 python train_refine_pre.py --config config.json --dataset spacenet --model_name "StackHourglassNetMTL" --exp spacenet_L34_pre_train_with_corruption --multi_scale_pred false
```

