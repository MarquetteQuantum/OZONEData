function symmetric_color_axis()
  cl = caxis;
  max_cl = max(abs(cl));
  caxis([-max_cl, max_cl]);
end