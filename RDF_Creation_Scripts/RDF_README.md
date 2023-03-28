RDF_Training_Data_Extraction.m Extracts training data from consecutive LiDAR points that lie on manually defined areas. Load a PCD and define areas from which data is to be extracted. Send this script the source rosbag and the manually defined areas file. Features are extracted using one of the desired feature sets, defined in a function in the Feat_List folder. Results are exported in a single .mat file that contains training data from each individual channel.

RDF_Training_Data_Extraction_Result_Handler.m Extracts the features from the .mat file created with RDF_Training_Data_Extraction.m, and puts each channel's results into a dedicated .csv file.

RDF_Training_Data_Combiner_Splitter.m Loads all desired directories with all the .csv files generated with RDF_Training_Data_Extraction_Result_Handler.m. A desired channel is selected. All .csv files in the directory that has that channel tag is compiled. The compiled data is is randomly divided based on a desired percentage into training and testing data. 

RDF_Training.m Loads training data and trains a series of RDFs with increasing number of trees (depth). 

RDF_Validation.m Loads the directory with the generated RDFs and verifies each RDF with the testing data.

RDF_Validation_Result_Plot.m Plots the results from RDF_Validation.m