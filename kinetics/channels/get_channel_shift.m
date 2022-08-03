function channel_shift_j = get_channel_shift(o3_molecule, o2_molecule)
% Returns vibrational shift energy for a given channel of a given O3 molecule 
% with respect to the lowest channel.
  channels = get_ozone_channels(o3_molecule);
  lower_channel_ind = get_lower_channel_ind(o3_molecule);
  if channels(lower_channel_ind, 2) == o2_molecule
    channel_shift_j = 0;
  else
    higher_channel_ind = 3 - lower_channel_ind;
    zpe_high_j = get_channel_zpe(channels(higher_channel_ind, 2));
    zpe_low_j = get_channel_zpe(channels(lower_channel_ind, 2));
    channel_shift_j = zpe_high_j - zpe_low_j;
  end
end