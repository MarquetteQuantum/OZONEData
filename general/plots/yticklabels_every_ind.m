function yticklabels_every_ind(n)
% Places y tick labels on tick indices divisible by n
  y_ticks = yticks;
  yticklabels(arrayfun(@(ind) iif(mod(ind, n) == 0, num2str(y_ticks(ind)), ''), ...
    1:length(yticks), 'UniformOutput', 0));
end