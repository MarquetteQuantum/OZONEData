function plot_gamma_vs_energy()
% Plots gammas vs energies
  j_per_cm = get_j_per_cm();

  o3_molecule = '666';
  Js = [0:32, 36:4:64];
  Ks = 0:20;
  vib_syms_well = 0:1;

  energy_range_j = [-3000, 300] * j_per_cm;
  gamma_range_j = [0, inf] * j_per_cm;
  closed_channel = "";
  localization_threshold = 1e-3;
  gamma_mult = 1;

  resonances_prefix = [fullfile('data', 'resonances'), filesep];
  resonances_format = iif(o3_molecule == "868", "686", o3_molecule);
  barriers_prefix = [fullfile('data', 'barriers'), filesep];

  for J = Js
    for K = Ks
      if K > J || J > 32 && mod(K, 2) == 1
        continue
      end
      for vib_sym_well = vib_syms_well
        data_key = get_key_vib_well(o3_molecule, J, K, vib_sym_well);
        states = read_resonances(fullfile(resonances_prefix, data_key), resonances_format, delim=resonances_prefix);
        states = states(data_key);
        states = process_states(barriers_prefix, o3_molecule, states, energy_range_j, gamma_range_j, closed_channel=closed_channel, ...
          localization_threshold=localization_threshold, gamma_mult=gamma_mult);
        my_plot(states{:, "energy"} / j_per_cm, states{:, "gamma_total"} / j_per_cm, "Energy, cm^{-1}", "Gamma total, cm^{-1}", yscale="log", ...
          xlim=[0, 1000], line_style="none", figure_id=1);
      end
    end
  end
end