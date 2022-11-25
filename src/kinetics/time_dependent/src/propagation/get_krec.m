function krecs_m6_per_s = get_krec(derivatives_per_m3_s, M_per_m3, reactants_per_m3, concentration_total_per_m3, equilibrium_constant_total_m3)
% Calculates krec vs time
  krecs_m6_per_s = derivatives_per_m3_s ./ (M_per_m3 * (prod(reactants_per_m3) - concentration_total_per_m3 / equilibrium_constant_total_m3));
end