function plot_krec_JK_map()
% Reads krecs from file and plots JK maps
  load_path = "C:\Users\3830gaydayi\Desktop\buf\krecs\all\";
  load(load_path + "krecs.mat");
  Js = [0:32, 36:4:40];
  Ks = 0:20;
  for o3_molecule_ind = 1:size(krecs_m6_per_s, 2)
    for sym_ind = 1:size(krecs_m6_per_s, 5)
      for pressure_ind = 1:size(krecs_m6_per_s, 1)
        plot_matrix(krecs_m6_per_s(pressure_ind, o3_molecule_ind, :, :, sym_ind), ...
          x_tick_labels=Js, y_tick_labels=Ks, xlabel="J", ylabel="K");
        plot_matrix(propagation_times(pressure_ind, o3_molecule_ind, :, :, sym_ind) * 1e9, ...
          x_tick_labels=Js, y_tick_labels=Ks, xlabel="J", ylabel="K");
        plot_matrix(execution_times(pressure_ind, o3_molecule_ind, :, :, sym_ind), ...
          x_tick_labels=Js, y_tick_labels=Ks, xlabel="J", ylabel="K");
      end
    end
  end
end