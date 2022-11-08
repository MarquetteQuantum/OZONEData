function plot_flux_vs_time(figure_id, style, time_s, flux)
  create_common_plot(figure_id);
  plot(time_s * 1e9, flux, style, 'MarkerSize', 10);
  xlabel('Time, ns');
  ylabel('Flux, m^{-3}/s');
  xlim([0, 50]);
end