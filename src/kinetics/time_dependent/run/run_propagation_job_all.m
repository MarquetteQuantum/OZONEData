function run_propagation_job_all()
  modes = ["pressure", "temperature"];
  o3_molecules = {'666', '676', '686'};
  path = "/mmfs1/home/3830gaydayi/kinetic_runs/666/total/no_vdw/gamma_min_1/gamma_max_15/sigma_3200/vdw_min_0.3/";
  for i = 1:length(modes)
    for j = 1:length(o3_molecules)
      next_path = path.replace("666", o3_molecules{j});
      next_path = next_path + modes(i);
      run_propagation_job(o3_molecule=o3_molecules{j}, mode=modes(i), path=next_path);
    end
  end
end