function pfunc = calc_part_func_o2_vib(zpe_j, kt_energy_j)
  pfunc = 1 / (1 - exp(-2 * zpe_j / kt_energy_j));
end