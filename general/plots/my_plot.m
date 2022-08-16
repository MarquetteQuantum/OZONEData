function figure = my_plot(xs, ys, x_label, y_label, optional)
% Plots data in plots_data using several predefined options
  arguments
    xs (1, :) double
    ys (1, :) double
    x_label (1, 1) string = ""
    y_label (1, 1) string = ""
    optional.new_plot (1, 1) logical = true
    optional.color = "b"
    optional.marker (1, 1) string = "."
    optional.line_width (1, 1) double = 2
    optional.marker_size (1, 1) double = 20
    optional.xlim = "auto"
    optional.ylim = "auto"
    optional.xdir (1, 1) string = "normal"
    optional.ydir (1, 1) string = "normal"
    optional.xscale (1, 1) string = "linear"
    optional.yscale (1, 1) string = "linear"
  end

  if optional.new_plot
    create_common_plot();
  end

  figure = plot(xs, ys, 'Color', optional.color, 'Marker', optional.marker, 'LineWidth', optional.line_width, ...
    'MarkerSize', optional.marker_size);

  if x_label ~= ""
    xlabel(x_label);
  end
  if y_label ~= ""
    ylabel(y_label);
  end
  xlim(optional.xlim);
  ylim(optional.ylim);
  set(gca, "xdir", optional.xdir);
  set(gca, "ydir", optional.ydir);
  set(gca, "xscale", optional.xscale);
  set(gca, "yscale", optional.yscale);
end