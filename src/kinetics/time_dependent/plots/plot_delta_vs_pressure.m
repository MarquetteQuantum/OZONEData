function plot_delta_vs_pressure()
% Plots delta vs pressure
  data_path_666 = "C:\Users\3830gaydayi\Desktop\buf\krecs\666\total\no_vdw\gamma_min_1\gamma_max_15\sigma_3200\vdw_min_0.3\pressure";
  data_path_686 = "C:\Users\3830gaydayi\Desktop\buf\krecs\676\total\no_vdw\gamma_min_1\gamma_max_15\sigma_3200\vdw_min_0.3\pressure";
  color_ind = 2;
  sym_ind = 1;
  asym_ind = 2;
  figure_ids = 0 + (1:3);
  dtau_func = @get_dtau_3;

  load(fullfile(data_path_666, "env.mat"));
  load(fullfile(data_path_666, "krecs.mat"));
  krecs{1} = squeeze(krecs_m6_per_s(:, 1, :, :, :, :));
  
  load(fullfile(data_path_686, "krecs.mat"));
  krecs{2} = squeeze(krecs_m6_per_s(:, 1, :, :, :, :));

%   temps_k = temp_k;

  % uncomment if sym and asym are computed separately
%   data_path_686_asym = "C:\Users\3830gaydayi\Desktop\buf\krecs\686\separate\pend\vdw\asym\split\";
%   load(fullfile(data_path_686_asym, "krecs.mat"));
%   krecs{2}(:, :, :, :, 2) = squeeze(krecs_m6_per_s(:, end, :, :, :, 1));
  
  krecs_dtau = cell(size(krecs));
  for mol_ind = 1:length(krecs)
    for pressure_ind = 1:size(krecs{mol_ind}, 1)
      for region_ind = 1:size(krecs{mol_ind}, 5)
        krecs_slice = squeeze(krecs{mol_ind}(pressure_ind, :, :, :, region_ind));
        krecs_dtau{mol_ind}(pressure_ind, region_ind) = sum_krec_dtau(krecs_slice, Ks, Js, vib_syms_well, dtau_func);
      end
    end
  end
  etas = krecs_dtau{2}(:, asym_ind) ./ krecs_dtau{2}(:, sym_ind) / 2;
  total_686 = krecs_dtau{2}(:, sym_ind) + krecs_dtau{2}(:, asym_ind);
  deltas = (2/3 * total_686 ./ krecs_dtau{1}(:, 1) - 1) * 100;

  pressure_bar = m_conc_to_bar(M_concs_per_m3, temps_k);
  my_plot(pressure_bar, krecs_dtau{1}(:, 1), "Pressure, bar", "k_{rec}, m^6/s", figure_id=figure_ids(1), xscale="log", xlim=[5e-3, 2e3], ylim=[0, 7e-46], ...
    color=3);
  my_plot(pressure_bar, 2/3*total_686, figure_id=figure_ids(1), color=color_ind, line_style="-");
%   my_plot(pressure_bar, 2*krecs_dtau{2}(:, sym_ind), figure_id=1, color=1, line_style="-");
%   my_plot(pressure_bar, krecs_dtau{2}(:, asym_ind), figure_id=1, color=2, line_style="-");
  plot_krec_vs_pressure_experimental_666();
  xticklabels_every_order(1);

  my_plot(pressure_bar, deltas, "Pressure, bar", "\delta, %", figure_id=figure_ids(2), color=color_ind, xscale="log", xlim=[5e-3, 2e3], ylim=[-1, 16]);
  plot_delta_686_vs_pressure_experimental_2();
  plot_delta_676_vs_pressure_experimental_2();
  xticklabels_every_order(1);

  my_plot(pressure_bar, etas, "Pressure, bar", "\eta", figure_id=figure_ids(3), color=color_ind, xscale="log", xlim=[5e-3, 2e3], ylim=[1, inf]);
  xticklabels_every_order(1);
end