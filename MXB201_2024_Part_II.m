% Template for MXB201 Project Part II.

%% Initialisation
clear
d = dir('faces/*.pgm');
N = length(d);
I = imread([d(1).folder, '/', d(1).name]);
[rows,cols] = size(I);
M = rows*cols;
A = zeros(M, N);  % big matrix, whose columns are the images

%% Read images as columns of the matrix
for j = 1:N
    I = imread([d(j).folder, '/', d(j).name]);
    A(:,j) = I(:);
end

%% Calculate and visualise mean face
mean_vector = mean(A,2); % return a column vector containing the mean of each row
uint_mean_face = uint8(mean_vector); % convert to uint8 for grayscale image
mean_face = reshape(uint_mean_face, rows, cols); % reshape into size 192*168 for visualising 
imshow(mean_face) % image of the mean face

%% Calculate mean-centred SVD
mean_d = double(mean_face); % convert back to double for matrix calculation
[U,Sigma,V] = svd(mean_d, 'econ'); % finds the reduced svd of the mean face matrix
decom = (norm(mean_d - U*Sigma*V')); % difference between A and UΣV' is basically zero
ortho = U'*U; % U now not being orthogonal still statisfies U'*U = I

%% Visualise first 20 eigenfaces

%% Calculate coordinate vectors

%% Demonstrate rudimentary moustache detector
