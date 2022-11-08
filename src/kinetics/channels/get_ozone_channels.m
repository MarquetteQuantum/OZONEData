function channels = get_ozone_channels(o3_molecule)
% Returns channel labels associated with a given o3 (each channel in row)
  channels = [string(o3_molecule(2)), string(o3_molecule([1, 3]))];
  if ~is_monoisotopic(o3_molecule)
    channels = [channels; string(o3_molecule(1)), string(sort(o3_molecule(2:3)))];
  end
end