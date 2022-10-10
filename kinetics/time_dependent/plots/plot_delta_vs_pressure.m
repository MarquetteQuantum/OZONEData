function plot_delta_vs_pressure()
% Plots delta vs pressure
  load("C:\Users\3830gaydayi\Desktop\buf\krecs_all.mat");
  Ks = 0:20;
  Js = [0:32, 36:40];
  vib_syms_well = 0:1;
  M_concs_per_m3 = 6.44 * logspace(23, 28, 6);
  deltas = zeros(size(krecs_m6_per_s, 1), 1);
  for pressure_ind = 1:size(krecs_m6_per_s, 1)
    krec_666 = sum_krec_dtau(squeeze(krecs_m6_per_s(pressure_ind, 1, :, :, :)), Ks, Js, vib_syms_well);
    krec_686 = sum_krec_dtau(squeeze(krecs_m6_per_s(pressure_ind, 2, :, :, :)), Ks, Js, vib_syms_well);
    deltas(pressure_ind) = 2/3 * krec_686/krec_666;
  end
  my_plot(M_concs_per_m3, deltas, "[M], m^{-3}", "\delta", xscale="log");
end