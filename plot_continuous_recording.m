%Loads the structure of the h5 file and uses it to figure out
%how many sweeps were recorded
names_in_struct = fieldnames(data);
sweep_names = names_in_struct(2:end,:);

%Queries the h5 file for the sample rate, scales, units, and channel names 
%for data collation
sample_rate = data.header.Acquisition.SampleRate;
analog_channel_units = data.header.Acquisition.AnalogChannelUnits;
analog_channel_names = data.header.Acquisition.ChannelNames;

%Graphs the data and creates a matrix of peaks
ax1 = subplot (2,1,1);
ax2 = subplot(2,1,2);
for i = sweep_names'
    sweep_output_all_channels = data.(char(i)).analogScans;
    number_of_samples = size(sweep_output_all_channels, 1);
    time = (1:number_of_samples)/sample_rate;
    %This plots channel 1
    plot(ax1, time, sweep_output_all_channels(:,1))
    plot(ax2, time, sweep_output_all_channels(:,2))
    
end

%Removes the axes and replaces it with small scale bar roughly scaled to
%bottom left corner  
   set(ax1, 'Visible', 'off')
   set(get(ax1,'Title'),'Visible','on')
   set(ax2, 'Visible', 'off')
   set(get(ax2,'Title'),'Visible','on')
   suptitle(data.header.Logging.FileBaseName)
   
    hB = findobj(gcf,'-property','BrushData');
    data = get(hB,'BrushData');
    brushObj = hB(find(cellfun(@(x) sum(x),data)));
