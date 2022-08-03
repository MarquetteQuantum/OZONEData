function states = assign_degeneracy(states)
% Assigns degeneracy to states
  states{:, 'degeneracy'} = 2 * states{:, 'J'} + 1;
end