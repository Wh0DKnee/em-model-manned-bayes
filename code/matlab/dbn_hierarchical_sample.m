function [initial, events] = dbn_hierarchical_sample(parms, dirichlet_initial, dirichlet_transition, sample_time, dediscretize_parameters, zero_bins, resample_rates, start, start_values)
    % Copyright 2008 - 2021, MIT Lincoln Laboratory
    % SPDX-License-Identifier: BSD-2-Clause
    % DBN_HIERARCHICAL_SAMPLE Calls dbn_sample() to generate samples from a
    % dynamic Bayesian network. Variables are sampled discretely in bins and
    % then dediscretized.
    % See also dbn_sample, resample_events, dediscretize

    if nargin < 8
        [initial, events] = dbn_sample(parms, dirichlet_initial, dirichlet_transition, sample_time);
    else
        [initial, events] = dbn_sample(parms, dirichlet_initial, dirichlet_transition, sample_time, start);
    end

    if isempty(events)
        events = [sample_time 0 0];
    else
        events = [events; sample_time - sum(events(:, 1)) 0 0];
    end

    % disp('Within-bin resampling');
    events = resample_events(initial, events, resample_rates);

    % disp('Dediscretize')
    if ~isempty(start_values) && start_values{1}
        idxL = find(strcmp(parms.labels_initial, '"L"'));
        idxV = find(strcmp(parms.labels_initial, '"v"'));
        idxDV = find(strcmp(parms.labels_initial, '"\dot v"'));
        idxDH = find(strcmp(parms.labels_initial, '"\dot h"'));
        idxDPsi = find(strcmp(parms.labels_initial, '"\dot \psi"'));
        initial(idxL) = start_values{2};
        initial(idxV) = start_values{3};
        initial(idxDV) = start_values{4};
        initial(idxDH) = start_values{5};
        initial(idxDPsi) = start_values{6};
    else
        for ii = 1:numel(initial)
            if length(dediscretize_parameters{ii}) == (size(parms.N_initial{ii}, 1) - 2)
    
            else
                initial(ii) = dediscretize(initial(ii), dediscretize_parameters{ii}, zero_bins{ii});
            end
        end
    end

    if ~isempty(events)
        for ii = 1:(size(events, 1) - 1)
            events(ii, 3) = dediscretize(events(ii, 3), dediscretize_parameters{events(ii, 2)}, zero_bins{events(ii, 2)});
        end
    end
