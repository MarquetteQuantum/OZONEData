function data = get_delta_676_vs_pressure_morton()
% Returns experimental data for delta (2nd col, in %) as a function of pressure (1st col, in bar) for ozone 676
% This data is taken from Morton J, Barnes J, Schueler B, Mauersberger K. Laboratory studies of heavy ozone. 
% J Geophys Res. 1990; 95(D1):901. doi:10.1029/JD095iD01p00901 (Table 2)
  data = [...
       5.0, 11.2;
      12.5, 11.2;
      50.0, 10.4;
     160.0, 10.3;
     500.0,  8.7;
    1000.0,  7.5;
  ];

  data(:, 1) = data(:, 1) * get_pa_per_torr() / get_pa_per_bar();
end