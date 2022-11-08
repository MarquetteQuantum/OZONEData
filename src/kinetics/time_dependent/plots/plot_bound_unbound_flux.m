function plot_bound_unbound_flux(figure_id, style1, style2, time, flux_unbound_bound, flux_bound_unbound)
  create_common_plot(figure_id);
  plot(time * 1e9, flux_unbound_bound * 1e-9, style1, 'MarkerSize', 10);
  plot(time * 1e9, flux_bound_unbound * 1e-9, style2, 'MarkerSize', 10);
  xlabel('Time, ns');
  ylabel('Flux, m^{-3}/ns');
  xlim([0, 50]);
end