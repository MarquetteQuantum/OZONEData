function states = assign_trivial_separation(states)
% Add trivial separation to monoisotopic species to make processing uniform with isotopically substituted cases
  states{:, "sym"} = states{:, "cov"};
  states{:, "asym"} = 0;
  states{:, "vdw_a"} = states{:, "vdw"};
  states{:, "vdw_a_sym"} = states{:, "vdw"};
  states{:, "vdw_a_asym"} = 0;
  states{:, "vdw_b"} = 0;
  states{:, "sym_mol"} = states{:, "cov"} + states{:, "vdw"};
  states{:, "asym_mol"} = 0;
  states{:, "gamma_a"} = 0;
  states{:, "gamma_b"} = states{:, "gamma_total"};
end