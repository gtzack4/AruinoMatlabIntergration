classdef ArduinoComClass < handle
    %ArduinoComClass This class will call functions functions from anrduino
    %   first upload the MatlabInterface sketch to the arduino. Make sure
    %   you close out the seiral monitor on arduino. Make sure you set the
    %   corect comport for you arduino in the matlab class then try the
    %   flowing. 
    %   Example:
    %   A = ArduinoComClass;
    %   out = A.sendData('handShake');
    %   disp(out)
    %   
    %   Detailed explanation goes here
    
    properties
        comPort = 5;            % change comport to your 
        baudRate = 2000000;     % set your boudrate
        board                   % serial obj for comunication 
        timeOut = .05;          % time in sec time out 
        
    end
    
    methods
        %% constructor
        function obj = ArduinoComClass
            %constructor
            %   close all open ports
            %   open seiral port and set baudrate
            x = instrfindall;
            for idx = 1:length(x)
                if strcmp(x(idx).Status,'open')
                    fclose(x(idx));
                end
            end
            % open seiral port and set baudrate
            obj.board = serial(['COM' num2str(obj.comPort)],'BaudRate',obj.baudRate);
            
            fopen(obj.board);
        end
        %% decon 
        function delete(obj)
            % clean up when done
            fclose(obj.board);
            delete(obj.board);
            delete(obj);
        end
        %% send data
        function out = sendData(obj,functionName,isResp,Data1,Data2,Data3,Data4)
            %sendData This method writes to the seiral bus.
            %   The functionName will be written on the serial bus. The 
            %   arduino will read in the functionName and all of the data.
            %   The arduino will parse out the FunctionName. The arduino 
            %   will then  call the function with that name. This function
            %   expects a responce from the arduino and will wait till it
            %   recives it or the time out happens. 
            if nargin == 3
                fwrite(obj.board,functionName);
            elseif nargin == 4
                fwrite(obj.board,[functionName ':' num2str(Data1)]);
            elseif nargin == 5
                fwrite(obj.board,[functionName ':' num2str(Data1) ':' ...
                    num2str(Data2)]);
            elseif nargin == 6
                fwrite(obj.board,[functionName ':' num2str(Data1) ':' ...
                    num2str(Data2) ':' num2str(Data3) ]);
            elseif nargin == 7
                fwrite(obj.board,[functionName ':' num2str(Data1) ':' ...
                    num2str(Data2) ':' num2str(Data3) ':' num2str(Data4) ':']);
            else
                
            end
            if isResp
                tic
                while (~obj.board.BytesAvailable && toc > obj.timeOut)% wait for mesage
                    pause(.001)
                end
                if toc < obj.timeOut
                    out = fgetl(obj.board);
                else
                    out = -1;
                end
            else
                out = -1;
            end
        end
        %% get data from serial
        function data = getData(obj)
            if obj.board.BytesAvailable
                data = fgetl(obj.board);
            else
                data = -1;
            end
        end
        %% flush serial
        function flushInput(obj)
            while (obj.board.BytesAvailable)
                fgetl(obj.board);
            end
            
        end
    end
end

