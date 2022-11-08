function f = create_common_plot(figure_id)
  if nargin < nargin(@create_common_plot)
    figure_id = 0;
  end
  new_figure = figure_id == 0 || ~ishandle(figure_id);
  
  if figure_id == 0
    f = figure;
  else
    f = figure(figure_id);
  end

  if new_figure
    apply_common_settings(f);
  end
end