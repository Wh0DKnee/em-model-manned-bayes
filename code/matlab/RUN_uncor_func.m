function []=RUN_uncor_func(up_ft, v_ft_s, dot_v_ft_ss, dot_h_ft_s, dot_psi_rad_s, psi_rad)

% Copyright 2008 - 2021, MIT Lincoln Laboratory
% SPDX-License-Identifier: BSD-2-Clause
%% Inputs
% ASCII model parameter file
parameters_filename = [getenv('AEM_DIR_BAYES') filesep 'model' filesep 'glider_v1p2.txt'];

% Number of sample / tracks
n_samples = 1;

% Duration of each sample / track
sample_time = 100;

% Random seed
rng('shuffle')
init_seed = rand*1000;


% convert units
%up_ft = 3500;
%v_ft_s = 100;
%dot_v_ft_ss = 1;
%dot_h_ft_s = 7;
%dot_psi_rad_s = 0.1;
%psi_rad = 3.141;

v_knots = v_ft_s / 1.68780972222222;
dot_v_knots_s = dot_v_ft_ss / 1.68780972222222;
dot_h_ft_min = dot_h_ft_s * 60;
dot_psi_deg_s = rad2deg(dot_psi_rad_s);


%% Instantiate object
mdl = UncorEncounterModel('parameters_filename', parameters_filename, 'up_ft', 10, 'v_knots', v_knots, ...
                            'dot_v_knots_s', dot_v_knots_s, 'dot_h_ft_min', dot_h_ft_min, 'dot_psi_deg_s', dot_psi_deg_s, ...
                            'psi_rad', psi_rad);

idxL = find(strcmp(mdl.labels_initial, '"L"'));
idxV = find(strcmp(mdl.labels_initial, '"v"'));
idxDV = find(strcmp(mdl.labels_initial, '"\dot v"'));
idxDH = find(strcmp(mdl.labels_initial, '"\dot h"'));
idxDPsi = find(strcmp(mdl.labels_initial, '"\dot \psi"'));

% Start distribution
start = cell(5, 1);


% calculate bin index from altitude
altitude_boundaries = mdl.boundaries(idxL);
start_idx_L = -1;
for i = 2:numel(altitude_boundaries{1,1})
    boundary = altitude_boundaries{1,1}(i,1);
    if up_ft < boundary
        start_idx_L = i-1;
        break
    end
end

if start_idx_L == -1
    msg = 'altitude index erroneous';
    error(msg);
end

start{idxL} = start_idx_L;

% calculate bin index from velocity
velocity_boundaries = mdl.boundaries(idxV);
start_idx_v = -1;
for i = 2:numel(velocity_boundaries{1,1})
    boundary = velocity_boundaries{1,1}(i,1);
    if v_knots < boundary
        start_idx_v = i-1;
        break
    end
end

if start_idx_v == -1
    msg = 'velocity index erroneous';
    error(msg);
end

start{idxV} = start_idx_v;

% calculate bin index from acceleration
dot_v_boundaries = mdl.boundaries(idxDV);
start_idx_dot_v = -1;
for i = 2:numel(dot_v_boundaries{1,1})
    boundary = dot_v_boundaries{1,1}(i,1);
    if dot_v_knots_s < boundary
        start_idx_dot_v = i-1;
        break
    end
end

if start_idx_dot_v == -1
    msg = 'acceleration index erroneous';
    error(msg);
end

start{idxDV} = start_idx_dot_v;

% calculate bin index from climb rate
dot_h_boundaries = mdl.boundaries(idxDH);
start_idx_dot_h = -1;
for i = 2:numel(dot_h_boundaries{1,1})
    boundary = dot_h_boundaries{1,1}(i,1);
    if dot_h_ft_min < boundary
        start_idx_dot_h = i-1;
        break
    end
end

if start_idx_dot_h == -1
    msg = 'climb rate index erroneous';
    error(msg);
end

start{idxDH} = start_idx_dot_h;

% calculate bin index from turn rate
dot_psi_boundaries = mdl.boundaries(idxDPsi);
start_idx_dot_psi = -1;
for i = 2:numel(dot_psi_boundaries{1,1})
    boundary = dot_psi_boundaries{1,1}(i,1);
    if dot_psi_deg_s < boundary
        start_idx_dot_psi = i-1;
        break
    end
end

if start_idx_dot_psi == -1
    msg = 'turn rate index erroneous';
    error(msg);
end

start{idxDPsi} = start_idx_dot_psi;

mdl.start = start;

%% Demonstrate how to generate samples
%[out_inits, out_events, out_samples, out_EME] = mdl.sample(n_samples, sample_time, 'seed', init_seed);

%% Demonstrate how to generate tracks
% Local relative Cartesian coordinate system
%out_results_NEU = mdl.track(n_samples, sample_time, 'initialSeed', init_seed, 'coordSys', 'NEU');

% Geodetic coordinate system
% lat0_deg = 44.25889; lon0_deg = -71.31887; % Lake of the Clouds, White Mountains, NH
% lat0_deg = 40.01031; lon0_deg = -105.22097; % Flatirons Golf Course, Boulder, CO
% lat0_deg = 46.96983; lon0_deg = -101.54661; % Bison Wind Project, ND
lat0_deg = 42.29959;
lon0_deg = -71.22220; % Exit 35C on I95, Massachusetts

out_results_geo2000 = mdl.track(n_samples, sample_time, 'initialSeed', init_seed, 'coordSys', 'neu', ...
                                'lat0_deg', lat0_deg, 'lon0_deg', lon0_deg, ...
                                'dofMaxRange_ft', 2000, 'isPlot', false);

%out_results_geo500 = mdl.track(n_samples, sample_time, 'initialSeed', init_seed, 'coordSys', 'geodetic', ...
%                               'lat0_deg', lat0_deg, 'lon0_deg', lon0_deg, ...
%                               'dofMaxRange_ft', 500, 'isPlot', true);

date = [datetime('now')];
datestring = datestr(date, 'dd_mmm_yyyy_HH_MM_SS_FFF');
filename = append(datestring, '.csv');
filepath = ['../../output/tracks/temp' filesep filename];
writetimetable(out_results_geo2000{1,1}, filepath);
end