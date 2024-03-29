function data_import = ring_train_data_csv_import_w_cat(filename)
%IMPORTFILE Import data from a text file
%  RAWDATAEXPORT202303111303281 = IMPORTFILE(FILENAME) reads data from
%  text file FILENAME for the default selection.  Returns the data as a
%  table.
%
%  RAWDATAEXPORT202303111303281 = IMPORTFILE(FILE, DATALINES) reads data
%  for the specified row interval(s) of text file FILENAME. Specify
%  DATALINES as a positive scalar integer or a N-by-2 array of positive
%  scalar integers for dis-contiguous row intervals.
%
%  Example:
%  rawdataexport202303111303281 = importfile("/media/autobuntu/chonk/chonk/git_repos/Rural-Road-Lane-Creator/Random_Forest/Save_Bulk_All_4/Grav_Feat_Extract/Grav_Feat_Extract_1/raw_data_export_20230311130328_1.csv", [2, Inf]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 14-Mar-2023 11:17:55

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
opts.VariableNames = ["StandDevRange", "RoughnessRange", "MinMaxRatioRange", "Min2MaxRatioRange", "MagGradientRange", "StandDevInt", "MeanInt", "RangeInt", "MedMaxRatioInt", "Med2MaxRatioInt", "MagGradientInt", "terrain_type"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "categorical"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, "terrain_type", "EmptyFieldRule", "auto");

% Import the data
data_import = readtable(filename, opts);

end