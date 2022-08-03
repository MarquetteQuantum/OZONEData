function xticklabels_every(n)
% Places y tick labels on ticks divisible by n
  xticklabels(arrayfun(@(x) iif(mod(x, n) == 0, num2str(x), ''), xticks, 'UniformOutput', 0));
end