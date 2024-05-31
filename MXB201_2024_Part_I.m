%% MXB201 Project Part I

%% Initialisation
clear
load partI

[X,Y,num_dirs] = size(S);
assert(isequal(size(g), [num_dirs 3]));

% These arrays will be be filled in during the main loop below
MD  = nan(X, Y);    % mean diffusion
FA  = nan(X, Y);    % fractional anistropy
PDD = nan(X, Y, 3); % principal diffusion direction

% Removing any negative values in the data
S0 = abs(S0);
S = abs(S);

% creating matrix A
A = [g(:,1).^2  g(:,2).^2  g(:,3).^2  2.*g(:,1).*g(:,2)  2.*g(:,1).*g(:,3)  2.*g(:,2).*g(:,3)];


%% Compute the diffusion tensor for each pixel
for x = 1:X
    for y = 1:Y

        % If not within the mask, skip the pixel
        if ~mask(x, y), continue; end
        
        % Solving least squares problem
        B = log(S(x,y,:) / S0(x,y)) / (-b);  % taking the logarithm to find B
        B = squeeze(B);                      % B from 1x1x64 to 1x64 
        
        % Forming diffusion tensor
        
        % Returns 1x6 matrix of important parts of D 
        D_i = A \ B;       
        D_i = D_i';
        

        % Constructing 3x3 matrix D from D_i
        D = [D_i(1,1) D_i(1,4) D_i(1,5);
            D_i(1,4) D_i(1,2) D_i(1,6); 
            D_i(1,5) D_i(1,6) D_i(1,3)];

        % Finding eigenvalues of D
        Devals = eig(D);
        

        % Calculating MD, FA and PDD

        % MD
        sum_evalues = sum(Devals);  
        MD(x,y) = sum_evalues/3;
        
        % Fractional anistropy
        FA_sq = ((Devals(1)-Devals(2))^2 + (Devals(2)-Devals(3))^2 + (Devals(1)-Devals(3))^2 ) / (2*(Devals(1).^2 + Devals(2).^2 + Devals(3).^2));
        FA(x,y) = sqrt(FA_sq);          

        % Principal Diffusion Direction
        [D_e, throwaway] = eig(D);                  % extracting eigenvectors from D
        pv_index = find(Devals >= max(Devals), 1);  % finding the position of v1
        pv = abs(D_e(:, pv_index));                 % principal eigenvector v1

        LA = max(pv);               % finding longest axis
        scaled_pv = pv/LA;          % scaling v1 to get colour information

        PDD(x,y,:) = (scaled_pv*FA(x,y))';     % using FA to adjust brightness
     end
end

%% Plot mean diffusivity, fractional anisotropy and principal diffusion direction maps

% setting a threshold

threshold_mask = MD >= 0.1*max(MD, [], 'all');  % threshold of 10% of the max value
MD = MD.*threshold_mask;


% plotting the figures

figure, imshow(MD, [])
figure, imshow(FA, [])
figure, imshow(PDD, [])