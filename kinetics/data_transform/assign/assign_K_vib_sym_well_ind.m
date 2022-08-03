function states = assign_K_vib_sym_well_ind(states)
% Assigns indices of vibrational symmetry in well. 
% Assumes vibrational symmetry in well is assigned.
  vib_syms_well = unique(states{:, 'vib_sym_well'});
  states{:, 'vib_sym_well_ind'} = ...
    arrayfun(@(vib_sym_well) find(vib_sym_well == vib_syms_well, 1), states{:, 'vib_sym_well'});
end