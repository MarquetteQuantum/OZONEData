function o2_threshold_j = get_o2_threshold_j(o2_molecule, K, K_vib_sym_well, optional)
% Returns threshold value of j in O2 for given K of O3
% K_vib_sym_well is not used anymore, but kept for compatibility with the calling code. It can be removed.
  arguments
    o2_molecule
    K
    K_vib_sym_well
    optional.K_dependent_threshold = false
  end
  
  if ~optional.K_dependent_threshold
    if is_monoisotopic(o2_molecule)
      o2_threshold_j = 1;
    else
      o2_threshold_j = 0;
    end
  else
    if is_monoisotopic(o2_molecule) && mod(K, 2) == 0
      o2_threshold_j = K + 1;
    else
      o2_threshold_j = K;
    end
  end
end