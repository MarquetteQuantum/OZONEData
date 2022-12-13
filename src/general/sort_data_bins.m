function bin_data = sort_data_bins(xs, edges, contribs)
% Splits data into bins specified by *edges* according to *xs*, adding contributions from *contribs*.
% If *contribs* are not specified, contribution of each element is assumed to be 1.
  if nargin < nargin(@sort_data_bins)
    contribs = ones(size(xs));
  end
  bin_data = zeros(1, length(edges)-1);
  for i = 1:length(bin_data)
    bin_data(i) = sum(contribs(xs >= edges(i) & xs < edges(i+1)));
  end
end