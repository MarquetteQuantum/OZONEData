function states = assign_vdw(states)
% Assigns total probability in Van der Waals regions
  states{:, 'vdw'} = states{:, 'vdw_a_sym'} + states{:, 'vdw_a_asym'} + states{:, 'vdw_b'};
end