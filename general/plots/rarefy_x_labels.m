function rarefy_x_labels()
% Removes every 2nd label on x-axis if there are more than 7
  current_labels = xticklabels;
  if length(current_labels) > 7
    current_labels(2:2:end) = {''};
    xticklabels(current_labels);
  end
end