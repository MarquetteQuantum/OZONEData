function plot_delta_686_vs_pressure_experimental_2()
% Plots experimental data of delta (in %) dependency on pressure (in bar) for 686/666
% Uses different markers for different experimental groups
% Does not create new plot
  data_morton = get_delta_686_vs_pressure_morton();
  data_thiemens_1988 = get_delta_686_vs_pressure_thiemens_1988();
  data_thiemens_1990 = get_delta_686_vs_pressure_thiemens_1990();
  plot(data_morton(:, 1), data_morton(:, 2), 'bo', MarkerSize=10);
  plot(data_thiemens_1988(:, 1), data_thiemens_1988(:, 2), 'bsquare', MarkerSize=10);
  plot(data_thiemens_1990(:, 1), data_thiemens_1990(:, 2), 'bdiamond', MarkerSize=10);
end