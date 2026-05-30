# ALL-IDB Patches

<p align="center">
  <img src="https://iebil.di.unimi.it/cnnALL/imgs/outline_allidb_patches.jpg" alt="ALL-IDB Patches workflow" width="850">
</p>

<p align="center">
  <a href="https://github.com/AngeloUNIMI/ALL-IDB-Patches"><img alt="GitHub repository" src="https://img.shields.io/badge/GitHub-Code%20Repository-181717?logo=github"></a>
  <a href="https://huggingface.co/datasets/AngeloUNIMI/ALL-IDB-Patches"><img alt="Hugging Face dataset" src="https://img.shields.io/badge/%F0%9F%A4%97%20Hugging%20Face-Dataset-yellow"></a>
  <a href="https://ieeexplore.ieee.org/document/10193429"><img alt="Paper" src="https://img.shields.io/badge/Paper-IEEE%20Xplore-00629B"></a>
  <a href="https://iebil.di.unimi.it/cnnALL/index.htm"><img alt="Project page" src="https://img.shields.io/badge/Project%20page-ALL--IDB%20Patches-blue"></a>
  <img alt="Language" src="https://img.shields.io/badge/MATLAB-100%25-orange">
  <a href="LICENSE"><img alt="License" src="https://img.shields.io/badge/License-GPL--3.0-green"></a>
</p>

MATLAB source code for creating image patches and labels used in the paper **“ALL-IDB Patches: Whole slide imaging for Acute Lymphoblastic Leukemia detection using Deep Learning”**, presented at **ICASSP Workshops 2023**.

The repository converts annotated ALL-IDB1 whole-slide microscope images into fixed-size overlapping patches, preserving the position of white blood cell centroids and generating patch-level labels for probable lymphoblasts and other cases.

---

## Overview

Acute Lymphoblastic Leukemia detection from microscopy images requires careful handling of large images, sparse cell annotations, and patch-level labels. This code provides a reproducible MATLAB workflow to prepare the ALL-IDB1 images for deep learning experiments by:

- reading the original ALL-IDB1 images;
- reading blast centroid annotations from `.xyc` files;
- merging blast and other-cell annotations;
- splitting each image into overlapping patches;
- assigning patch-level labels according to the cells contained in each patch;
- storing patch metadata and local centroid coordinates.

The main entry point is:

```text
launch_create_labels_patches.m
```

---

## Repository structure

```text
ALL-IDB-Patches/
├── ALL-IDB1/
│   └── other/                  # Additional annotations for non-blast cells
├── functions/                  # Helper functions used by the main script
├── launch_create_labels_patches.m
├── outline_allidb_patches.jpg
├── README.md
└── LICENSE
```

After running the script, additional folders are generated inside `ALL-IDB1/`, including merged labels and patch outputs.

---

## Requirements

### Software

- MATLAB
- Image Processing Toolbox, for functions such as `blockedImage`, `blockedImageDatastore`, `selectBlockLocations`, and visualization utilities

The code was designed as MATLAB source code for the ICASSPW 2023 paper. Depending on your MATLAB version, functions related to blocked images may require a recent MATLAB release.

### Dataset

This repository does **not** redistribute the complete ALL-IDB dataset. You need to download the original images and annotations separately.

Required folders:

```text
ALL-IDB1/im/     # Original ALL-IDB1 images, e.g. Im001_1.jpg, Im002_1.jpg, ...
ALL-IDB1/xyc/    # Original blast centroid annotations, e.g. Im001_1.xyc, Im002_1.xyc, ...
ALL-IDB1/other/  # Additional annotations for other-cell cases
```

The ALL-IDB database can be obtained from the official project page:

- Acute Lymphoblastic Leukemia Image Database for Image Processing: https://homes.di.unimi.it/scotti/all/

---

## How to use

### 1. Clone the repository

```bash
git clone https://github.com/AngeloUNIMI/ALL-IDB-Patches.git
cd ALL-IDB-Patches
```

### 2. Add the ALL-IDB1 data

Create or populate the following folders:

```text
ALL-IDB1/im/
ALL-IDB1/xyc/
ALL-IDB1/other/
```

Example expected files:

