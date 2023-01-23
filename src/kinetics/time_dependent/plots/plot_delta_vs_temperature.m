function plot_delta_vs_temperature()
% Plots delta vs temperature
  data_path_666 = "C:\Users\3830gaydayi\Desktop\buf\krecs\666\total\no_vdw\gamma_min_1\gamma_max_15\sigma_3200\vdw_min_0.3\temperature";
  data_path_686 = "C:\Users\3830gaydayi\Desktop\buf\krecs\676\total\no_vdw\gamma_min_1\gamma_max_15\sigma_3200\vdw_min_0.3\temperature";
  color_ind = 2;
  sym_ind = 1;
  asym_ind = 2;
  figure_ids = 0 + (1:3);
  dtau_func = @get_dtau_3;

  load(fullfile(data_path_666, "env.mat"));
  load(fullfile(data_path_666, "krecs.mat"));
  krecs{1} = squeeze(krecs_m6_per_s(1, :, :, :, :, :));
  
  load(fullfile(data_path_686, "krecs.mat"));
  krecs{2} = squeeze(krecs_m6_per_s(1, :, :, :, :, :));

  % uncomment if sym and asym are computed separately
%   data_path_686_asym = "C:\Users\3830gaydayi\Desktop\buf\krecs\686\separate\pend\vdw\asym\split\";
%   load(fullfile(data_path_686_asym, "krecs.mat"));
%   krecs{2}(:, :, :, :, 2) = squeeze(krecs_m6_per_s(:, end, :, :, :, 1));
  
  krecs_dtau = cell(size(krecs));
  for mol_ind = 1:length(krecs)
    for temp_ind = 1:size(krecs{mol_ind}, 1)
      for region_ind = 1:size(krecs{mol_ind}, 5)
        krecs_slice = squeeze(krecs{mol_ind}(temp_ind, :, :, :, region_ind));
        krecs_dtau{mol_ind}(temp_ind, region_ind) = sum_krec_dtau(krecs_slice, Ks, Js, vib_syms_well, dtau_func);
      end
    end
  end
  etas = krecs_dtau{2}(:, asym_ind) ./ krecs_dtau{2}(:, sym_ind) / 2;
  total_686 = krecs_dtau{2}(:, sym_ind) + krecs_dtau{2}(:, asym_ind);
  deltas = (2/3 * total_686 ./ krecs_dtau{1}(:, 1) - 1) * 100;

  my_plot(temps_k, krecs_dtau{1}(:, 1), "Temperature, K", "k_{rec}, m^6/s", figure_id=figure_ids(1), color=3);
  my_plot(temps_k, 2/3*total_686, figure_id=figure_ids(1), color=color_ind, line_style="-");
%   my_plot(pressure_bar, 2*krecs_dtau{2}(:, sym_ind), figure_id=1, color=2, line_style="-");
%   my_plot(pressure_bar, krecs_dtau{2}(:, asym_ind), figure_id=1, color=3, line_style="-");

  my_plot(temps_k, deltas, "Temperature, K", "\delta, %", figure_id=figure_ids(2), color=color_ind);
  plot_delta_686_vs_temperature_experimental();
  plot_delta_676_vs_temperature_experimental();

  my_plot(temps_k, etas, "Temperature, K", "\eta", figure_id=figure_ids(3), color=color_ind);
  plot_eta_vs_temperature_experimental();
end