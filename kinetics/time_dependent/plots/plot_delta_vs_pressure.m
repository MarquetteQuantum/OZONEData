function plot_delta_vs_pressure()
% Plots delta vs pressure
  data_path = "C:\Users\3830gaydayi\Desktop\buf\krecs\all\no_vdw\gamma_min_1e-6\";
  load(fullfile(data_path, "env.mat"));
  load(fullfile(data_path, "krecs.mat"));
  
  krecs_dtau = zeros(size(krecs_m6_per_s, 1), size(krecs_m6_per_s, 2));
  for pressure_ind = 1:size(krecs_dtau, 1)
    for mol_ind = 1:size(krecs_dtau, 2)
      krecs_slice = squeeze(krecs_m6_per_s(pressure_ind, mol_ind, :, :, :));
      krecs_dtau(pressure_ind, mol_ind) = sum_krec_dtau(krecs_slice, Ks, Js, vib_syms_well);
    end
  end
  deltas = (2/3 * krecs_dtau(:, 2) ./ krecs_dtau(:, 1) - 1) * 100;

  pressure_bar = m_conc_to_bar(M_concs_per_m3, temp_k);
  my_plot(pressure_bar, krecs_dtau(:, 1), "Pressure, bar", "k_{rec}, m^6/s", xscale="log", yscale="log", color="b");
  my_plot(pressure_bar, 2/3*krecs_dtau(:, 2), new_plot=false, color="r");
  plot_krec_vs_pressure_experimental_666();
  my_plot(pressure_bar, deltas, "Pressure, bar", "\delta, %", xscale="log", ylim=[0, inf]);
  plot_delta_vs_pressure_experimental();
end