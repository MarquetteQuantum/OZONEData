function states = assign_extra_properties(o3_molecule, states)
% Assigns extra properties necessary for kinetics calculations
  states = assign_K(states);
  states = assign_K_ind(states);
  states = assign_K_vib_sym_well(states);
  states = assign_K_vib_sym_well_ind(states);
  states = assign_degeneracy(states);
  if is_monoisotopic(o3_molecule)
    % Add trivial separation to make processing uniform with 686
    states{:, 'sym'} = states{:, 'cov'};
    states{:, 'asym'} = 0;
    states{:, 'vdw_a_sym'} = states{:, 'vdw'};
    states{:, 'vdw_a_asym'} = 0;
    states{:, 'vdw_b'} = 0;
    states{:, 'sym_mol'} = states{:, 'cov'} + states{:, 'vdw'};
    states{:, 'gamma_a'} = 0;
    states{:, 'gamma_b'} = states{:, 'gamma_total'};
  else
    states = assign_cov(states);
    states = assign_vdw(states);
    states = assign_sym_mol(states);
    states = assign_asym_mol(states);
  end
end