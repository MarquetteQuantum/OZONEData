function symmetric_y_axis()
% sets y-limits the same
    ticks = yticks;
    
%     tick_step = ticks(2) - ticks(1);
%     next_tick_up = ticks(end) + tick_step;
%     next_tick_down = ticks(1) - tick_step;

    next_tick_up = ticks(end);
    next_tick_down = ticks(1);
    max_tick = max(abs([next_tick_up, next_tick_down]));
    ylim([-max_tick, max_tick]);
end