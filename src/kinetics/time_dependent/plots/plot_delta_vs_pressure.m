function plot_delta_vs_pressure()
% Plots delta vs pressure
  data_path = "C:\Users\3830gaydayi\Desktop\buf\krecs\686\separate_concentrations\old\";
  color_ind = 1;
  load(fullfile(data_path, "env.mat"));
  load(fullfile(data_path, "krecs.mat"));
  
  krecs_dtau = zeros(size(krecs_m6_per_s, 1), size(krecs_m6_per_s, 2), size(krecs_m6_per_s, 6));
  for pressure_ind = 1:size(krecs_dtau, 1)
    for mol_ind = 1:size(krecs_dtau, 2)
      for region_ind = 1:size(krecs_dtau, 3)
        krecs_slice = squeeze(krecs_m6_per_s(pressure_ind, mol_ind, :, :, :, region_ind));
        krecs_dtau(pressure_ind, mol_ind, region_ind) = sum_krec_dtau(krecs_slice, Ks, Js, vib_syms_well);
      end
    end
  end
  deltas = (2/3 * krecs_dtau(:, 2, 1) ./ krecs_dtau(:, 1, 1) - 1) * 100;

  pressure_bar = m_conc_to_bar(M_concs_per_m3, temp_k);
  colors = distinguishable_colors(10);
  my_plot(pressure_bar, krecs_dtau(:, 1), "Pressure, bar", "k_{rec}, m^6/s", figure_id=1, ...
    xscale="log", yscale="log", color=colors(color_ind, :));
  my_plot(pressure_bar, 2/3*krecs_dtau(:, 2), figure_id=1, color=colors(color_ind, :), line_style="--");
  plot_krec_vs_pressure_experimental_666();
  my_plot(pressure_bar, deltas, "Pressure, bar", "\delta, %", figure_id=2, color=colors(color_ind, :), xscale="log", ...
    ylim=[-inf, inf]);
  plot_delta_vs_pressure_experimental();
end