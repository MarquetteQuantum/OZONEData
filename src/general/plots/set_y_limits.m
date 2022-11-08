function set_y_limits(limits)
  if all(isnan(limits))
    return
  end
  if isnan(limits(1))
    limits(1) = min(ylim);
  end
  if isnan(limits(2))
    limits(2) = max(ylim);
  end
  ylim(limits);
end