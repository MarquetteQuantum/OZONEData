function yticklabels_every_order(order)
% Places y-ticks and labels at every order
  if nargin < nargin(@yticklabels_every_order)
    order = 1;
  end
  
  ylimits = ylim;
  first_tick = fix(log10(ylimits(1)));
  last_tick = fix(log10(ylimits(2)));
  nticks = (last_tick - first_tick) / order + 1;
  yticks(logspace(first_tick, last_tick, nticks));
end