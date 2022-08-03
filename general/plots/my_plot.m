function figures = my_plot(plots_data, x_label, y_labels, optional)
% Plots data in plots_data using several predefined options
  if nargin < nargin(@my_plot)
    optional = nan;
  end
  new_plots = get_or_default(optional, 'new_plots', 1);
  x_limits = get_or_default(optional, 'x_limits', nan);
  y_limits = get_or_default(optional, 'y_limits', nan);
  x_logs = get_or_default(optional, 'x_log', 0);
  y_logs = get_or_default(optional, 'y_log', 0);
  x_ticks = get_or_default(optional, 'x_ticks', nan);
  y_ticks = get_or_default(optional, 'y_ticks', nan);
  legends = get_or_default(optional, 'legends', nan);
  square = get_or_default(optional, 'square', 0);
  marker = get_or_default(optional, 'marker', '.');
  line_width = get_or_default(optional, 'line_width', 2);
  marker_size = get_or_default(optional, 'marker_size', 30);

  figures = zeros(size(plots_data, 1));
  colors = distinguishable_colors(size(plots_data, 2));
  lines = cellfun(@(line) [marker, line], {'-', '--', ''}, 'UniformOutput', false);
  for plot_ind = 1:size(plots_data, 1)
    if new_plots == 1
    	figures(plot_ind) = create_common_plot();
    else
      figure(plot_ind);
    end
    
    for color_ind = 1:size(plots_data, 2)
      for line_ind = 1:size(plots_data, 3)
        plot_data = plots_data{plot_ind, color_ind, line_ind};
        if isempty(plot_data)
          continue
        end
        
        plot(plot_data(1, :), plot_data(2, :), lines{line_ind}, ...
          'Color', colors(color_ind, :), 'LineWidth', line_width, 'MarkerSize', marker_size);
      end
    end
    
    if new_plots == 1
      xlabel(x_label);
      if iscell(y_labels)
        ylabel(y_labels{min(plot_ind, length(y_labels))});
      else
        ylabel(y_labels);
      end
      
      if iscell(x_limits)
        if length(x_limits) == 1
          set_x_limits(x_limits{1});
        else
          set_x_limits(x_limits{plot_ind});
        end
      elseif ismatrix(x_limits)
        set_x_limits(x_limits);
      end
      
      if iscell(y_limits)
        if length(y_limits) == 1
          set_y_limits(y_limits{1});
        else
          set_y_limits(y_limits{plot_ind});
        end
      elseif ismatrix(y_limits)
        set_y_limits(y_limits);
      end
      
      if length(x_logs) == 1
        x_log = x_logs;
      else
        x_log = x_logs(plot_ind);
      end
      if length(y_logs) == 1
        y_log = y_logs;
      else
        y_log = y_logs(plot_ind);
      end
      
      if x_log == 1
        set(gca, 'XScale', 'log');
        xticks(logspace(-10, 10, 21));
        zoom_out_log_x();
      else
        zoom_out_x();
      end
      if y_log == 1
        set(gca, 'YScale', 'log');
        yticks(logspace(-10, 10, 21));
        zoom_out_log_y();
        rarefy_y_ticks();
      else
        zoom_out_y();
      end
      
      if iscell(x_ticks)
        xticks(x_ticks{plot_ind});
      end
      if ~isnan(y_ticks)
        yticks(y_ticks);
      end
      
      if iscell(legends)
        if ~isempty(legends{plot_ind})
          legend(legends{plot_ind});
        end
      end
      
      if square == 1
        pbaspect([1, 1, 1]);
      end
    end
  end
end