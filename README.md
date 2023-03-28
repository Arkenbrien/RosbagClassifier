# Rosbag Classifier

RosbagClassifier.m allows for classification of LiDAR data as gravel, chipseal, or grass using an RDF to examine arcs from seperate LiDAR channels. At the moment, 5 arcs from channels 2, 3, and 5 are used. Two reference points are used for extracting spacial features: Range from LiDAR PoI, and a RANSAC projected plane. Manually defined areas coresponding to the rosbag to be classified allow for determining the accuracy of the classification process. Accuracy results are plotted & saved to disk. 

To run RosbagClassifier.m, the following is needed:
    Rosbag with LiDAR, GPS, and IMU data
    Manual Classification .mat file (see next section)
    RDFs specific to each channel (2, 3, & 5 are provided)


===========================================================================

Consecutive point cloud scans may be made using the lidar2Geo.m script found in the OU_IdeasLab_Matlab_PCD_Maker_Take_2 Repo.

This allows for creating of manually defined areas for use in scoring the classification results using the Manual_Classifier.m script. 


===========================================================================

RDFs may be created from .csv files containing training data, using the RDF_Training.m and RDF_Validation.m scripts.