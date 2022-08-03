function symmetric_int_color_axis()
    cl = caxis;
    next_int = ceil(round_n(max(cl), 10));
    caxis([-next_int, next_int]);
end