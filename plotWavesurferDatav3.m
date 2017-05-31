function [] = plotWavesurferDatav2()
%This function creates the list selection GUI. If the list is not the
%correct size, edit the 'position' parameter'. The value is in pixels so it
%changes depending on screen resolution.
d = dir('*.h5');
str = {d.name};
S.fh = figure('units','pixels',...
              'position',[100 100 300 800],...
              'menubar','none',...
              'name','Wavesurfer Plot Tool',...
              'numbertitle','off',...
              'resize','off');

S.ls = uicontrol('style','list',...
                 'unit','pix',...
                 'position',[10 60 275 720],...
                 'min',0,'max',1,...
                 'fontsize',8,...
                 'string',str);   
             
S.pb = uicontrol('style','push',...
                 'units','pix',...
                 'position',[10 10 180 40],...
                 'fontsize',10,...
                 'string','Graph Data');
             
set(S.pb, 'callback', {@pb_call, S});
end
            
function [] = pb_call(varargin)

S = varargin{3};  % Get the structure.

%This adds a "running" button while the graph calculates, useful for
%knowing when long plots are still processing
col = get(S.pb,'backg');  % Get the background color of the figure.
set(S.pb,'str','RUNNING...','backg',[1 .6 .6]) % Change color of button. 
pause(.01)  % FLUSH the event queue, drawnow would work too.


%This gets the selection from the list (the filename) and loads the data into a
%struct
L = get(S.ls,{'string','value'});  
if isempty(L{1})
    display('No files found')
else
    filename = L{1}{L{2}};
    ws_data_struct = ws.loadDataFile(filename);
    
%Determines if recording is continuous or sweep based and calls requisite
%functions for plotting

    if ws_data_struct.header.AreSweepsContinuous == 1
        display 'This is a continuous recording'
        figure
        plot_continuous_recording(ws_data_struct)
    else
        display 'This is a sweep based recording'   
        plot_sweep_recording_brush_prototype(ws_data_struct)
    end
end

set(S.pb,'str','Graph Data','backg',col)
clear
end