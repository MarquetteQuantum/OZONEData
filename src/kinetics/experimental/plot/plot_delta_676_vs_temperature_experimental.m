function plot_delta_676_vs_temperature_experimental()
% Plots experimental data of delta (in %) dependency on temperature (in K) for 676/666
% Does not create new plot
  data = get_delta_676_vs_temperature();
  plot(data(:, 1), data(:, 2), 'ko', 'MarkerSize', 10);
end