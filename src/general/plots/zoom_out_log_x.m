function zoom_out_log_x()
% Zooms out x-scale in log sense
  n_ticks = 0.2;
  x_limits = xlim;
  xlim([x_limits(1) / (n_ticks * 10), x_limits(2) * n_ticks * 10]);
end