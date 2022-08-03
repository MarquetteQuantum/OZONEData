function ind = get_lower_channel_ind(o3_molecule)
% Returns index of lower channel
  if is_singly_substituted(o3_molecule)
    ind = 2;
  else
    ind = 1;
  end
end