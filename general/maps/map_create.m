function map = map_create(varargin)
% creates a map using given arguments
% in cell mode each key/value pair is provided in a cell
% in plain arg mode it is assumed that keys and values are alternating
    map = containers.Map();
    if nargin == 0
        return
    end
    if iscell(varargin{1}) % cell mode
        for i = 1:length(varargin)
            next_arg = varargin{i};
            map(next_arg{1}) = next_arg{2};
        end
    else % plain arg mode
        for i = 1:2:length(varargin)
            map(varargin{i}) = varargin{i+1};
        end
    end
end