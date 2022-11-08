function zoom_out(stretch_factor)
    % zooms current plot out by specified factor
    if nargin < 1
      stretch_factor = 1.05;
    end
    x_limits = xlim;
    y_limits = ylim;
    x_len = x_limits(2) - x_limits(1);
    y_len = y_limits(2) - y_limits(1);
    x_mid = (x_limits(1) + x_limits(2)) / 2;
    y_mid = (y_limits(1) + y_limits(2)) / 2;
    xlim([x_mid - x_len * stretch_factor / 2, x_mid + x_len * stretch_factor / 2]);
    ylim([y_mid - y_len * stretch_factor / 2, y_mid + y_len * stretch_factor / 2]);
end