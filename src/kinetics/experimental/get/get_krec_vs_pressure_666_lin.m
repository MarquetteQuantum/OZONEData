function data = get_krec_vs_pressure_666_lin()
% Returns experimental data for krec (2nd col, in m^6/s) as a function of pressure (1st col, in bar)
% The data is taken from Lin CL, Leu MT. Temperature and third-body dependence of the rate constant for the reaction O + O2 + M → O3 + M. 
% Int J Chem Kinet. 1982;14(4):417-434. doi:10.1002/KIN.550140408 (Table 2)
  data = [...
     25, 0.51e-15;
     50, 1.02e-15;
    100, 2.12e-15;
    200, 3.72e-15;
    400, 7.57e-15;
  ];
  temp_k = 298;
  M_conc_per_m3 = data(:, 1) * get_pa_per_torr() / get_j_per_k() / temp_k;

  data(:, 1) = data(:, 1) * get_pa_per_torr() / get_pa_per_bar();
  data(:, 2) = data(:, 2) * 1e-6 ./ M_conc_per_m3;
end