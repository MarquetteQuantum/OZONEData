function plot_krec_JK_map()
% Reads krecs from file and plots JK maps
  load_path = "C:\Users\3830gaydayi\Desktop\buf\krecs\666\total\no_vdw\gamma_min_1\gamma_max_15\sigma_3200\vdw_min_0.3\pressure";
  load(fullfile(load_path, "env.mat"));
  load(fullfile(load_path, "krecs.mat"));
  region_ind = 1;
  for sym_ind = 1:size(krecs_m6_per_s, 5)
    for pressure_ind = [1, size(krecs_m6_per_s, 1)]
      for temp_ind = 1:1
        plot_matrix(krecs_m6_per_s(pressure_ind, temp_ind, :, :, sym_ind, region_ind), x_tick_labels=Js, y_tick_labels=Ks, xlabel="J", ylabel="K");
%         plot_matrix(propagation_times_s(pressure_ind, temp_ind, :, :, sym_ind) * 1e9, x_tick_labels=Js, y_tick_labels=Ks, xlabel="J", ylabel="K");
%         plot_matrix(execution_times(pressure_ind, temp_ind, :, :, sym_ind), x_tick_labels=Js, y_tick_labels=Ks, xlabel="J", ylabel="K");
      end
    end
  end
end