function plot_total_conservation(time, concentrations)
  create_y_log_plot();
  initial_concentration = sum(concentrations(1, :));
  conservation_error = (sum(concentrations, 2) - initial_concentration) * 100;
  plot(time * 1e9, conservation_error, 'b.-', 'MarkerSize', 10);
  xlabel('Time, ns');
  ylabel('Conservation error, %');
end