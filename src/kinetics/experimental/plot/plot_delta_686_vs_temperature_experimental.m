function plot_delta_686_vs_temperature_experimental()
% Plots experimental data of delta (in %) dependency on temperature (in K) for 686/666
% Does not create new plot
  data = get_delta_686_vs_temperature();
  plot(data(:, 1), data(:, 2), 'k.', 'MarkerSize', 20);
end