function krec_total = sum_krec_dtau(krec_matrix, Ks, Js, vib_syms_well, dtau_func)
% Adds up the values of krec with their respective dtau multipliers
% krec_matrix is assumed to be K x J x sym. Ks, Js, and vib_sym_wells are 1D arrays that provide corresponding labels
  krec_total = 0;
  for J_ind = 1:size(krec_matrix, 2)
    for K_ind = 1:size(krec_matrix, 1)
      for sym_ind = 1:size(krec_matrix, 3)
        dtau = dtau_func(Js(J_ind), Ks(K_ind), vib_syms_well(sym_ind));
        krec_total = krec_total + krec_matrix(K_ind, J_ind, sym_ind) * dtau;
      end
    end
  end
end