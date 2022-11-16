function handle = my_plot(xs, ys, x_label, y_label, optional)
% Plots data in plots_data using several predefined options
  arguments
    xs (1, :) double
    ys (1, :) double
    x_label (1, 1) string = ""
    y_label (1, 1) string = ""
    optional.figure_id = 0
    optional.color = "b"
    optional.marker (1, 1) string = "."
    optional.line_width (1, 1) double = 2
    optional.line_style (1, 1) string = "-"
    optional.marker_size (1, 1) double = 20
    optional.xlim = []
    optional.ylim = []
    optional.xdir = []
    optional.ydir = []
    optional.xscale = []
    optional.yscale = []
  end

  create_common_plot(optional.figure_id);
  if isnumeric(optional.color) && length(optional.color) == 1
    colors = distinguishable_colors(optional.color);
    optional.color = colors(end, :);
  end

  handle = plot(xs, ys, 'Color', optional.color, 'Marker', optional.marker, 'LineWidth', optional.line_width, ...
    'LineStyle', optional.line_style, 'MarkerSize', optional.marker_size);

  if x_label ~= ""
    xlabel(x_label);
  end
  if y_label ~= ""
    ylabel(y_label);
  end
  if ~isempty(optional.xlim)
    xlim(optional.xlim);
  end
  if ~isempty(optional.ylim)
%     set_y_limits(optional.ylim);
    ylim(optional.ylim);
  end
  if ~isempty(optional.xdir)
    set(gca, "xdir", optional.xdir);
  end
  if ~isempty(optional.ydir)
    set(gca, "ydir", optional.ydir);
  end
  if ~isempty(optional.xscale)
    set(gca, "xscale", optional.xscale);
  end
  if ~isempty(optional.yscale)
    set(gca, "yscale", optional.yscale);
  end
end