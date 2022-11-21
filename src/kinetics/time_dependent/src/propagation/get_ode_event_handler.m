function [event_handler, krec_return] = get_ode_event_handler(derivatives_func, equilibrium_constants_full_m3, ...
  channel_ind, M_per_m3, eval_step_s, region_probs, optional)
% Returns a function that decides when propagation should stop
  arguments
    derivatives_func
    equilibrium_constants_full_m3
    channel_ind
    M_per_m3
    eval_step_s
    region_probs
    optional.separate_concentrations = false
    optional.comparison_factor = 1.99
    optional.convergence = 0.01
    optional.converged_steps = 2
  end

  eval_times_s = [];
  converged_steps = 0;
  krecs_m6_per_s = [];

  event_handler = @ode_event_handler;
  krec_return = @get_krecs;

  function [value, isterminal, direction] = ode_event_handler(time_s, concentrations_per_m3)
  % Calculates krec and signals to stop propagation if it reached a constant value
    value = 1;
    isterminal = 1;
    direction = 0;

    if isempty(eval_times_s) || time_s >= eval_times_s(end) + eval_step_s
      num_states = iif(optional.separate_concentrations, numel(region_probs), size(region_probs, 1));
      derivatives_per_m3_s = derivatives_func(0, concentrations_per_m3);
      derivatives_o3_per_m3_s = derivatives_per_m3_s(1:num_states);
      if ~optional.separate_concentrations
        derivatives_region_per_m3_s = region_probs .* derivatives_o3_per_m3_s;
      else
        derivatives_region_per_m3_s = reshape(derivatives_o3_per_m3_s, [], size(region_probs, 2));
      end
      derivatives_region_per_m3_s = sum(derivatives_region_per_m3_s, 1);
      concentrations_o3_per_m3 = concentrations_per_m3(1:num_states);
      concentrations_reactants_per_m3 = reshape(concentrations_per_m3(num_states + 1 : end), 2, []);
      next_krecs_m6_per_s = get_krec(derivatives_region_per_m3_s, sum(concentrations_o3_per_m3), ...
        equilibrium_constants_full_m3(channel_ind), M_per_m3, concentrations_reactants_per_m3(:, channel_ind));
      
      eval_times_s(end + 1) = time_s;
      krecs_m6_per_s(:, end + 1) = next_krecs_m6_per_s;
      comparison_ind = find(time_s / optional.comparison_factor < eval_times_s, 1) - 1;
      if ~isempty(comparison_ind) && ...
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

  function [krecs, time] = get_krecs()
    krecs = krecs_m6_per_s;
    time = eval_times_s;
  end
end