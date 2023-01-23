function data = get_delta_686_vs_pressure_morton()
% Returns experimental data for delta (2nd col, in %) as a function of pressure (1st col, in bar) for ozone 686
% This data is taken from Morton J, Barnes J, Schueler B, Mauersberger K. Laboratory studies of heavy ozone. 
% J Geophys Res. 1990; 95(D1):901. doi:10.1029/JD095iD01p00901 (Table 2)
  data = [...
       5.0, 12.5;
      12.5, 12.9;
      50.0, 12.3;
     160.0, 11.0;
     500.0,  9.4;
    1000.0,  8.4;
  ];

  data(:, 1) = data(:, 1) * get_pa_per_torr() / get_pa_per_bar();
end