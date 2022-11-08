function key = get_key_vib(mol, J, K, vib_sym)
% Returns data key corresponding to given molecule, rotational state and vibrational symmetry
% Vibrational symmetry is described by 1x2 array of symmetry in the well and dissociation channel
  key = ['mol_', mol];
  if vib_sym(1) ~= vib_sym(2)
    key = fullfile(key, 'half_integers');
  end

  if mod(K, 2) == 0
    total_sym = vib_sym;
  else
    total_sym = 1 - vib_sym;
  end

  key = fullfile(key, ['J_', num2str(J)], ['K_', num2str(K)], ['symmetry_', num2str(total_sym(2))]);
end