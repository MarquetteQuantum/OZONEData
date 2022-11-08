function states = assign_K(states)
% Creates a column K that stores value of K for the symmetric top rotor states if it does not exist
  if ~any("K" == states.Properties.VariableNames)
    states{:, 'K'} = cellfun(@(arr) find(arr == 1, 1), states{:, 'k_probs'}) - 1;
    states = movevars(states, 'K', 'After', 'J');
  end
end