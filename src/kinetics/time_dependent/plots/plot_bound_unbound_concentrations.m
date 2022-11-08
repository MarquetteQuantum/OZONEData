function plot_bound_unbound_concentrations(figure_id, style1, style2, time, ...
  bound_concentration, unbound_concentration)
  create_common_plot(figure_id);
  plot(time * 1e9, bound_concentration, style1, 'MarkerSize', 10);
  plot(time * 1e9, unbound_concentration, style2, 'MarkerSize', 10);
  xlabel('Time, ns');
  ylabel('[O_3], m^{-3}');
  xlim([0, 100]);
end