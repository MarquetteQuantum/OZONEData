function pa_per_torr = get_pa_per_torr()
% Returns the number of Pascal per torr
% See https://en.wikipedia.org/wiki/Torr for definition
  pa_per_torr = get_pa_per_atm() / 760;
end