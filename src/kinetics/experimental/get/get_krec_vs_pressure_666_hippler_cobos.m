function data = get_krec_vs_pressure_666_hippler_cobos()
% Returns experimental data for krec (2nd col, in m^6/s) as a function of pressure (1st col, in bar)
% The data is taken from de Cobos AEC, Troe J. High-pressure range of the recombination O + O2 → O3. 
% Int J Chem Kinet. 1984;16(12):1519-1529. doi:10.1002/KIN.550161206 (Table 2)
  data = [...
      1,  0.25e20,  0.17e-13;
      3,  0.75e20,  0.45e-13;
      4,  1.0e20,   0.57e-13;
      6,  1.5e20,   0.87e-13;
     10,  2.5e20,   1.35e-13;
     30,  7.5e20,   3.7e-13;
     60, 15e20,     5.8e-13;
    100, 25e20,     8.2e-13;
    150, 38e20,    10.0e-13;
    200, 50e20,    10.2e-13;
  ];

  data(:, 1) = data(:, 1) * get_pa_per_atm() / get_pa_per_bar();
  data(:, 2) = data(:, 3) ./ data(:, 2) * 1e-12;
  data(:, 3) = [];
end