function run_propagation_job()
  j_per_cm = get_j_per_cm();
  m_per_a0 = get_m_per_a0();
  ref_pressure_per_m3 = 6.44e24;
  base_time_s = linspace(0, 1000e-9, 1001);
  ch1_concs_per_m3 = [6.44e18, 6.44e20];

  o3_molecules = {'666'};
  Js = [0:32, 36:4:64];
  Ks = 0:20;
  vib_syms_well = 0:1;
  energy_range_j = [-3000, 300] * j_per_cm;
  gamma_range_j = [1, 2.5] * j_per_cm;

  temp_k = 298;
  M_concs_per_m3 = 6.44 * logspace(23, 28, 6);
  dE_j = [-43.13, nan] * j_per_cm;
  dE_j(2) = get_dE_up(dE_j(1), temp_k);
  sigma0_tran_m2 = 1350 * m_per_a0^2;
  region_names = ["cov"];
  require_convergence = [true];

  K_dependent_threshold = false;
  separate_concentrations = false;
  alpha0 = 1;
  region_factors = [1];
  formation_mult = 1;
  decay_mult = 1/5;

  closed_channel = "";
  localization_threshold = 1e-3;

  remote_prefix = "/mmfs1/home/3830gaydayi/kinetic_runs/";
  job_name = "666/total/no_vdw/gamma_mult_10/";
  remote_folder = remote_prefix + job_name;
  num_cores = 124;
  num_workers = num_cores - 1;

  c = parcluster;
  c.AdditionalProperties.QueueName = "batch";
  c.AdditionalProperties.WallTime = "unlimited";
  c.AdditionalProperties.AdditionalSubmitArgs = "-N 1 -J " + job_name;
  
  args = {ref_pressure_per_m3, base_time_s, ch1_concs_per_m3, o3_molecules, Js, Ks, vib_syms_well, energy_range_j, gamma_range_j, temp_k, M_concs_per_m3, ...
    dE_j, sigma0_tran_m2, region_names, require_convergence, "K_dependent_threshold", K_dependent_threshold, ...
    "separate_concentrations", separate_concentrations, "alpha0", alpha0, "region_factors", region_factors, "closed_channel", closed_channel, ...
    "localization_threshold", localization_threshold, "formation_mult", formation_mult, "decay_mult", decay_mult};
  job = c.batch(@propagation_parallel_job, 0, args, CurrentFolder=remote_folder, AutoAddClientPath=false, Pool=num_workers);
  job.Name = job_name;
end