function pool = parallel_pool(num_workers)
% Creates local parallel pool with the specified number of workers if one does not exist already
  if isempty(gcp("nocreate"))
    pool = parpool("local", num_workers);
  end
end