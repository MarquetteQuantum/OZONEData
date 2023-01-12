function weights = calculate_weights(kdecs_per_s, ktrans_ub_m3_per_s, M_conc_per_m3)
% Calculates Lindemann resonance weights
  weights = kdecs_per_s ./ (kdecs_per_s + ktrans_ub_m3_per_s * M_conc_per_m3);
  weights(isnan(weights)) = 0;
end