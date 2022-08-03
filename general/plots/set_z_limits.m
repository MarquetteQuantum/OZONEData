function set_z_limits(limits)
    if isnan(limits(1))
        limits(1) = min(zlim);
    end
    if isnan(limits(2))
        limits(2) = max(zlim);
    end
    zlim(limits);
end