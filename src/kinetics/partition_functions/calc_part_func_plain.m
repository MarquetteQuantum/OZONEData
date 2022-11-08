function [val, exp_factors] = calc_part_func_plain(energies, weights, ref_energy, kt_energy)
% calculates the value of partition function for a given set of parameters
% kt_energy is kT expressed in units consistent with the units of energy
% contribs contains sorted state indices and their contributions to part func
  if length(weights) == 1
    weights = repmat(weights, size(energies));
  end

  exp_factors = arrayfun(@(en, w) w * exp(-(en - ref_energy) / kt_energy), energies, weights);
  val = sum(exp_factors);
end