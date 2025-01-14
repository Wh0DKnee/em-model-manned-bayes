function [d, repeat, change] = hierarchical_discretize(x, cutpoints_coarse, cutpoints_fine, zero_bins, wrap)
    % Copyright 2008 - 2021, MIT Lincoln Laboratory
    % SPDX-License-Identifier: BSD-2-Clause
    % EXAMPLE:
    % cutpoints_coarse = 80:20:160;
    % cutpoints_fine = hierarchical_cutpoints(cutpoints_coarse, [60 180], 4);
    % x = [65 100 100 100 100 72 71 78];
    % [d, repeat, change] = hierarchical_discretize(x, cutpoints_coarse, cutpoints_fine);

    if nargin < 5
        wrap = 0;
        if nargin < 4
            zero_bins = [];
        end
    end

    if isempty(cutpoints_fine)
        d = discretize_bayes(x, cutpoints_coarse);
        repeat = 0;
        change = 0;
        return
    end

    % COMPUTE COARSE AND FINE DISCRETIZATIONS
    d = discretize_bayes(x, cutpoints_coarse);

    if wrap
        % d = mod(d, length(cutpoints_coarse));
        d = 1 + mod(d - 1, length(cutpoints_coarse));
    end

    f = zeros(size(x)); % fine discretization
    n = numel(x);
    repeat = 0;
    change = 0;
    for ii = 1:n
        if x(ii) >= cutpoints_fine{d(ii)}(end)
            f(ii) = numel(cutpoints_fine{d(ii)}) + 1;
        else
            f(ii) = find(x(ii) < cutpoints_fine{d(ii)}, 1);
        end

        if ii > 1 && ~any(zero_bins == d(ii)) && d(ii - 1) == d(ii)
            if f(ii - 1) == f(ii)
                repeat = repeat + 1;
            else
                change = change + 1;
            end
        end
    end
