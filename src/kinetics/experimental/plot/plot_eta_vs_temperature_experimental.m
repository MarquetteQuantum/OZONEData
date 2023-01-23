function plot_eta_vs_temperature_experimental()
% Plots experimental data of eta (wrt 1) dependency on temperature (in K)
% Does not create new plot
  data = get_eta_vs_temperature();
  plot(data(:, 1), data(:, 2), 'k.', 'MarkerSize', 20);
end