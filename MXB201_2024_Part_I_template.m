% Template for MXB201 Project Part I.

%% Initialisation
clear
load partI

[X,Y,num_dirs] = size(S);
assert(isequal(size(g), [num_dirs 3]));

% These arrays will be be filled in during the main loop below
MD  = nan(X, Y);    % mean diffusion
FA  = nan(X, Y);    % fractional anistropy
PDD = nan(X, Y, 3); % principal diffusion direction

% Any other initialisation needed here
% Removing any negative values in the data
S0 = max(S0, 0);
S = max(S, 0);
A = [g(:,1).^2  g(:,2).^2  g(:,3).^2  2.*g(:,1).*g(:,2)  2.*g(:,1).*g(:,3)  2.*g(:,2).*g(:,3)];
D = zeros(3,3);

%% Compute the diffusion tensor for each pixel
for x = 1:X
    for y = 1:Y

        % If not within the mask, skip the pixel
        if ~mask(x, y), continue; end
        
        % Solving least squares problem
        B = log(S(x,y,:)/S0(x,y));
        % B is 1x1x64 but should be 1x64 
        B = squeeze(B);        
        
        % Returns 1x6 matrix of important parts of D 
        D_i = B\A;
        
        

        
        % Forming diffusion tensor

        % Manually constructing D from important parts stored in D_i
        D(1,1) =  D_i(1,1); D(1,2) =  D_i(1,4); D(1,3) =  D_i(1,4);
        D(2,1) =  D_i(1,4); D(2,2) =  D_i(1,2); D(2,3) = D_i(1,6);
        D(3,1) =  D_i(1,5); D(3,2) =  D_i(1,6); D(3,3) =  D_i(1,3);

        
        % Finding eigenvalues and eigenvectors
        [D_e,D_v] = Eig(D)
        

        % Calculating MD, FA and PDD



    end
end

%% Plot mean diffusivity, fractional anisotropy and principal diffusion direction maps
