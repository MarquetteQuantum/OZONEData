function plot_delta_vs_time()
% Plots delta vs time
  data_path_666 = "C:\Users\3830gaydayi\Desktop\buf\krecs\666\total\vdw\gamma_min_1\gamma_max_15\energy_max_50\sigma_3200\time";
  data_path_686 = "C:\Users\3830gaydayi\Desktop\buf\krecs\686\total\vdw\gamma_min_1\gamma_max_15\energy_max_50\sigma_3200\time";

  color_ind = 1;
  sym_ind = 1;
  asym_ind = 2;
  figure_ids = 0 + (1:3);
  dtau_func = @get_dtau_3;

  load(fullfile(data_path_666, "env.mat"));
  time_ns = base_time_s * ref_pressure_per_m3 / M_concs_per_m3 * 1e9;

  load(fullfile(data_path_666, "krecs.mat"));
  krecs{1} = squeeze(krecs_m6_per_s(1, 1, :, :, :, :));
  
  load(fullfile(data_path_686, "krecs.mat"));
  krecs{2} = squeeze(krecs_m6_per_s(1, 1, :, :, :, :));
  
  krecs_dtau = cell(size(krecs));
  for mol_ind = 1:length(krecs)
    for time_ind = 1:length(time_ns)
      for region_ind = 1:size(krecs{mol_ind}, 4)
        krecs_slice = squeeze(krecs{mol_ind}(:, :, :, region_ind));
        krecs_slice = cellfun(@(krecs) get_ith_krec(krecs, time_ind), krecs_slice);
        krecs_dtau{mol_ind}(time_ind, region_ind) = sum_krec_dtau(krecs_slice, Ks, Js, vib_syms_well, dtau_func);
      end
    end
  end
  etas = krecs_dtau{2}(:, asym_ind) ./ krecs_dtau{2}(:, sym_ind) / 2;
  total_686 = krecs_dtau{2}(:, sym_ind) + krecs_dtau{2}(:, asym_ind);
  deltas = (2/3 * total_686 ./ krecs_dtau{1}(:, 1) - 1) * 100;

  my_plot(time_ns, krecs_dtau{1}(:, 1), "Time, ns", "k_{rec}, m^6/s", figure_id=figure_ids(1), color=3, xlim=[0, 10]);
  my_plot(time_ns, 2/3*total_686, figure_id=figure_ids(1), color=color_ind, line_style="-");
%   my_plot(pressure_bar, 2*krecs_dtau{2}(:, sym_ind), figure_id=1, color=2, line_style="-");
%   my_plot(pressure_bar, krecs_dtau{2}(:, asym_ind), figure_id=1, color=3, line_style="-");

  my_plot(time_ns, deltas, "Time, ns", "\delta, %", figure_id=figure_ids(2), color=color_ind, xlim=[0, 10]);
  my_plot(time_ns, etas, "Time, ns", "\eta", figure_id=figure_ids(3), color=color_ind, xlim=[0, 10]);
end

function krec = get_ith_krec(krecs, i)
  if isempty(krecs)
    krec = 0;
  else
    krec = krecs(min(i, length(krecs)));
  end
end