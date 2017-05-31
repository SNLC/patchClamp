%Loads the structure of the h5 file and uses it to figure out
%how many sweeps were recorded
names_in_struct = fieldnames(data);
sweep_names = names_in_struct(2:end,:);

%Queries the h5 file for the sample rate, scales, units, and channel names 
%for data collation
sample_rate = data.header.Acquisition.SampleRate;
analog_channel_units = data.header.Acquisition.AnalogChannelUnits;
analog_channel_names = data.header.Acquisition.ChannelNames;

%Calculate resting membrane potential
time_window_prior_to_stimuli = 200;
end_window_prior_to_stimuli = time_window_prior_to_stimuli/1000*sample_rate;
ch1_prestimuli_rmp = mean(data.(sweep_names{1}).analogScans(1:end_window_prior_to_stimuli,1));
ch2_prestimuli_rmp = mean(data.(sweep_names{1}).analogScans(1:end_window_prior_to_stimuli,2));
ch1_units = data.header.Ephys.ElectrodeManager.Electrodes.element1.MonitorUnits;
ch2_units = data.header.Ephys.ElectrodeManager.Electrodes.element2.MonitorUnits;

%Graphs the axes on which to plot the data and adds the hold command so
%that the data is not overwritten for each sweep
ax1 = axes();
ax2 = axes();
ax3 = axes();
ax4 = axes();
hold (ax1, 'on')
hold (ax2, 'on')
hold (ax3, 'on')
hold (ax4, 'on')

for i = sweep_names'
    %analog_data contains channel 1 input, channel 2 input, channel 1
    %command, channel 2 command, and temperature data (in that order)
    analog_data = data.(char(i)).analogScans;
    number_of_samples = size(analog_data, 1);
    time = (1:number_of_samples)/sample_rate;
    
    %This plots channel 1 output
    plot(ax1, time, analog_data(:,1));
    
    %This plots channel 2 output
    plot(ax2, time, analog_data(:,2));
    
    %This plots channel 1 command
    plot(ax3, time, analog_data(:,3)*data.header.Ephys.ElectrodeManager.Electrodes.element1.CommandScaling)
    
    %This plots channel 2 command
    plot(ax4, time, analog_data(:,4)*data.header.Ephys.ElectrodeManager.Electrodes.element1.CommandScaling)
       
end

%add the axes to subplot
subplot(2,2,1,ax1);
    time_length_scalebar = 200;
    if strcmp(ch1_units, 'mV')
        title('Intracellular Potential')
    else 
        title('Intracellular Current')
    end
    x_limits_ax1 = xlim(ax1);

    x_pos_vertical_scalebar = [x_limits_ax1(1)+0.01; x_limits_ax1(1)+0.01];
    y_pos_vertical_scalebar = [ch1_prestimuli_rmp-15; ch1_prestimuli_rmp-5];
    x_pos_time_scalebar = [x_limits_ax1(1)+0.01; x_limits_ax1(1)+time_length_scalebar/1000 + 0.01];
    y_pos_time_scalebar = [ch1_prestimuli_rmp-15; ch1_prestimuli_rmp-15];
    
    plot(x_pos_vertical_scalebar, y_pos_vertical_scalebar, '-k', x_pos_time_scalebar , y_pos_time_scalebar , '-k', 'LineWidth', 2)
    
    text(x_limits_ax1(1), mean(y_pos_vertical_scalebar), ['10 ', ch1_units], 'HorizontalAlignment','right')
    text(x_limits_ax1(1)+ time_length_scalebar/2000, mean(y_pos_time_scalebar)-5, '200 ms', 'HorizontalAlignment','center')
    text(x_limits_ax1(2), ch1_prestimuli_rmp-20, ['RMP: ', num2str(ch1_prestimuli_rmp, '%.3f'), ' mV'], 'HorizontalAlignment','right')
    
subplot(2,2,2,ax2);
    time_length_scalebar = 200;
    if strcmp(ch2_units, 'mV')
        title('Intracellular Potential')
    else 
        title('Intracellular Current')
    end
    x_limits_ax2 = xlim(ax2);

    x_pos_vertical_scalebar = [x_limits_ax2(1)+0.01; x_limits_ax2(1)+0.01];
    y_pos_vertical_scalebar = [ch2_prestimuli_rmp-15; ch2_prestimuli_rmp-5];
    x_pos_time_scalebar = [x_limits_ax2(1)+0.01; x_limits_ax2(1)+time_length_scalebar/1000 + 0.01];
    y_pos_time_scalebar = [ch2_prestimuli_rmp-15; ch2_prestimuli_rmp-15];
    
    plot(x_pos_vertical_scalebar, y_pos_vertical_scalebar, '-k', x_pos_time_scalebar , y_pos_time_scalebar , '-k', 'LineWidth', 2)
    
    text(x_limits_ax2(1), mean(y_pos_vertical_scalebar), ['10 ', ch2_units], 'HorizontalAlignment','right')
    text(x_limits_ax2(1)+ time_length_scalebar/2000, mean(y_pos_time_scalebar)-5, '200 ms', 'HorizontalAlignment','center')
    text(x_limits_ax2(2), ch2_prestimuli_rmp-20, ['RMP: ', num2str(ch2_prestimuli_rmp, '%.3f'), ' mV'], 'HorizontalAlignment','right')

subplot(2,2,3,ax3);

subplot(2,2,4,ax4);

%This polishes subplot 1 and adds a scalebar
    set(ax1, 'Visible', 'off')
    set(get(ax1,'Title'),'Visible','on')
    brush on

%This polishes subplot 2 and adds a scalebar
    set(ax2, 'Visible', 'off')
    set(get(ax2,'Title'),'Visible','on')
    
%This polishes subplot 3 and adds a scalebar
    set(ax3, 'Visible', 'off')
    set(get(ax3,'Title'),'Visible','on')

%This polishes subplot 4 and adds a scalebar
    set(ax4, 'Visible', 'off')
    set(get(ax4,'Title'),'Visible','on')

suptitle(data.header.Logging.FileBaseName)