%% example_all.m - Simple examples for affin1, affin2, bonusaffin
clear; clc; close all;

%% AFFIN1 - Fixed point at origin
fprintf('=== AFFIN1 ===\n');
fprintf('90 degree rotation (fixed point at origin)\n');
fprintf('Image of (0,1): (-1, 0)\n');
fprintf('Image of (1,0): (0, 1)\n\n');

A = affin1([-1; 0], [0; 1])

%% AFFIN2 - General affine transform
fprintf('\n=== AFFIN2 ===\n');
fprintf('Triangle P1(0,0), P2(1,0), P3(0,1)\n');
fprintf('Mapped to Q1(1,1), Q2(3,1), Q3(1,3)\n\n');

triangle1 = [0 1 0; 0 0 1];
triangle2 = [1 3 1; 1 1 3];

M = affin2(triangle1, triangle2)

%% BONUSAFFIN - Regular triangle from centroid and side points
fprintf('\n=== BONUSAFFIN (+1 bonus) ===\n');
fprintf('Centroid S(3, 3)\n');
fprintf('Point P(2, 3) on one side\n');
fprintf('Point Q(4, 2) on another side\n\n');

vertices = bonusaffin([3;3], [2;3], [4;2])

fprintf('\n=== DONE ===\n');