```text
ALL-IDB1/im/Im001_1.jpg
ALL-IDB1/xyc/Im001_1.xyc
ALL-IDB1/other/Im001_1.xyc
```

### 3. Run the patch generation script

Open MATLAB in the repository root and run:

```matlab
launch_create_labels_patches
```

The script will:

1. add the `functions/` directory to the MATLAB path;
2. read blast and other-cell annotations;
3. write merged annotation files;
4. split each ALL-IDB1 image into patches;
5. save patch images and metadata.

---

## Default patch-generation parameters

The main script currently uses the following settings:

| Parameter | Default value | Description |
|---|---:|---|
| `sizePatches` | `256` | Patch size in pixels |
| `overlapPct` | `0.25` | Patch overlap, corresponding to 25% |
| `pixelToll` | `5` | Pixel tolerance when checking whether a centroid belongs to a patch |
| `dbname` | `ALL-IDB1` | Dataset folder |
| `extImg` | `jpg` | Input image extension |
| `extLabels` | `xyc` | Annotation file extension |

The output patch folder name is generated automatically from these values, for example:

```text
ALL-IDB1/patches_256_overlap_0.25_toll_5/
```

---

## Output files

The script creates patch images and metadata under a generated patch directory:

```text
ALL-IDB1/patches_256_overlap_0.25_toll_5/
├── Im001_1_patch_1.tif
├── Im001_1_patch_2.tif
├── ...
└── info/
    ├── Im001_1_patch_1.mat
    ├── Im001_1_patch_2.mat
    └── ...
```

Each patch is associated with patch-level information, including:

- whether at least one probable lymphoblast is present;
- whether at least one other-cell case is present;
- local centroid coordinates for probable lymphoblasts;
- local centroid coordinates for other-cell cases.

---

## Label format

Merged label files are written with two sections:

```text
WBC_probable_lymphoblasts
x1 y1
x2 y2
...
Other_cases
x1 y1
x2 y2
...
```

During patch extraction, centroid coordinates are converted from image-level coordinates to patch-level coordinates and bounded within the patch size.

---

## Reproducibility notes

To reproduce the patch-generation procedure used by this repository:

1. use the same ALL-IDB1 image and annotation files;
2. keep the default patch size, overlap, and tolerance settings;
3. run the script from the repository root;
4. keep the expected folder structure unchanged.

For experiments derived from these patches, report the parameter values used for patch extraction, since changes to patch size, overlap, or tolerance may alter the number of generated samples and their labels.

---

## Paper

If you use this code, please cite the corresponding paper:

```bibtex
@InProceedings{genovese2023allidbpatches,
  author    = {A. Genovese and V. Piuri and F. Scotti},
  title     = {ALL-IDB Patches: Whole slide imaging for Acute Lymphoblastic Leukemia detection using Deep Learning},
  booktitle = {Proc. of the IEEE Int. Conf. on Acoustics Speech and Signal Processing Workshops (ICASSPW 2023)},
  address   = {Rhodes Island, Greece},
  pages     = {1--5},
  month     = {June},
  year      = {2023},
  note      = {ISBN: 979-8-3503-0261-5},
  doi       = {10.1109/ICASSPW59220.2023.10193429}
}
```

---

## Dataset citation

Please also cite the original ALL-IDB dataset paper when using the ALL-IDB images:

```bibtex
@InProceedings{donidalabati2011allidb,
  author    = {R. Donida Labati and V. Piuri and F. Scotti},
  title     = {ALL-IDB: The acute lymphoblastic leukemia image database for image processing},
  booktitle = {Proc. of the 2011 IEEE Int. Conf. on Image Processing (ICIP 2011)},
  address   = {Brussels, Belgium},
  pages     = {2045--2048},
  month     = {September},
  year      = {2011},
  note      = {ISBN: 978-1-4577-1302-6},
  doi       = {10.1109/ICIP.2011.6115881}
}
```

---

## License

This project is released under the **GNU General Public License v3.0**. See [`LICENSE`](LICENSE) for details.

---

## Links

- Paper: https://ieeexplore.ieee.org/document/10193429
- Project page: https://iebil.di.unimi.it/cnnALL/index.htm
- ALL-IDB dataset: https://homes.di.unimi.it/scotti/all/
