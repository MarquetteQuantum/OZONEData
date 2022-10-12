function data = get_delta_vs_pressure_morton()
% Returns experimental data for delta (2nd col, in %) as a function of pressure (1st col, in bar)
% This data is taken from Morton J, Barnes J, Schueler B, Mauersberger K. Laboratory studies of heavy ozone. 
% J Geophys Res. 1990; 95(D1):901. doi:10.1029/JD095iD01p00901 (Table 2)
  data = [...
    5    12.5;
    12.5 12.9;
    50   12.3;
    160  11;
    500  9.4;
    1000 8.4;
  ];

  data(:, 1) = data(:, 1) * get_pa_per_torr() / get_pa_per_bar();
end