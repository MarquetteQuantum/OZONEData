function mult = get_dtau_2(J, K, sym)
% For the version with each J and K up to 32 and 4/2 spacing in J/K after
% sym is either total or vibrational sym in well
  if K == 0
    if J < 32
      if mod(J + sym, 2) == 0
        mult = 1;
      else
        mult = 0;
      end
    elseif J == 32
      if sym == 0
        mult = 1.5;
      else
        mult = 1;
      end
    elseif J > 32
      mult = 4;
    end

  elseif K > 0
    if J < 32
      mult = 1;
    elseif J == 32
      mult = 2.5;
    elseif J > 32
      mult = 8;
    end
  end
end