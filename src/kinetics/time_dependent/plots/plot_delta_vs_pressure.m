function plot_delta_vs_pressure()
% Plots delta vs pressure
  data_path_666 = "C:\Users\3830gaydayi\Desktop\buf\krecs\666\separate_concentrations\factor_1\";
  data_path_686 = "C:\Users\3830gaydayi\Desktop\buf\krecs\686\separate_concentrations\alpha_1\conv_high\";
%   data_path_666 = "C:\Users\3830gaydayi\Desktop\buf\krecs\all\no_vdw\gamma_min_1\gamma_max_inf\";
  color_ind = 1;

  load(fullfile(data_path_666, "env.mat"));
  load(fullfile(data_path_666, "krecs.mat"));
  krecs{1} = squeeze(krecs_m6_per_s(:, 1, :, :, :, :));
  
  load(fullfile(data_path_686, "krecs.mat"));
  krecs{2} = squeeze(krecs_m6_per_s(:, end, :, :, :, :));
  
  krecs_dtau = cell(size(krecs));
  for mol_ind = 1:length(krecs)
    for pressure_ind = 1:size(krecs{mol_ind}, 1)
      for region_ind = 1:size(krecs{mol_ind}, 5)
        krecs_slice = squeeze(krecs{mol_ind}(pressure_ind, :, :, :, region_ind));
        krecs_dtau{mol_ind}(pressure_ind, region_ind) = sum_krec_dtau(krecs_slice, Ks, Js, vib_syms_well);
      end
    end
  end
  etas = krecs_dtau{2}(:, 2) ./ krecs_dtau{2}(:, 1) / 2;
  deltas = (2/3 * sum(krecs_dtau{2}, 2) ./ krecs_dtau{1}(:, 1) - 1) * 100;

  pressure_bar = m_conc_to_bar(M_concs_per_m3, temp_k);
  my_plot(pressure_bar, krecs_dtau{1}(:, 1), "Pressure, bar", "k_{rec}, m^6/s", figure_id=1, xscale="log", ...
    yscale="log", color=color_ind);
  my_plot(pressure_bar, 2/3*sum(krecs_dtau{2}, 2), figure_id=1, color=color_ind, line_style="--");
  plot_krec_vs_pressure_experimental_666();
  my_plot(pressure_bar, deltas, "Pressure, bar", "\delta, %", figure_id=2, color=color_ind, xscale="log", ...
    ylim=[-inf, inf]);
  plot_delta_vs_pressure_experimental();
  my_plot(pressure_bar, etas, "Pressure, bar", "\eta", figure_id=3, color=color_ind, xscale="log", ylim=[-inf, inf]);
end