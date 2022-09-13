function key = get_key_vib_well(mol, J, K, vib_well_sym)
% Returns data key corresponding to given molecule, rotational state and vibrational symmetry in the well
% Vibrational symmetry in the channel is selected as allowed
  if mod(K, 2) == 0
    key = get_key_vib(mol, J, K, [vib_well_sym, 1]);
  else
    key = get_key_vib(mol, J, K, [vib_well_sym, 0]);
  end
end