function plot_bound_unbound_displacements(figure_id, style1, style2, time, bound_displacement, ...
  unbound_displacement)
  create_y_log_plot(figure_id);
  plot(time * 1e9, abs(bound_displacement), style1, 'MarkerSize', 10);
  plot(time * 1e9, abs(unbound_displacement), style2, 'MarkerSize', 10);
  xlabel('Time, ns');
  ylabel('\Delta[O_3], m^{-3}');
  xlim([0, 60]);
%   ylim([1e-8, 1e0]);
end