%%

close all;
clear all;

%%

% Set the properties of the calibration pattern.
tagArrangement = [3,4];
tagFamily = 'tag36h11';

%%

% Create an imageDatastore object to store the captured images.
imdsCalib = imageDatastore("images/calibration_images_20181897/");

% Detect the calibration pattern from the images.
[imagePoints, boardSize] = helperDetectAprilTagCorners(imdsCalib, tagArrangement, tagFamily);

%%

% Generate world point coordinates for the pattern.
tagSize = 16; % in millimeters
worldPoints = generateCheckerboardPoints(boardSize, tagSize);

%%

% Determine the size of the images.
I = readimage(imdsCalib, 1);
imageSize = [size(I,1), size(I,2)];

% Estimate the camera parameters.
[params, validImages] = estimateCameraParameters(imagePoints, worldPoints, 'ImageSize', imageSize);

%%

% Display the reprojection errors.
figure
showReprojectionErrors(params)

figure
showExtrinsics(params)

%%

save('cameraParams_20181897.mat', 'params');

%%
% Read a calibration image.
I = readimage(imdsCalib, 3);

% Insert markers for the detected and reprojected points.
I = insertMarker(I, imagePoints(:,:,3), 'o', 'Color', 'g', 'Size', 5);
I = insertMarker(I, imagePoints(1,:,3), 'o', 'Color', 'y', 'Size', 5);
I = insertMarker(I, imagePoints(2,:,3), 'x', 'Color', 'y', 'Size', 5);
% I = insertMarker(I, params.ReprojectedPoints(:,:,10), 'x', 'Color', 'r', 'Size', 5);

% Display the image.
figure
imshow(I)