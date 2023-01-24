function data = get_krec_vs_pressure_666_cobos_293K()
% Returns experimental data for krec (2nd col, in m^6/s) as a function of pressure (1st col, in bar)
% The data is taken from de Cobos AEC, Troe J. High-pressure range of the recombination O + O2 → O3. 
% Int J Chem Kinet. 1984;16(12):1519-1529. doi:10.1002/KIN.550161206 (Table 1b)
  data = [...
     13,  3.2e20,  1.7e-13;
     26,  6.6e20,  3.5e-13;
     52, 13e20,    4.7e-13;
    108, 27e20,    7.0e-13;
    204, 51e20,   11e-13;
  ];

  data(:, 1) = data(:, 1) * get_pa_per_atm() / get_pa_per_bar();
  data(:, 2) = data(:, 3) ./ data(:, 2) * 1e-12;
  data(:, 3) = [];
end