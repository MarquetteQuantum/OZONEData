function o2_threshold_j = get_o2_threshold_j(o2_molecule, K, K_vib_sym_well, optional)
% Returns threshold value of j in O2 for given K of O3
  if nargin < nargin(@get_o2_threshold_j)
    optional = nan;
  end
  
  k_dependent_threshold = get_or_default(optional, 'k_dependent_threshold', 0);
  if k_dependent_threshold == 0
    if is_monoisotopic(o2_molecule)
      o2_threshold_j = 1;
    else
      o2_threshold_j = 0;
    end
  else
    if is_monoisotopic(o2_molecule)
      if mod(K, 2) == 0
        o2_threshold_j = K + 1;
      else
        o2_threshold_j = K;
      end
    else
      if K_vib_sym_well == 0
        o2_threshold_j = K;
      else
        o2_threshold_j = K + 1;
      end
    end
  end
end