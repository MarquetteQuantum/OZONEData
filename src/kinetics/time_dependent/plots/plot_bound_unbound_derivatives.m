function plot_bound_unbound_derivatives(figure_id, style1, style2, time, do3dt_bound, do3dt_unbound)
  create_y_log_plot(figure_id);
  plot(time * 1e9, do3dt_bound * 1e-9, style1, 'MarkerSize', 10);
  plot(time * 1e9, do3dt_unbound * 1e-9, style2, 'MarkerSize', 10);
  xlabel('Time, ns');
  ylabel('d[O_3]/dt, m^{-3}/ns');
  xlim([0, 60]);
  ylim([1e0, 1e15]);
end