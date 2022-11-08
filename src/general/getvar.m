function res = getvar(name)
% Returns variable with specified name from base workspace
  res = evalin('base', name);
end