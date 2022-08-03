function set_x_limits(limits)
  if all(isnan(limits))
    return
  end
  if isnan(limits(1))
    limits(1) = min(xlim);
  end
  if isnan(limits(2))
    limits(2) = max(xlim);
  end
  xlim(limits);
end