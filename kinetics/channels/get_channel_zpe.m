function zpe_j = get_channel_zpe(o2_molecule)
% Returns zero-point energy of a given channel
  zpe_j = getvar(strcat('zpe_', o2_molecule, '_cm_1')) * getvar('j_per_cm_1');
end