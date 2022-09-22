function krec_m6_per_s = get_krec_2(concentrations_per_m3, derivatives_func, equilibrium_constants_m3, M_per_m3, ...
  channel_ind)
% Calculates krec vs time based on the results on propagation wrt to a given channel and given region
% Derivative func is the rhs of the master equation
  derivatives_per_m3_s = derivatives_func(0, concentrations_per_m3);
  krec_m6_per_s = get_krec(concentrations_per_m3', derivatives_per_m3_s', equilibrium_constants_m3, M_per_m3, ...
    channel_ind);
end