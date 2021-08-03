%%

boardSize = [7,9];
tagSize = 16; % in millimeters
worldPoints = generateCheckerboardPoints(boardSize, tagSize);
worldPoints(:,2) = 80-worldPoints(:,2);

%%
serialnum = "20104308";

filename = "extrinsic_"+serialnum+".png";
imOrig = imread(filename);

tmpstruct = load("cameraParams_"+serialnum+".mat");
names = fieldnames(tmpstruct);
cameraParams = tmpstruct.(names{1});

%%

[im, newOrigin] = undistortImage(imOrig, cameraParams, 'OutputView', 'full');

% Set the properties of the calibration pattern.
tagArrangement = [3,4];
tagFamily = 'tag36h11';

% Get the pattern size from tagArrangement.
boardSize = tagArrangement*2 + 1;

% Initialize number of images and tags.
numTags = tagArrangement(1)*tagArrangement(2);

% Initialize number of corners in AprilTag pattern.
imagePoints = zeros(numTags*4,2);

% Get checkerboard corner indices from AprilTag corners.
checkerIdx = helperAprilTagToCheckerLocations(tagArrangement);

[tagIds, tagLocs] = readAprilTag(im, tagFamily);

% Accept images if all tags are detected.
if numel(tagIds) == numTags
    % Sort detected tags using ID values.
    [~, sortIdx] = sort(tagIds);
    tagLocs = tagLocs(:,:,sortIdx);

    % Reshape tag corner locations into a M-by-2 array.
    tagLocs = reshape(permute(tagLocs,[1,3,2]), [], 2);

    % Populate imagePoints using checkerboard corner indices.
    imagePoints(:,:) = tagLocs(checkerIdx(:),:);
else
    imagePoints(:,:) = [];
end

%%
imagePoints = [imagePoints(:,1) + newOrigin(1), imagePoints(:,2) + newOrigin(2)];

[rotationMatrix, translationVector] = extrinsics(imagePoints, worldPoints, cameraParams);

%%

[orientation, location] = extrinsicsToCameraPose(rotationMatrix, translationVector);

figure;
plotCamera('Location', location, 'Orientation', orientation, 'Size', 20);
hold on;
pcshow([worldPoints, zeros(size(worldPoints, 1), 1)], 'VerticalAxisDir', 'down', 'MarkerSize', 40);


%%

figure;
imshow(imOrig);

figure;
imshow(im);

%%

% imOrig = insertMarker(imOrig, imagePoints(:,:), 'o', 'Color', 'g', 'Size', 5);
% 
% figure;
% imshow(imOrig);


%%

K = cameraParams.IntrinsicMatrix;
RDistort = cameraParams.RadialDistortion;
TDistort = cameraParams.TangentialDistortion;
r = rotationMatrix;
t = translationVector;

save('cam0_params.mat', 'K', 'RDistort', 'TDistort', 'r', 't');