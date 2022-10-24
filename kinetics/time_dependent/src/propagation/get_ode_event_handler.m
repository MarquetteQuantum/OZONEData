function handle = get_ode_event_handler(derivatives_func, region_probs, equilibrium_constants_region_m3, M_per_m3, ...
  channel_ind, eval_step_s, optional)
% Returns a function that decides when propagation should stop
  arguments
    derivatives_func
    region_probs
    equilibrium_constants_region_m3
    M_per_m3
    channel_ind
    eval_step_s
    optional.comparison_factor = 2
    optional.convergence = 0.005
    optional.converged_steps = 2
  end

  eval_times_s = 0;
  krecs_m6_per_s = inf;
  converged_steps = 0;
  handle = @ode_event_handler;

  function [value, isterminal, direction] = ode_event_handler(time_s, concentrations_per_m3)
  % Calculates krec and signals to stop propagation if it reached a constant value
    value = 1;
    isterminal = 1;
    direction = 0;

    if time_s >= eval_times_s(end) + eval_step_s
      concentrations_region_per_m3 = concentrations_per_m3;
      concentrations_region_per_m3(1:size(equilibrium_constants_region_m3, 1)) = ...
        concentrations_region_per_m3(1:size(equilibrium_constants_region_m3, 1)) .* region_probs;

      derivatives_per_m3_s = derivatives_func(0, concentrations_per_m3);
      derivatives_region_per_m3_s = derivatives_per_m3_s;
      derivatives_region_per_m3_s(1:size(equilibrium_constants_region_m3, 1)) = ...
        derivatives_region_per_m3_s(1:size(equilibrium_constants_region_m3, 1)) .* region_probs;

      krec_m6_per_s = get_krec(concentrations_region_per_m3', derivatives_region_per_m3_s', ...
        equilibrium_constants_region_m3, M_per_m3, channel_ind);
      
      eval_times_s(end + 1) = time_s;
      krecs_m6_per_s(end + 1) = krec_m6_per_s;
      comparison_ind = find(time_s / optional.comparison_factor < eval_times_s, 1) - 1;
      if abs(krecs_m6_per_s(end) / krecs_m6_per_s(comparison_ind) - 1) < optional.convergence
        converged_steps = converged_steps + 1;
        if converged_steps >= optional.converged_steps
          value = 0;
        end
      else
        converged_steps = 0;
      end
    end
  end
end