function handle = get_ode_event_handler(derivatives_func, region_probs, equilibrium_constants_region_m3, M_per_m3, ...
  channel_ind, eval_times_s, optional)
% Returns a function that decides when propagation should stop
% Assumes that eval_times_s is a uniform time grid
  arguments
    derivatives_func
    region_probs
    equilibrium_constants_region_m3
    M_per_m3
    channel_ind
    eval_times_s
    optional.comparison_factor = 2
    optional.convergence = 0.01
    optional.min_time_steps = 2
  end

  krecs_m6_per_s = zeros(size(eval_times_s));
  next_time_ind = 1;
  handle = @ode_event_handler;

  function [value, isterminal, direction] = ode_event_handler(time_s, concentrations_per_m3)
  % Calculates krec and signals to stop propagation if it reached a constant value
    value = 1;
    isterminal = 1;
    direction = 0;

    if time_s >= eval_times_s(next_time_ind)
      if time_s >= eval_times_s(next_time_ind + 1)
        error("Unexpected increase in propagation time step. Fix this.");
      end

      concentrations_region_per_m3 = concentrations_per_m3;
      concentrations_region_per_m3(1:size(equilibrium_constants_region_m3, 1)) = ...
        concentrations_region_per_m3(1:size(equilibrium_constants_region_m3, 1)) .* region_probs;

      derivatives_per_m3_s = derivatives_func(0, concentrations_per_m3);
      derivatives_region_per_m3_s = derivatives_per_m3_s;
      derivatives_region_per_m3_s(1:size(equilibrium_constants_region_m3, 1)) = ...
        derivatives_region_per_m3_s(1:size(equilibrium_constants_region_m3, 1)) .* region_probs;

      krec_m6_per_s = get_krec(concentrations_region_per_m3', derivatives_region_per_m3_s', ...
        equilibrium_constants_region_m3, M_per_m3, channel_ind);
      
      krecs_m6_per_s(next_time_ind) = krec_m6_per_s;
      comparison_ind = floor(next_time_ind / optional.comparison_factor);
      if next_time_ind > optional.min_time_steps && comparison_ind > 0 &&  ...
          abs(krecs_m6_per_s(next_time_ind) / krecs_m6_per_s(comparison_ind) - 1) < optional.convergence
        value = 0;
      end
      next_time_ind = next_time_ind + 1;
    end
  end
end