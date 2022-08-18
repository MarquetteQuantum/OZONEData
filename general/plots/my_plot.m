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
    optional.line_style (1, 1) string = "-"
    optional.marker_size (1, 1) double = 20
    optional.xlim = nan
    optional.ylim = nan
    optional.xdir = nan
    optional.ydir = nan
    optional.xscale = nan
    optional.yscale = nan
  end

  if optional.new_plot
    create_common_plot();
  end

  figure = plot(xs, ys, 'Color', optional.color, 'Marker', optional.marker, 'LineWidth', optional.line_width, ...
    'LineStyle', optional.line_style, 'MarkerSize', optional.marker_size);

  if x_label ~= ""
    xlabel(x_label);
  end
  if y_label ~= ""
    ylabel(y_label);
  end
  if ~all(isnan(optional.xlim))
    xlim(optional.xlim);
  end
  if ~all(isnan(optional.ylim))
    ylim(optional.ylim);
  end
  if ~isnan(optional.xdir)
    set(gca, "xdir", optional.xdir);
  end
  if ~isnan(optional.ydir)
    set(gca, "ydir", optional.ydir);
  end
  if ~isnan(optional.xscale)
    set(gca, "xscale", optional.xscale);
  end
  if ~isnan(optional.yscale)
    set(gca, "yscale", optional.yscale);
  end
end