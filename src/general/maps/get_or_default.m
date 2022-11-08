function res = get_or_default(map, key, default)
    if ~isa(map, 'containers.Map') || ~isKey(map, key)
        res = default;
    else
        res = map(key);
    end
end