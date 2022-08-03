function plot_concentrations_vs_time(figure_id, style, x_lims, time, concentration)
  create_y_log_plot(figure_id);
  plot(time * 1e9, concentration, style, 'MarkerSize', 10);
  xlabel('Time, ns');
  ylabel('Concentration, m^{-3}');
  xlim(x_lims);
end