function [threshold_energies_j, threshold_js] = get_threshold_energies_2(o3_molecule, states, optional)
% Returns threshold energies for all channels and existing values of Ks in states
  arguments
    o3_molecule
    states
    optional.K_dependent_threshold = false
  end

  Ks = unique(states{:, 'K'});
  K_vib_syms_well = unique(states{:, 'vib_sym_well'});
  [threshold_energies_j, threshold_js] = get_threshold_energies(o3_molecule, Ks, K_vib_syms_well, ...
    K_dependent_threshold=optional.K_dependent_threshold);
end