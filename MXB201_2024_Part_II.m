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
count = 0; % count of moustache
mous_Num = zeros([1 1000]); % array for moustache faces
display_matrix = repmat(I,[1 1 1000]); % matrix for display

% Adjust these two variables to change the condition of being a
% moustache face.

% the bright scale is 0 to 255, generally a difference of 10 on average is
% significant enough to show difference in brightness

x = 5; % how much darker the moustache area is compared to the mean face
        % increasing this variable filter out over-exposed faces

y = 8; % how much darker the moustache area is compared to the rest of the face
       % increasing this variable filter out faces that are darker then the
       % mean face on average, but don't necessarily have a moustache
       
% loop through all 1000 faces
for i = 1:1000
    % variables that help decide whether a face has moustache
    curr = double(reshape(A(:,i),[rows cols])); % current image in full size
    mous_area = curr(125:145, 30:135); % moustach area of the current image
    ms = size(mous_area);
    mous_size = ms(1,1)*ms(1,2); % how many element is in the moustache area
    mous_avg = sum(mous_area,'all')/mous_size;
    mous_mean_diff = sum((double(mean_d(125:145, 30:135))),'all')/mous_size - mous_avg;
    face_avg = sum(curr, "all")/M; % average brightness of the face
    mous_face_diff = face_avg - mous_avg;

    % Moustache should be darker then the mean face, so if avg_diff is
    % larger then x, the face is considered to have moustache
    
    % Moustache area should be darker then the rest of the face on average,
    % so if the moustache area is darker then the rest of the face on
    % average by y, the face is considered to have moustache
    
    % These are and conditions, as it is common for the area under the nose
    % to be darker then the rest of the face, and sometime the entire face
    % can be darker then the mean face due to light conditions and skin color
    
    if mous_mean_diff > x && mous_face_diff > y
        % a face that fits the requirement found, increment count and add to array
        count = count + 1;
        mous_Num(count) = i;
    end
end

% move information from the mous_Num array to the display_matrix
for i = 1:count
    display_matrix(:,:,i) = (uint8(reshape(A(:,mous_Num(i)),[rows cols])));
end

montage(display_matrix(:,:,1:count)) % show all image that meet conditions
