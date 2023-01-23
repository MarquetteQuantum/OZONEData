function data = get_delta_676_vs_pressure_thiemens_1988()
% Returns experimental data for delta (2nd col, in %) as a function of pressure (1st col, in bar) for ozone 676
% This data is taken from Thiemens MH, Jackson T. New experimental evidence for the mechanism for production of 
% isotopically heavy O3. Geophys Res Lett. 1988; 15(7):639-642. doi:10.1029/GL015i007p00639 (Table 1)
  data = [...
      8.0, 10.46;
     15.1, 10.65;
     33.3, 10.60;
     80.0,  9.92;
    160,    9.39;
    300,    8.90;
    445.8,  8.53;
    525,    8.27;
    600,    8.19;
    650,    8.53;
    700,    7.69;
    700,    7.80;
    742.8,  7.77;
    760,    7.52;
  ];

  data(:, 1) = data(:, 1) * get_pa_per_torr() / get_pa_per_bar();
end