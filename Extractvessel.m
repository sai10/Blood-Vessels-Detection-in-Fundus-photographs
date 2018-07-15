%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function binaryImage = Extractvessel(binaryImage, numberToExtract,labeledImage,blobMeasurements)

% Get all the blob properties.
% [labeledImage, numberOfBlobs] = bwlabel(binaryImage);
% blobMeasurements = regionprops(labeledImage, 'area');
% Get all the areas
allAreas = [blobMeasurements.Area];
if numberToExtract > length(allAreas);
    %Limit the number they can get to the number that are available.
    numberToExtract = length(allAreas);
end
if numberToExtract > 0
%     For positive numbers, sort in order of largest to smallest.
%     Sort them.
    [sortedAreas, sortIndexes] = sort(allAreas, 'descend');
elseif numberToExtract < 0
%     For negative numbers, sort in order of smallest to largest.
%     Sort them.
    [sortedAreas, sortIndexes] = sort(allAreas, 'ascend');
%    Need to negate numberToExtract so we can use it in sortIndexes later.
    numberToExtract = -numberToExtract;
else
   % numberToExtract = 0.  %Shouldn't happen.  Return no blobs.
    binaryImage = false(size(binaryImage));
    return;
end
%Extract the "numberToExtract" largest blob(a)s using ismember().
biggestBlob = ismember(labeledImage, sortIndexes(1:numberToExtract));
%Convert from integer labeled image into binary (logical) image.
binaryImage = biggestBlob > 0;
end