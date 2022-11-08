function plot_krec_vs_time(figure_id, style, x_lims, time_s, krec_m6_per_s)
% Plots definition 1 of krec vs time
  create_common_plot(figure_id);
  plot(time_s * 1e9, krec_m6_per_s, style, 'MarkerSize', 10);
  xlabel('Time, ns');
  ylabel('krec, m^6/s');
  xlim(x_lims);
%   ylim([0, 1]);
end