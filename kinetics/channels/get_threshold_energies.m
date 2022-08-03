function [threshold_energies_j, threshold_js] = get_threshold_energies(o3_molecule, Ks, K_vib_syms_well, optional)
% Returns threshold energies for all channels and given values of Ks
  channels = get_ozone_channels(o3_molecule);
  threshold_energies_j = zeros(length(Ks), length(K_vib_syms_well), size(channels, 1));
  threshold_js = zeros(length(Ks), length(K_vib_syms_well), size(channels, 1));
  for K_ind = 1:length(Ks)
    K = Ks(K_ind);
    for sym_ind = 1:length(K_vib_syms_well)
      K_vib_sym_well = K_vib_syms_well(sym_ind);
      for ch = 1:size(channels, 1)
        [threshold_energies_j(K_ind, sym_ind, ch), threshold_js(K_ind, sym_ind, ch)] = ...
          get_threshold_energy_K_ch(o3_molecule, channels(ch, 2), K, K_vib_sym_well, optional);
      end
    end
  end
end