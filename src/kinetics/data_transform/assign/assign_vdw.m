function states = assign_vdw(states)
% Assigns total probability in Van der Waals regions
  states{:, "vdw_a"} = states{:, "vdw_a_sym"} + states{:, "vdw_a_asym"};
  states{:, "vdw_asym"} = states{:, "vdw_a_asym"} + states{:, "vdw_b"};
  states{:, "vdw"} = states{:, "vdw_a_sym"} + states{:, "vdw_asym"};
end