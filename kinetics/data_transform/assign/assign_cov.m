function states = assign_cov(states)
% Assigns total probability in covalent wells
  states{:, 'cov'} = states{:, 'sym'} + states{:, 'asym'};
end