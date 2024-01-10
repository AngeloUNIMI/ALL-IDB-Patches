# ALL-IDB Patches

Matlab source code for the paper:

	A. Genovese, V. Piuri, and F. Scotti, 
    "ALL-IDB Patches: Whole slide imaging for Acute Lymphoblastic Leukemia detection using Deep Learning", 
    in Proc. of the IEEE Int. Conf. on Acoustics Speech and Signal Processing Workshops (ICASSPW 2023), 
    Rhodes Island, Greece, June 4-10, 2023, pp. 1-5. 
    ISBN: 979-8-3503-0261-5. [DOI: 10.1109/ICASSPW59220.2023.10193429]
	
Project page:

[https://iebil.di.unimi.it/cnnALL/index.htm](https://iebil.di.unimi.it/cnnALL/index.htm)
    
Outline:
![Outline](https://iebil.di.unimi.it/cnnALL/imgs/outline_allidb_patches.jpg "Outline")

Citation:

	@InProceedings {aimia23,
    author = {A. Genovese and V. Piuri and F. Scotti},
    booktitle = {Proc. of the IEEE Int. Conf. on Acoustics Speech and Signal Processing Workshops (ICASSPW 2023)},
    title = {ALL-IDB Patches: Whole slide imaging for Acute Lymphoblastic Leukemia detection using Deep Learning},
    address = {Rhodes Island, Greece},
    pages = {1-5},
    month = {June},
    day = {4-10},
    year = {2023},
    note = {979-8-3503-0261-5},}

Main files:

- launch_create_labels_patches.m

Required files:
    
- ALL-IDB1/im/ <br/>
    Images of the ALL-IDB1 database, that can be obtained at: <br/>
    https://scotti.di.unimi.it/all/ <br/>
    e.g., ALL-IDB1/im/Im001_1.jpg; ALL-IDB1/im/Im002_1.jpg; ...
    
- ALL-IDB1/xyc
    Position of the blasts of the ALL-IDB1 database, that can be obtained at: <br/>
    https://scotti.di.unimi.it/all/ <br/>
    e.g., ALL-IDB1/xyc/Im001_1.xyc; ALL-IDB1/xyc/Im002_1.xyc; ...
    
The database used in the paper can be obtained at: <br/>
- Acute Lymphoblastic Leukemia Image Database for Image Processing (ALL-IDB) <br/>
https://homes.di.unimi.it/scotti/all/

    R. Donida Labati, V. Piuri, F. Scotti
    "ALL-IDB: the acute lymphoblastic leukemia image database for image processing"
    in Proc. of the 2011 IEEE Int. Conf. on Image Processing (ICIP 2011), 
    Brussels, Belgium, pp. 2045-2048, September 11-14, 2011. 
    ISBN: 978-1-4577-1302-6. [DOI: 10.1109/ICIP.2011.6115881]
    
