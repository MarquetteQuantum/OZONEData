function energy_J = rigid_rotor_energy(J, I_kg_m2)
% returns energy (in J) of a rigid rotor corresponding to given J and I (moment of inertia)
  hbar = getvar('hbar_js');
  energy_J = J .* (J + 1) / (2*I_kg_m2) * hbar^2;
end