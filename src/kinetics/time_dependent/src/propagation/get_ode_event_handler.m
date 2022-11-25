function event_handler = get_ode_event_handler(eval_step_s, derivatives_func, M_per_m3, equilibrium_constants_total_m3, channel_ind, region_probs, optional)
% Returns a function that decides when propagation should stop
  arguments
    eval_step_s
    derivatives_func
    M_per_m3
    equilibrium_constants_total_m3
    channel_ind
    region_probs
    optional.separate_concentrations = false
    optional.time_factor = 1.99
    optional.convergence = 0.01
    optional.converged_steps = 2
  end

  converged_steps = 0;
  eval_times_s = [];
  krecs_m6_per_s = [];
  event_handler = @ode_event_handler;

  function [value, isterminal, direction] = ode_event_handler(time_s, concentrations_per_m3)
  % Calculates krec and signals to stop propagation if it reached a constant value
    value = 1;
    isterminal = 1;
    direction = 0;

    if isempty(eval_times_s) || time_s >= eval_times_s(end) + eval_step_s
      next_krecs_m6_per_s = get_krec_regions(concentrations_per_m3, derivatives_func, M_per_m3, equilibrium_constants_total_m3, channel_ind, region_probs, ...
        separate_concentrations=optional.separate_concentrations);
      eval_times_s(end + 1) = time_s;
      krecs_m6_per_s(:, end + 1) = next_krecs_m6_per_s;

      comparison_ind = find(time_s / optional.time_factor < eval_times_s, 1) - 1;
      if all(krecs_m6_per_s(:, end) == 0) || ~isempty(comparison_ind) && ...
          max(abs(krecs_m6_per_s(:, end) ./ krecs_m6_per_s(:, comparison_ind) - 1)) < optional.convergence
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