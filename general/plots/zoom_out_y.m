function zoom_out_y(stretch_factor)
    % zooms current plot out by specified factor along y-axis
    if nargin < 1
      stretch_factor = 1.05;
    end
    y_limits = ylim;
    y_len = y_limits(2) - y_limits(1);
    y_mid = (y_limits(1) + y_limits(2)) / 2;
    ylim([y_mid - y_len * stretch_factor / 2, y_mid + y_len * stretch_factor / 2]);
end