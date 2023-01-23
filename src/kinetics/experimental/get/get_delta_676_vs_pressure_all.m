function data = get_delta_676_vs_pressure_all()
% Returns all experimental data for delta (2nd col, in %) as a function of pressure (1st col, in bar) for ozone 676
  data_morton = get_delta_676_vs_pressure_morton();
  data_thiemens_1988 = get_delta_676_vs_pressure_thiemens_1988();
  data_thiemens_1990 = get_delta_676_vs_pressure_thiemens_1990();
  data = sortrows([data_morton; data_thiemens_1988; data_thiemens_1990]);
end