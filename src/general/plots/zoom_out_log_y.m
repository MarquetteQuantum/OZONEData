function zoom_out_log_y()
% Zooms out y scale in log sense
  n_ticks = 0.2;
  y_limits = ylim;
  ylim([y_limits(1) / (n_ticks * 10), y_limits(2) * n_ticks * 10]);
end