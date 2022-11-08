function integer_x_ticks()
  curtick = get(gca, 'xTick');
  xticks(unique(round(curtick)));
end