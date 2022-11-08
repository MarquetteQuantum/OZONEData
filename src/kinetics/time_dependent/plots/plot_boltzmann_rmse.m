function plot_boltzmann_rmse(states, concentrations, temp_k, time_s)
% Plots RMSE between concentrations at different times and Boltzmann distribution
  j_per_k = getvar('j_per_k');
  kt_energy_j = temp_k * j_per_k;
  [boltzmann_sum, boltzmann_i] = calc_part_func_plain(states{:, 'energy'}, ...
    ones(size(states, 1), 1), states{1, 'energy'}, kt_energy_j);
  boltzmann_norm = boltzmann_i / boltzmann_sum;
  concentrations_norm = column_function(@(o3_concs) o3_concs ./ sum(o3_concs), concentrations');
  boltzmann_rmse = ...
    sqrt(sum((concentrations_norm - boltzmann_norm) .^ 2) / size(concentrations, 2));
  
  create_y_log_plot();
  plot(time_s * 1e9, boltzmann_rmse, 'b.-', 'MarkerSize', 10);
  xlabel('Time, ns');
  ylabel('Relative Boltzmann RMSE');
end