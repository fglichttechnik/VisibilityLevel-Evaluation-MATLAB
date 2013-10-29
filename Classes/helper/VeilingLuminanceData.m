%author Robert Franke TU Berlin
%email j.winter@tu-berlin.de

%class to define veiling luminance object

classdef VeilingLuminanceData < handle
    
    properties
        veilingLuminance
        type
        position 
    end
      
    methods
        %% constructor
        function obj = VeilingLuminanceData( veilingLuminance, type, position )
            
            if nargin < 3 % Support calling with 0 arguments
                obj.veilingLuminance = str2double( veilingLuminance );
                obj.type = type;
            else
                obj.veilingLuminance = str2double( veilingLuminance );
                obj.type = type;
                obj.position = str2double( position );
            end
        end
        
    end
end