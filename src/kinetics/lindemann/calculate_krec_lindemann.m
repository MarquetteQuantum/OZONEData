function krec_m6_per_s = calculate_krec_lindemann(weights, equilibrium_consts_m3, ktran_ub_cov_m3_per_s)
% Calculates krec under Lindemann assumptions
  krec_m6_per_s = sum(weights .* equilibrium_consts_m3 .* ktran_ub_cov_m3_per_s);
end