%% example_all.m - Simple examples for newtonip, bsplinedraw, lsmapprox
clear; clc; close all;

%% NEWTONIP - Newton interpolation
fprintf('=== NEWTONIP ===\n');
fprintf('Nodes: [0, 1, 2, 3]\n');
fprintf('Values: [1, 2, 0, 4]\n\n');

x = [0, 1, 2, 3];
y = [1, 2, 0, 4];

coeffs = newtonip(x, y)

%% BSPLINEDRAW - B-spline basis functions
fprintf('\n=== BSPLINEDRAW ===\n');
fprintf('Drawing B-spline B_{0,3} (index=0, order=3, degree=2) on [0,1]\n\n');

bsplinedraw(0, 3)

%% LSMAPPROX - Least squares approximation
fprintf('\n=== LSMAPPROX ===\n');
fprintf('Approximating sin(x) with polynomial of degree 3\n');
fprintf('Nodes: 0, 0.5, 1, 1.5, 2, 2.5, 3\n\n');

x_lsm = 0:0.5:3;
y_lsm = sin(x_lsm);

p = lsmapprox(3, x_lsm, y_lsm)

fprintf('\n=== DONE ===\n');
