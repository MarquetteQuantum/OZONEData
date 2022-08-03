function key = get_key_half(mol, J, K, vib_sym_inf)
% Returns data key corresponding to given molecule, rotational state and symmetry
  key = ['mol_', mol, '\half_integers\J_', num2str(J), '\K_', num2str(K), ...
    '\symmetry_', num2str(vib_sym_inf)];
end