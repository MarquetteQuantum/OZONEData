function subs = get_JK_sym_subs(states_map, o3_molecule, Js, Ks, syms)
% sorts states map into 3D cell array J x K x sym. Cuts off bound states
  subs = cell(length(Js), length(Ks), length(syms));
  for J_ind = 1:length(Js)
    J = Js(J_ind);
    for K_ind = 1:length(Ks)
      K = Ks(K_ind);
      if K > J
        break
      end

      if J > 32 && mod(K, 2) == 1
        continue
      end
      
      for sym_ind = 1:length(syms)
        sym = syms(sym_ind);
        key = get_key(o3_molecule, J, K, sym);
        data_set = states_map(key);
        subs{J_ind, K_ind, sym_ind} = data_set;
      end
    end
  end
end