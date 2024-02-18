clear
clc

%load QUBO matrix A
A = load('./matrix_A.mat');
A = A.A;

%lossless compression of A to Q
%input_x / input_y: the row / column input vector of the compressed matrix Q 
[input_x,input_y,Q,chipsize] = matrixcut(A);
