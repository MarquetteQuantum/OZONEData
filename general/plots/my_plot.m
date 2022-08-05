function figure = my_plot(xs, ys, optional)
% Plots data in plots_data using several predefined options
  arguments
    xs (1, :) double
    ys (1, :) double
    optional.new_plot (1, 1) logical = true
    optional.color (1, 1) string = "b"
    optional.marker (1, 1) string = "."
    optional.line_width (1, 1) double = 2
    optional.marker_size (1, 1) double = 20
    optional.xlabel (1, 1) string = ""
    optional.ylabel (1, 1) string = ""
  end

  if optional.new_plot
    create_common_plot();
  end

  figure = plot(xs, ys, 'Color', optional.color, 'Marker', optional.marker, 'LineWidth', optional.line_width, ...
    'MarkerSize', optional.marker_size);

  xlabel(optional.xlabel);
  ylabel(optional.ylabel);
end