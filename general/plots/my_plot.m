function figure = my_plot(xs, ys, x_label, y_label, optional)
% Plots data in plots_data using several predefined options
  arguments
    xs (1, :) double
    ys (1, :) double
    x_label (1, 1) string = ""
    y_label (1, 1) string = ""
    optional.new_plot (1, 1) logical = true
    optional.color (1, 1) string = "b"
    optional.marker (1, 1) string = "."
    optional.line_width (1, 1) double = 2
    optional.marker_size (1, 1) double = 20
    optional.xdir (1, 1) string = "normal"
    optional.yscale (1, 1) string = "linear"
  end

  if optional.new_plot
    create_common_plot();
  end

  figure = plot(xs, ys, 'Color', optional.color, 'Marker', optional.marker, 'LineWidth', optional.line_width, ...
    'MarkerSize', optional.marker_size);

  xlabel(x_label);
  ylabel(y_label);
  set(gca, "xdir", optional.xdir);
  set(gca, "yscale", optional.yscale);

%   zoom_out_x();
%   if optional.yscale == "linear"
%     zoom_out_y();
%   else
%     zoom_out_log_y();
%   end
end