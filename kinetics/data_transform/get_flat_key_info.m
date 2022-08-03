function [mol, J, Ks, p, K0_sym, is_half_integer] = get_flat_key_info(key)
% Extracts global calculation properties from key.
  key_tokens = split(key, '\');
  elem_prefixes = {'mol', 'J', 'K', 'p', 'sym', 'half_integers'};
  presence_only = [false, false, false, false, false, true];
  elem_values = cell(size(elem_prefixes));
  
  for i = 1:length(elem_prefixes)
    prefix = elem_prefixes{i};
    prefix_ind = find(cellfun(@(token) startsWith(token, prefix), key_tokens), 1);
    if isempty(prefix_ind)
      elem_values{i} = iif(presence_only(i), false, -1);
    else
      if presence_only(i)
        elem_values{i} = true;
      else
        element_tokens = split(key_tokens{prefix_ind}, '_');
        value_tokens = split(element_tokens{2}, '..');
        if prefix == "mol"
          elem_values{i} = value_tokens{1};
        elseif length(value_tokens) == 1
          elem_values{i} = str2double(value_tokens{1});
        else
          elem_values{i} = str2double(value_tokens{1}) : str2double(value_tokens{2});
        end
      end
    end
  end
  
  [mol, J, Ks, p, K0_sym, is_half_integer] = elem_values{:};
end