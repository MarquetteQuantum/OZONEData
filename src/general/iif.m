function out = iif(cond, true_val, false_val)
  if length(cond) == 1
    if cond == 1
      out = true_val;
    else
      out = false_val;
    end
  elseif length(cond) == length(true_val)
    out = false_val;
    out(cond) = true_val(cond);
  else
    error('Wrong length of cond');
  end
end