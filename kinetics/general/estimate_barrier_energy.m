function energy_j = estimate_barrier_energy(o3_molecule, J, K)
% Interpolates barrier energy based on the data calculated by SpectrumSDT
  persistent interpolant_map

  if isempty(interpolant_map)
    interpolant_map = map_create();
  end
  interpolant = get_or_default(interpolant_map, o3_molecule, []);

  if isempty(interpolant)
    known_Js = [0:2:32, 36:4:64];
    known_Ks = 0:2:20;
    barrier_energies = dlmread(['data\barriers\', o3_molecule, '\S\barrier_energies.txt']) * getvar('j_per_cm_1');
    
    [J_mesh, K_mesh] = meshgrid(known_Js, known_Ks);
    interp_data = horzcat(J_mesh(:), K_mesh(:), barrier_energies(:));
    interp_data(interp_data(:, 2) > interp_data(:, 1), :) = [];
    interpolant = scatteredInterpolant(interp_data(:, 1), interp_data(:, 2), interp_data(:, 3));
    interpolant_map(o3_molecule) = interpolant;
  end
  
  energy_j = interpolant(J, K);
end