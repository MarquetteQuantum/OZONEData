function data = get_krec_vs_pressure_666_hippler()
% Returns experimental data for krec (2nd col, in m^6/s) as a function of pressure (1st col, in bar)
% The data is taken from Hippler H, Rahn R, Troe J. Temperature and pressure dependence of ozone formation rates in the range 1–1000 bar and 90–370 K. 
% J Chem Phys. 1990;93(9):6560-6569. doi:10.1063/1.458972 (Table 3).
  data = [...
       5, 1.2e20, 5.9e-14;
      10, 2.4e20, 1.2e-13;
      20, 4.8e20, 2.4e-13;
      50, 1.2e21, 5.4e-13;
      65, 1.5e21, 6.0e-13;
     100, 2.4e21, 7.6e-13;
     170, 3.5e21, 9.0e-13;
     200, 4.2e21, 1.0e-12;
     350, 6.8e21, 1.5e-12;
     500, 9.3e21, 2.0e-12;
    1000, 1.2e22, 3.9e-12;
  ];

  data(:, 2) = data(:, 3) ./ data(:, 2) * 1e-12;
  data(:, 3) = [];
end