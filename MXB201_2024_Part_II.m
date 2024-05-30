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
mean_face = reshape(uint_mean_face, rows, cols); % reshape for visualising 
imshow(mean_face) % show image

%% Calculate mean-centred SVD
format long
mean_d = double(mean_face); % convert to double
[U,Sigma,V] = svd(mean_d, 'econ'); % reduced svd of the mean face matrix
decom = (norm(mean_d - U*Sigma*V')); % difference is near zero
ortho = U'*U; % still statisfies U'*U = I

%% Visualise first 20 eigenfaces
N = 20; % for 20 eigenfaces

B = zeros(32256,N); % empty matrix to hold face values

for i = 1:N
    face = A(:,1+((i-1)*29):29+((i-1)*29)); % pull each person's face
    mean_face = mean(face,2); % return mean face
    uint_mean_face = uint8(mean_face); % covert to uint8
    B(:,i) = uint_mean_face; % assign value to matrix B
end

first_N = double(B); % convert the uint8 matrix to double
first_N = first_N - mean_vector; % subtract the mean face for difference

[U2,Sigma2,V2] = svd(first_N, 'econ'); % mean-centered SVD 
Sigma2 = diag(Sigma2); % singular values vector
eig_face = U2*Sigma2(1)*V2'; % eigenface vector
eig_face = uint8(eig_face); % convert to uint8

faceArray = repmat(I, [1 1 N]); % create an array of 192x168xN to represent the first N eigenfaces
for i = 1:N
    faceArray(:,:,i) = reshape(eig_face(:,i),[rows cols]); % replace empty column with eigenface and reshape...
    % into size 192*168 for visualising purpose
end
montage(faceArray) % show the first 20 eigenfaces in the filled out array

%% Calculate coordinate vectors
format short % for easier view of vectors
facediff = diag(Sigma2); % singular values from the SVD 

c = facediff(1:N, 1:N) * V(1, 1:N)';  % the coordinate vector for the first 20 eigenfaces

%% Demonstrate rudimentary moustache detector

