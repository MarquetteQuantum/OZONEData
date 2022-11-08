function f = create_loglog_plot()
    f = create_y_log_plot();
    set(gca, 'XScale', 'log');
end