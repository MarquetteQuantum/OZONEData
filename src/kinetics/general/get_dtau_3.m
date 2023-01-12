function mult = get_dtau_3(J, K, vib_sym_well)
% For the version with each J and K
  mult = 1;
  if K == 0 && mod(J + vib_sym_well, 2) == 1
    mult = 0;
  end
end