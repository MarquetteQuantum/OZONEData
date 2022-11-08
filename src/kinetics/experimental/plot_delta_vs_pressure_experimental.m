function plot_delta_vs_pressure_experimental()
% Plots experimental data of delta (in %) dependency on pressure (in bar) for 686/666
% Does not create new plot
  data = get_delta_vs_pressure_all();
  plot(data(:, 1), data(:, 2), 'k.', 'MarkerSize', 20);
end