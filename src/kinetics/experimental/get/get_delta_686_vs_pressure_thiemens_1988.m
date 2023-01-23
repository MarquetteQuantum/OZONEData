function data = get_delta_686_vs_pressure_thiemens_1988()
% Returns experimental data for delta (2nd col, in %) as a function of pressure (1st col, in bar) for ozone 686
% This data is taken from Thiemens MH, Jackson T. New experimental evidence for the mechanism for production of 
% isotopically heavy O3. Geophys Res Lett. 1988; 15(7):639-642. doi:10.1029/GL015i007p00639 (Table 1)
  data = [...
      8.0, 12.63;
     15.1, 12.35;
     33.3, 12.11;
     80.0, 11.43;
    160,   10.36;
    300,    9.92;
    445.8,  9.90;
    525,    9.22;
    600,    9.60;
    650,    9.40;
    700,    8.85;
    700,    9.25;
    742.8,  9.11;
    760,    8.70;
  ];

  data(:, 1) = data(:, 1) * get_pa_per_torr() / get_pa_per_bar();
end