function data = get_eta_vs_temperature()
% Returns experimental data for eta (2nd col, wrt to 1) as a function of temperature (1st col, in K) for ozone 686
% This data is taken from Janssen C. Intramolecular isotope distribution in heavy ozone (16O18O16O and 16O16O18O). 
% Journal of Geophysical Research: Atmospheres. 2005;110(D8):1-9. doi:10.1029/2004JD005479 (Table 1)
  data = [...
      100, 1.91;
      120, 1.94;
      140, 1.97;
      160, 1.99;
      180, 2.01;
      200, 2.02;
      220, 2.04;
      240, 2.05;
      260, 2.07;
      280, 2.08;
      300, 2.09;
      320, 2.10;
      340, 2.11;
      360, 2.12;
      380, 2.13;
      400, 2.14;
    ];

  data(:, 2) = data(:, 2) / 2;
end