function f = create_common_plot_3d()
    f = create_common_plot();
    pbaspect([1, 1, 1]);
    rotate3d on
    set(gca, 'cameraviewanglemode', 'manual');
end