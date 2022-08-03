function apply_common_settings(f)
  f.WindowState = 'maximized';
  change_axis_font_size(30);
  pbaspect([1.5, 1, 1]);
  colormap('jet');
  box on
  hold on
end