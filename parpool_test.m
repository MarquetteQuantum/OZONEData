function parpool_test()
  parpool('local', 2);
  parfor i = 1:2
    disp('lol');
  end
end