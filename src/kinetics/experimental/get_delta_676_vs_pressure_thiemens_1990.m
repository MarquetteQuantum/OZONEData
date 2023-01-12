function data = get_delta_676_vs_pressure_thiemens_1990()
% Returns experimental data for delta (2nd col, in %) as a function of pressure (1st col, in bar) for ozone 676
% This data is taken from Thiemens MH, Jackson T. Pressure dependency for heavy isotope enhancement in ozone formation. 
% Geophys Res Lett. 1990;17(6):717-719. doi:10.1029/GL017i006p00717 (Table 1)
  data = [...
     0.8, 8.35;
     1.5, 6.83;
     4.1, 5.01;
     6.8, 3.99;
     8.5, 3.27;
     8.8, 3.35;
    10.2, 2.88;
    12.2, 2.69;
    16,   2.12;
    21,   1.70;
    30,   1.20;
    35,   1.05;
    45,   0.66;
    54,   0.35;
    61,   0.90;
    70,   0.0;
    78,  -0.17;
    85,  -0.12;
    87,  -0.21;
  ];

  data(:, 1) = data(:, 1) * get_pa_per_atm() / get_pa_per_bar;
end