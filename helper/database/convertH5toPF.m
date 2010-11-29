%author Sandy Buschmann, Jan Winter TU Berlin
%email j.winter@tu-berlin.de
% end preferences:
DIR = 'Z:\Postfach\Transfer zu Winter\Sandy\Datenbank\2009_03_03 Flurweg Leuchtdichtebilder';
DATAPATH = 'C:\Dokumente und Einstellungen\admin\Eigene Dateien\MATLAB\LMK_2010_10_25\LMK_Data_evaluation';
DATABASE = 'DB'; % folder where the .pf-data should be saved
NEED_SUBFOLDERS = 1; % 0 or 1 when subfolders should be made
SUBFOLDER1 = 'VS'; % name of subfolder 1
SUBFOLDER2 = 'VL'; % name of subfolder 2
SUB_DATANAME1 = 'VS'; % string within the data name for subfolder 1
SUB_DATANAME2 = 'VL'; % string within the data name for subfolder 2
MY_MATLAB_ROOT = 'C:\Dokumente und Einstellungen\admin\Eigene Dateien\MATLAB\';
% end preferences

%add directories for LMK functions
addpath(genpath(MY_MATLAB_ROOT));

% init CamNApp
LMK_initApp(1,'');

% make database and sub folder
mkdir(DATABASE);
if NEED_SUBFOLDERS == 1
    mkdir([DATAPATH, '\', DATABASE, '\', SUBFOLDER1]);
    mkdir([DATAPATH, '\', DATABASE, '\', SUBFOLDER2]);
end

% list DB filenames into cell array:
arr = ls(DIR);
arr = cellstr(arr); 
l = length(arr);

% load .h5 files and save luminance pictures as .pf files
for i = 1 : l
   [pathstr, name, ext, versn] = fileparts(arr{i});
   h5match = strcmp(ext, '.h5');
   if h5match == 1       
        filename = strcat(DIR, '\', name, ext);
        [~] = LMK_loadH5Protocol(filename);
        % save luminance pictures from labSoft into file: 
        if NEED_SUBFOLDERS == 1
            nameMatch1 = strfind(name, SUB_DATANAME1);
            if ~isempty(nameMatch1)
                dir_name = [DATAPATH, '\', DATABASE, '\', SUBFOLDER1];
            end
            nameMatch2 = strfind(name, SUB_DATANAME2);      
            if ~isempty(nameMatch2)
                dir_name = [DATAPATH, '\', DATABASE, '\', SUBFOLDER2];
            end
        else
            dir_name = [DATAPATH, '\', DATABASE];
        end
        val_date = 0;
        date_time = clock;
        picformat = '.pf';
        [text, file_path] = LMK_saveSinglePic(dir_name, name, ...
            val_date, date_time, picformat);
   end
end

