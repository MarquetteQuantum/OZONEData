function plot_displacements_vs_time(figure_id, style, x_lims, time, displacement)
  create_y_log_plot(figure_id);
  plot(time * 1e9, abs(displacement), style, 'MarkerSize', 10);
  xlabel('Time, ns');
  ylabel('Displacement, m^{-3}');
  xlim(x_lims);
end