function states = assign_sym_mol(states)
% Assigns total probability of symmetric molecule
  states{:, "sym_mol"} = states{:, "sym"} + states{:, "vdw_a_sym"};
end