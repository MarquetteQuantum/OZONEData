function xticklabels_every_order(order)
% Places y-ticks and labels at every order
  if nargin < nargin(@xticklabels_every_order)
    order = 1;
  end
  
  xlimits = xlim;
  first_tick = fix(log10(xlimits(1)));
  last_tick = fix(log10(xlimits(2)));
  nticks = (last_tick - first_tick) / order + 1;
  xticks(logspace(first_tick, last_tick, nticks));
end