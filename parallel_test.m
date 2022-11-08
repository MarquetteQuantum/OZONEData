function t = parallel_test()
  % Load data
  x = rand(1000, 1000, 128);
  b = zeros(size(x, 3), 1);
  tic
  parfor i = 1:size(x, 3)
      b(i) = max(eig(x(:, :, i)));
  end
  t = toc;
end