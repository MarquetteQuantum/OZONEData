function states = assign_K_vib_sym_well(states)
% Assigns vibrational symmetry in well. Assumes K is assigned.
  states{:, 'vib_sym_well'} = ...
    mod(states{:, 'K0_sym'} + states{:, 'K'} + states{:, 'is_half_integer'}, 2);
end