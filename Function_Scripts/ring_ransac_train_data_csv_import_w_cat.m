function data_import = ring_ransac_train_data_csv_import_w_cat(filename)
%IMPORTFILE Import data from a text file
%  RAWDATAEXPORT20233717120346ASPHALT15 = IMPORTFILE(FILENAME) reads
%  data from text file FILENAME for the default selection.  Returns the
%  data as a table.
%
%  RAWDATAEXPORT20233717120346ASPHALT15 = IMPORTFILE(FILE, DATALINES)
%  reads data for the specified row interval(s) of text file FILENAME.
%  Specify DATALINES as a positive scalar integer or a N-by-2 array of
%  positive scalar integers for dis-contiguous row intervals.
%
%  Example:
%  rawdataexport20233717120346asphalt15 = importfile("/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/TRAINING_DATA/CSV_Export/RANSAC_Feat_Extract/Asph/raw_data_export_20233717120346_asphalt_1_5.csv", [2, Inf]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 28-Mar-2023 10:26:04

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [2, Inf];
end

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 11);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["StandDevHeightRAN", "RoughnessHeightRAN", "MinMaxRatioHeightRAN", "Min2MaxRatioHeightRAN", "MagGradientHeightRAN", "StandDevInt", "RangeInt", "MedMaxRatioInt", "Med2MaxRatioInt", "MagGradientInt", "terrain_type"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "categorical"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, "terrain_type", "EmptyFieldRule", "auto");

% Import the data
data_import = readtable(filename, opts);

end