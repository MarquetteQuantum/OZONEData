function rgb = get_color(name)
% maps some color names to rgb codes
    if strcmp(name, 'black')
        rgb = [0, 0, 0] ./ 255;
    elseif strcmp(name, 'gray')
        rgb = [128, 128, 128] ./ 255;
    elseif strcmp(name, 'darkgreen')
        rgb = [0, 100, 0] ./ 255;
    elseif strcmp(name, 'green')
        rgb = [0, 128, 0] ./ 255;
    elseif strcmp(name, 'lightcoral')
        rgb = [240, 128, 128] ./ 255;
    elseif strcmp(name, 'lightgray')
        rgb = [211, 211, 211] ./ 255;
    elseif strcmp(name, 'lightskyblue')
        rgb = [135, 206, 250] ./ 255;
    elseif strcmp(name, 'lime')
        rgb = [0, 255, 0] ./ 255;
    elseif strcmp(name, 'limegreen')
        rgb = [50, 205, 50] ./ 255;
    elseif strcmp(name, 'silver')
        rgb = [192, 192, 192] ./ 255;
    end
end