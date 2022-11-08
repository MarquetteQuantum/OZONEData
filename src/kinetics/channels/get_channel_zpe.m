function zpe_j = get_channel_zpe(o2_molecule)
% Returns zero-point energy of a given channel
  if o2_molecule == "66"
    zpe_cm = 7.916382691754641e+02;
  elseif o2_molecule == "67"
    zpe_cm = 7.799050607081324e+02;
  elseif o2_molecule == "68"
    zpe_cm = 7.693708543295361e+02;
  elseif o2_molecule == "77"
    zpe_cm = 7.679904668774815e+02;
  elseif o2_molecule == "78"
    zpe_cm = 7.572885872707559e+02;
  elseif o2_molecule == "88"
    zpe_cm = 7.464315071358510e+02;
  end
  zpe_j = zpe_cm * get_j_per_cm();
end