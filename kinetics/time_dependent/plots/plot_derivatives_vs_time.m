function plot_derivatives_vs_time(figure_id, style, x_lims, time, derivative)
  create_y_log_plot(figure_id);
  plot(time * 1e9, derivative, style, 'MarkerSize', 10);
  xlabel('Time, ns');
  ylabel('d[O_3]/dt, m^{-3}/s');
  xlim(x_lims);
%   ylim([1e0, 1e15]);
end