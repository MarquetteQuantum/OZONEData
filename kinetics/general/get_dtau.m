function mult = get_dtau(J, K, sym)
  if J == 0 && K == 0
    if sym == 0
      mult = 1.325;
    else
      mult = 0.875;
    end
    
  elseif J == K
    mult = 3;
    
  elseif K == 0
    if J < 32
      mult = 2;
    elseif J == 32
      mult = 3;
    elseif J > 32
      mult = 4;
    end
    
  else
    if J < 32
      mult = 4;
    elseif J == 32
      mult = 6;
    elseif J > 32
      mult = 8;
    end
  end
end