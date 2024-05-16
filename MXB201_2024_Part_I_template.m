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

%% Compute the diffusion tensor for each pixel
for x = 1:X
    for y = 1:Y

        % If not within the mask, skip the pixel
        if ~mask(x, y), continue; end

        % Handling bad data
        % Solving least squares problem
        % Forming diffusion tensor
        % Finding eigenvalues and eigenvectors
        % Calculating MD, FA and PDD

    end
end

%% Plot mean diffusivity, fractional anisotropy and principal diffusion direction maps
