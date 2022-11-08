function yticklabels_every_val(n)
% Places y tick labels on ticks divisible by n
  yticklabels(arrayfun(@(x) iif(mod(x, n) == 0, num2str(x), ''), yticks, 'UniformOutput', 0));
end