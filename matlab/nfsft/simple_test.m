%SIMPLE_TEST Example program: Basic usage principles
% Computes the sums
% f(theta_d,phi_d) = sum_{k=0}^N sum_{n=-k}^k f_hat(k,n) Y_k^n(theta_d,phi_d)
% in terms of spherical harmonics Y_k^n of degree k on a set of arbitrary
% nodes (theta_d,phi_d) for d=1..M, in spherical coordinates 
% 0 <= phi_d <2*pi and 0 <= theta_d <= pi.

% Copyright (c) 2002, 2017 Jens Keiner, Stefan Kunis, Daniel Potts
%
% This program is free software; you can redistribute it and/or modify it under
% the terms of the GNU General Public License as published by the Free Software
% Foundation; either version 2 of the License, or (at your option) any later
% version.
%
% This program is distributed in the hope that it will be useful, but WITHOUT
% ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
% FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
% details.
%
% You should have received a copy of the GNU General Public License along with
% this program; if not, write to the Free Software Foundation, Inc., 51
% Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
%
fprintf('Number of threads: %d\n', nfsft_get_num_threads());

% maximum degree (bandwidth) of spherical harmonics expansions
N = 32;

% Gauss-Legendre interpolatory quadrature nodes for N. See gl.m
[X,W] = gl(N);

% number of nodes
M = size(X,2);

% Create plan of class NFSFT.
plan = nfsft(N,M,NFSFT_NORMALIZED);

% Set nodes. x = [phi; theta]
plan.x = X; 

% random Fourier coefficients
fh = f_hat(rand((N+1)*(N+1),1));

% Set Fourier coefficients.
plan.fhat = fh;

% show Fourier coefficient of degree 2 and order -1
fprintf('fh(2,-1) = %g\n',fh(2,-1))

% NFSFT transform
nfsft_trafo(plan);

% function values
f = plan.f;

% adjoint transform, using quadrature weights to recover Fourier coefficients
% the adjoint is only the inverse with the right quadrature weights W
plan.f = f.*W';
nfsft_adjoint(plan);

fh2 = plan.fhat;
fprintf('Error of reconstructed f_hat: %g\n',norm(fh2-fh));
