PCD STACK RDF CLASSIFIER

PCD_STACK_CLASSIFIER.m allows for classification of LiDAR data as gravel, chipseal, grass, or foliage using an RDF. 

There are two (2) tools atm that will do parts of the main script in case of failure in the main script or some other shenanigans like idk testing

Plotter.m plots the files in the desired root directory that has a legit RESULT_EXPORT folder

Result_Exporter.m compiles the results in from a CLASSIFICATION_STACK folder in the desired root directory

===========================================================================

Consecutive point cloud scans may be made using the lidar2Geo.m script found in the OU_IdeasLab_Matlab_PCD_Maker_Take_2 Repo.

This allows for creating of manually defined areas for use in scoring the classification results using the Manual_Classifier.m script. 
