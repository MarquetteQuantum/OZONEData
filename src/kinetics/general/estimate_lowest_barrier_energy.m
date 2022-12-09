function energy_j = estimate_lowest_barrier_energy(barriers_prefix, o3_molecule, J, K)
% Interpolates barrier energy based on the data calculated by SpectrumSDT
  persistent interpolant_map

  if isempty(interpolant_map)
    interpolant_map = map_create();
  end
  interpolant = get_or_default(interpolant_map, o3_molecule, []);

  if isempty(interpolant)
    known_Js = [0:2:32, 36:4:64];
    known_Ks = 0:2:20;
    if o3_molecule == "666" || o3_molecule == "676" || o3_molecule == "686"
      lowest_pathway = "S";
    elseif o3_molecule == "868"
      lowest_pathway = "B";
    else
      error("Unknown molecule");
    end
    barrier_energies = dlmread(fullfile(barriers_prefix, o3_molecule, lowest_pathway, "barrier_energies.txt"));
    barrier_energies = barrier_energies * get_j_per_cm();
    
    [J_mesh, K_mesh] = meshgrid(known_Js, known_Ks);
    interp_data = horzcat(J_mesh(:), K_mesh(:), barrier_energies(:));
    interp_data(interp_data(:, 2) > interp_data(:, 1), :) = [];
    interpolant = scatteredInterpolant(interp_data(:, 1), interp_data(:, 2), interp_data(:, 3));
    interpolant_map(o3_molecule) = interpolant;
  end
  
  energy_j = interpolant(J, K);
end