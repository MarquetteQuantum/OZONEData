function plot_concentrations_vs_energy(states, concentrations)
  j_per_cm_1 = getvar('j_per_cm_1');
  create_y_log_plot();
  series = 11;
  step = (size(concentrations, 1) - 1) / (series - 1);
  colors = distinguishable_colors(series);
  for i = 0 : series - 1
    plot(states{:, 'energy'} / j_per_cm_1, concentrations(1 + i*step, :), '.-', ...
      'Color', colors(i + 1, :));
  end
  xlabel('Energy, cm^{-1}');
  ylabel('[O_3], m^{-3}');
end