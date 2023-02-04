function run_propagation_job(optional)
  arguments
    optional.o3_molecule = '666'
    optional.mode = "pressure"
    optional.path = "/mmfs1/home/3830gaydayi/kinetic_runs/"
  end

  j_per_cm = get_j_per_cm();
  m_per_a0 = get_m_per_a0();
  ref_pressure_per_m3 = 6.44e24;
  ch1_concs_per_m3 = [6.44e18, 6.44e20];
  base_time_s = linspace(0, 100e-9, 101);

  o3_molecule = optional.o3_molecule;
  Js = 0:64;
  Ks = 0:20;
  vib_syms_well = 0:1;
  energy_range_j = [-3000, 50] * j_per_cm;
  gamma_range_j = [1, 15] * j_per_cm;
  dE_down_j = -35 * j_per_cm;
  sigma_tran_m2 = 3200 * m_per_a0^2;

  if optional.mode == "pressure"
    temps_k = 298;
    M_concs_per_m3 = 6.44 * logspace(22, 28, 13);
  elseif optional.mode == "temperature"
    temps_k = 98:50:398;
    M_concs_per_m3 = 6.44e24;
  end

  if o3_molecule == "666"
    region_names = ["cov", "vdw"];
    require_convergence = [true, false];
    region_factors = [1, 1];
%     region_names = ["cov"];
%     require_convergence = [true];
%     region_factors = [1];
  else
    region_names = ["sym", "asym", "vdw_a", "vdw_b"];
    require_convergence = [true, true, false, false];
    region_factors = [1, 2, 2, 1];
%     region_names = ["sym", "asym"];
%     require_convergence = [true, true];
%     region_factors = [1, 2];
  end

  K_dependent_threshold = false;
  separate_concentrations = false;
  alpha0 = 0;
  formation_mult = 1;
  decay_mult = 1;

  closed_channel = "";
  localization_threshold = 1e-3;
  gamma_use_reference = false;
  new_db = true;
  save_time = true;

  converged_steps = 2;
  eval_step_s = nan; % Use time grid step size if nan

  remote_folder = optional.path;
  delim = "kinetic_runs/";
  job_name = get_item(strsplit(remote_folder, delim), 2);
  num_cores = 256;
  num_workers = num_cores - 1;

  c = parcluster;
  c.AdditionalProperties.QueueName = "batch";
  c.AdditionalProperties.WallTime = "unlimited";
  c.AdditionalProperties.AdditionalSubmitArgs = "-N 2-4 --use-min-nodes -J " + job_name;
  
  args = {ref_pressure_per_m3, base_time_s, ch1_concs_per_m3, o3_molecule, Js, Ks, vib_syms_well, energy_range_j, gamma_range_j, temps_k, M_concs_per_m3, ...
    dE_down_j, sigma_tran_m2, region_names, require_convergence, "K_dependent_threshold", K_dependent_threshold, ...
    "separate_concentrations", separate_concentrations, "alpha0", alpha0, "region_factors", region_factors, "formation_mult", formation_mult, ...
    "decay_mult", decay_mult "closed_channel", closed_channel, "localization_threshold", localization_threshold, "gamma_use_reference", gamma_use_reference, ...
    "new_db", new_db, "save_time", save_time, "converged_steps", converged_steps, "eval_step_s", eval_step_s};
  job = c.batch(@propagation_parallel_job, 0, args, CurrentFolder=remote_folder, AutoAddClientPath=false, Pool=num_workers);
  job.Name = job_name;
end