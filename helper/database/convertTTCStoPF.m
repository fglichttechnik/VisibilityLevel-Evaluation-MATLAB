%AUTHOR: Jan Winter, Sandy Buschmann, Robert Franke TU Berlin, FG Lichttechnik,
%	j.winter@tu-berlin.de, www.li.tu-berlin.de
%LICENSE: free to use at your own risk. Kudos appreciated.
%
% Loads .ttcs protocols into labSoft and saves luminance pictures in .pf 
% format.

% preferences:
DIR = 'C:\Dokumente und Einstellungen\student\Eigene Dateien\MATLAB\LMK';
        % directory where the .ttcs protocols are located
DATAPATH = 'C:\Dokumente und Einstellungen\student\Eigene Dateien\MATLAB\LMK\PF';
        % path to your target database
NEED_SUBFOLDERS = 0; % 0 or 1 when subfolders should be made
SUBFOLDER1 = 'VS'; % name of subfolder 1
SUBFOLDER2 = 'VL'; % name of subfolder 2
SUB_DATANAME1 = 'VS'; % string within the data name for subfolder 1
SUB_DATANAME2 = 'VL'; % string within the data name for subfolder 2
MY_MATLAB_ROOT = '/Users/sandy/Desktop/Development';
% end preferences

%add directories for LMK functions
addpath(genpath(MY_MATLAB_ROOT));

% init CamNApp
LMK_initApp(1,'');

% make database and sub folder
mkdir(DATAPATH);
if NEED_SUBFOLDERS == 1
    mkdir([DATAPATH, '\', SUBFOLDER1]);
    mkdir([DATAPATH, '\', SUBFOLDER2]);
end

% list DB filenames into cell array:
arr = ls(DIR);
arr = cellstr(arr); 
l = length(arr);

% load .h5 files and save luminance pictures as .pf files
for i = 1 : l
   [pathstr, name, ext, versn] = fileparts(arr{i});
   h5match = strcmp(ext, '.ttcs');
   if h5match == 1       
        filename = strcat(DIR, '\', name, ext);
        [~] = LMK_loadTTCSProtocol(filename);
        % save luminance pictures from labSoft into file: 
        if NEED_SUBFOLDERS == 1
            nameMatch1 = strfind(name, SUB_DATANAME1);
            if ~isempty(nameMatch1)
                dir_name = [DATAPATH, '\', SUBFOLDER1];
            end
            nameMatch2 = strfind(name, SUB_DATANAME2);      
            if ~isempty(nameMatch2)
                dir_name = [DATAPATH, '\', SUBFOLDER2];
            end
        else
            dir_name = DATAPATH;
        end
        val_date = 0;
        date_time = clock;
        picformat = '.pf';
        [text, file_path] = LMK_saveImage(dir_name, name, ...
            val_date, date_time, picformat);
   end
end

