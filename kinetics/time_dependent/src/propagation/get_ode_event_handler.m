function handle = get_ode_event_handler(derivatives_func, region_probs, equilibrium_constants_region_m3, M_per_m3, ...
  channel_ind)
% Returns a function that decides when propagation should stop
  pressure_ratio = M_per_m3 / 6.44e24;
  time_min_s = 1e-9 / pressure_ratio;
  time_mult = 2;
  convergence = 1e-3;
  
  prev_time_s = 0;
  prev_krec_m6_per_s = 1;
  handle = @ode_event_handler;

  function [value, isterminal, direction] = ode_event_handler(time_s, concentrations_per_m3)
  % Calculates krec and signals to stop propagation if it reached a constant value
    value = 1;
    isterminal = 1;
    direction = 0;
    if time_s > time_min_s && time_s > prev_time_s * time_mult 
      concentrations_region_per_m3 = concentrations_per_m3;
      concentrations_region_per_m3(1:size(equilibrium_constants_region_m3, 1)) = ...
        concentrations_region_per_m3(1:size(equilibrium_constants_region_m3, 1)) .* region_probs;

      derivatives_per_m3_s = derivatives_func(0, concentrations_per_m3);
      derivatives_region_per_m3_s = derivatives_per_m3_s;
      derivatives_region_per_m3_s(1:size(equilibrium_constants_region_m3, 1)) = ...
        derivatives_region_per_m3_s(1:size(equilibrium_constants_region_m3, 1)) .* region_probs;

      krec_m6_per_s = get_krec(concentrations_region_per_m3', derivatives_region_per_m3_s', ...
        equilibrium_constants_region_m3, M_per_m3, channel_ind);
      if abs(krec_m6_per_s / prev_krec_m6_per_s - 1) < convergence
        value = 0;
      end
      prev_time_s = time_s;
      prev_krec_m6_per_s = krec_m6_per_s;
    end
  end
end