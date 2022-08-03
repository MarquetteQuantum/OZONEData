function states = assign_K_ind(states)
% Assigns K indices to states. Assumes K is assigned.
  Ks = unique(states{:, 'K'});
  states{:, 'K_ind'} = arrayfun(@(K) find(Ks == K, 1), states{:, 'K'});
  states = movevars(states, 'K_ind', 'After', 'K');
end