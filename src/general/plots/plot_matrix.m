function out = plot_matrix(matrix, optional)
  arguments
    matrix (:, :) double
    optional.y_inversion (1, 1) logical = false
    optional.blocks (1, :) double = []
    optional.blocks2 (1, :) double = []
    optional.color_range = "auto"
    optional.x_tick_labels = nan
    optional.y_tick_labels = nan
    optional.cell_labels = true
    optional.xlabel = ""
    optional.ylabel = ""
    optional.title = ""
  end

  if isempty(optional.blocks2)
    optional.blocks2 = optional.blocks;
  end

  matrix = horzcat(matrix, max(max(matrix)) * ones(size(matrix, 1), 1));
  matrix = vertcat(matrix, max(max(matrix)) * ones(1, size(matrix, 2)));

  create_common_plot();
  change_axis_font_size(15);
  out = pcolor(matrix);
  view(0, -90);
  colormap('jet');
  caxis(optional.color_range);
  colorbar
  axis equal
  xlim([1, size(matrix, 2)]);
  ylim([1, size(matrix, 1)]);
  xticks(0.5 + 1:size(matrix, 2));
  yticks(0.5 + 1:size(matrix, 1));
  set(gca, 'XAxisLocation', 'top');

  if ~optional.y_inversion
    axis ij
    set(gca, 'XAxisLocation', 'bottom');
  end
  
  if isnan(optional.x_tick_labels)
    xticklabels(arrayfun(@(x) num2str(x), 1:size(matrix, 2), 'UniformOutput', false));
  else
    xticklabels(optional.x_tick_labels);
  end
  
  if isnan(optional.y_tick_labels)
    yticklabels(arrayfun(@(x) num2str(x), 1:size(matrix, 1), 'UniformOutput', false));
  else
    yticklabels(optional.y_tick_labels);
  end
  
  if optional.cell_labels
    for j = 1:size(matrix, 2) - 1
      for i = 1:size(matrix, 1) - 1
        if isnan(matrix(i, j))
          continue
        end
        label = num2str(matrix(i, j), 3);
        label = regexprep(label, '(?<=e[-+])0', '');
        label = regexprep(label, 'e', '');
        text(j + 0.5, i + 0.5, label, 'HorizontalAlignment', 'center', 'FontSize', 6);
      end
    end
  end

  if ~isempty(optional.blocks)
    % transform data
    optional.blocks = cumsum(optional.blocks) + 1;
    optional.blocks2 = cumsum(optional.blocks2) + 1;

    % horizontal lines
    x_range = [1, size(matrix, 2)];
    for i = 1:length(optional.blocks) - 1
      if optional.blocks(i) == 1
        continue
      end
      line(x_range, [optional.blocks(i), optional.blocks(i)], 'LineWidth', 2, 'Color', get_color('green'));
    end

    % vertical lines
    y_range = [1, size(matrix, 1)];
    for i = 1:length(optional.blocks2) - 1
      if optional.blocks2(i) == 1
        continue
      end
      line([optional.blocks2(i), optional.blocks2(i)], y_range, 'LineWidth', 2, 'Color', get_color('green'));
    end
  end

  if optional.xlabel ~= ""
    xlabel(optional.xlabel);
  end
  if optional.ylabel ~= ""
    ylabel(optional.ylabel);
  end
  if optional.title ~= ""
    title(optional.title);
  end
end