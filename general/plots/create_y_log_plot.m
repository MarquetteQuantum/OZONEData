function f = create_y_log_plot(figure_id)
  if nargin < nargin(@create_y_log_plot)
    figure_id = 0;
  end
  f = create_common_plot(figure_id);
  set(gca, 'YScale', 'log');
end