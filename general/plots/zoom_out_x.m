function zoom_out_x(stretch_factor)
    % zooms current plot out by specified factor along x-axis
    if nargin < 1
      stretch_factor = 1.05;
    end
    x_limits = xlim;
    x_len = x_limits(2) - x_limits(1);
    x_mid = (x_limits(1) + x_limits(2)) / 2;
    xlim([x_mid - x_len * stretch_factor / 2, x_mid + x_len * stretch_factor / 2]);
end