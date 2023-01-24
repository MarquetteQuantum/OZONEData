function plot_krec_vs_pressure_experimental_666_2()
% Plots experimental data of krec (in m6/s) dependency on pressure (in bar) for 666
% Uses different markers for different experimental groups
% Does not create new plot
  data_cobos = get_krec_vs_pressure_666_cobos();
  data_hippler = get_krec_vs_pressure_666_hippler();
  data_hippler_cobos = get_krec_vs_pressure_666_hippler_cobos();
  data_janssen = get_krec_vs_pressure_666_janssen();
  data_lin = get_krec_vs_pressure_666_lin();
  plot(data_cobos(:, 1), data_cobos(:, 2), 'k.', MarkerSize=20);
  plot(data_hippler(:, 1), data_hippler(:, 2), 'ko', MarkerSize=10);
  plot(data_hippler_cobos(:, 1), data_hippler_cobos(:, 2), 'ksquare', MarkerSize=10);
  plot(data_janssen(:, 1), data_janssen(:, 2), 'kdiamond', MarkerSize=10);
  plot(data_lin(:, 1), data_lin(:, 2), 'k^', MarkerSize=10);
end