function pfunc = calc_part_func_o2_elec(temp_k)
% returns electronic partition function of O2 (+O?) system
% The expression is taken from:
% Hathorn, B. C.; Marcus, R. A. 
% An Intramolecular Theory of the Mass-Independent Isotope Effect for Ozone. 
% II. Numerical Implementation at Low Pressures Using a Loose Transition State. 
% J. Chem. Phys. 2000, 113 (21), 9497–9509. 
% https://doi.org/10.1063/1.480267
  j_per_k = getvar('j_per_k');
  j_per_cm_1 = getvar('j_per_cm_1');
  cm_1_per_k = j_per_k / j_per_cm_1;
  kt_energy_cm_1 = temp_k * cm_1_per_k;
  pfunc = 15 + 9*exp(-158.5 / kt_energy_cm_1) + 3*exp(-226.5 / kt_energy_cm_1);
end