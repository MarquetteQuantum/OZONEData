function data = get_krec_vs_pressure_666_janssen()
% Returns experimental data for krec (2nd col, in m^6/s) as a function of pressure (1st col, in bar)
% The data is taken from Janssen C, Guenther J, Mauersberger K, Krankowsky D. Kinetic origin of the ozone isotope effect: a critical analysis of enrichments 
% and rate coefficients. 
% Physical Chemistry Chemical Physics. 2001;3(21):4718-4721. doi:10.1039/b107171h (Table 1)
  data = [267e2, 6.0e-34];

  data(:, 1) = data(:, 1) / get_pa_per_bar();
  data(:, 2) = data(:, 2) * 1e-12;
end