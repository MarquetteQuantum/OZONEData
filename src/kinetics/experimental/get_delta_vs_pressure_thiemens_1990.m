function data = get_delta_vs_pressure_thiemens_1990()
% Returns experimental data for delta (2nd col, in %) as a function of pressure (1st col, in bar)
% This data is taken from Thiemens MH, Jackson T. Pressure dependency for heavy isotope enhancement in ozone formation. 
% Geophys Res Lett. 1990;17(6):717-719. doi:10.1029/GL017i006p00717 (Table 1)
  data = [...
    0.8   8.98;
    1.5   7.41;
    4.1   5.3;
    6.8   4.2;
    8.5   3.12;
    8.8   3.25;
    10.2  2.97;
    12.2  2.46;
    16    2.01;
    21    1.49;
    30    1.2;
    35    1.04;
    45    0.62;
    54    0.11;
    61   -0.25;
    70   -0.31;
    78   -0.62;
    85   -0.33;
    87   -0.48;
  ];

  data(:, 1) = data(:, 1) * get_pa_per_atm() / get_pa_per_bar;
end