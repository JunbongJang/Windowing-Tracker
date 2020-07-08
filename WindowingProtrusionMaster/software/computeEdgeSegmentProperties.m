%CC = computeEdgeSegmentProperties(CC, img, theta, varargin) returns segment endpoints and intensities interpolated parallel to segments
%
% Inputs:
%         CC: connected components generated by bwconncomp  
%        img: input image
%      theta: orientation map generated by steerable filter
%
% Options:
%     InterpDist1: proximal distance parallel to segment (in pixels) at which 
%                  image is interpolated (default: 1)
%     InterpDist2: distal distance at which image is interpolated (default: 10)
%     InterpWidth: width of the interpolated band (default: 2)
%
% Outpus: 
%         CC: input CC augmented with list of segment endpoints and interpolated intensities
%
% Copyright (C) 2018, Danuser Lab - UTSouthwestern 
%
% This file is part of WindowingPackage.
% 
% WindowingPackage is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% WindowingPackage is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with WindowingPackage.  If not, see <http://www.gnu.org/licenses/>.
% 
% 

% Francois Aguet, 10/24/2012

function CC = computeEdgeSegmentProperties(CC, img, theta, varargin)

ip = inputParser;
ip.CaseSensitive = false;
ip.addParamValue('InterpDist1', 1);
ip.addParamValue('InterpDist2', 10);
ip.addParamValue('InterpWidth', 2);
ip.parse(varargin{:});
w = ip.Results.InterpWidth;

[ny,nx] = size(img);
% List of all pixel indexes
pixelIdxList = vertcat(CC.PixelIdxList{:});

% Segment mask and labels
segmentMask = zeros(ny,nx);
segmentMask(pixelIdxList) = 1;
labels = double(labelmatrix(CC));

% Identify endpoints
nn = (imfilter(segmentMask, ones(3), 'same')-1) .* segmentMask;
endpointIdxList = pixelIdxList(nn(pixelIdxList)==1);
% Each segment must have two endpoints
endpointIdxList = [endpointIdxList(1:2:end) endpointIdxList(2:2:end)];
% Order according to labels
tmp = NaN(CC.NumObjects,2);
tmp(labels(endpointIdxList(:,1)),:) = endpointIdxList;
endpointIdxList = tmp;

% Run geodesic distance transform to calculate pixel order for each segment
tmp = endpointIdxList(:,1);
D = bwdistgeodesic(logical(segmentMask), tmp(~isnan(tmp)));
D(isinf(D)) = 0;
pixelOrder = mat2cell(D(pixelIdxList)+1, CC.NumPixels, 1);
CC.EndpointIdx = mat2cell(endpointIdxList, ones(size(endpointIdxList,1),1), 2);
for i = 1:CC.NumObjects
    CC.PixelIdxList{i} = CC.PixelIdxList{i}(pixelOrder{i});
end

% Update list
pixelIdxList = vertcat(CC.PixelIdxList{:});

% Interpolate intensity on side of all segments
angleVect = theta(pixelIdxList);
cost = cos(angleVect);
sint = sin(angleVect);
[x,y] = meshgrid(1:nx,1:ny);
[yi, xi] = ind2sub([ny nx], pixelIdxList);

X0 = repmat(xi, [1 w]);
Y0 = repmat(yi, [1 w]);

% 'positive' side of segment (arbitrary)
dv = ip.Results.InterpDist1+(0:w-1);
X = X0 + cost*dv; % calculate as a [numel(xi) x w] matrix
Y = Y0 + sint*dv;
CC.pvalProx = mat2cell(interp2(x, y, img, X, Y), CC.NumPixels, w);
% 'negative' side
X = X0 - cost*dv;
Y = Y0 - sint*dv;
CC.nvalProx = mat2cell(interp2(x, y, img, X, Y), CC.NumPixels, w);

dv = ip.Results.InterpDist2+(0:w-1);
X = X0 + cost*dv;
Y = Y0 + sint*dv;
CC.pvalDist = mat2cell(interp2(x, y, img, X, Y), CC.NumPixels, w);
X = X0 - cost*dv;
Y = Y0 - sint*dv;
CC.nvalDist = mat2cell(interp2(x, y, img, X, Y), CC.NumPixels, w);





% old code, used iterative search to order segment pixels
% getNH = @(i) [i-ny-1 i-ny i-ny+1 i-1 i+1 i+ny-1 i+ny i+ny+1];
% 
% ns = CC.NumObjects;
% CC.rawAngle = cell(1,ns);
% CC.rval = cell(1,ns);
% CC.lval = cell(1,ns);
% for i = 1:ns
%     
%     np = numel(CC.PixelIdxList{i});
%     unorderedIdx = CC.PixelIdxList{i};
%     orderedIdx = zeros(np,1);
%     
%     % assign 1st endpoint (choice is arbitrary)
%     orderedIdx(1) = CC.EndpointIdx{i}(1);
%     unorderedIdx(unorderedIdx==orderedIdx(1)) = [];
%     
%     for k = 2:np
%         % local neighborhood indexes
%         hoodIdx = getNH(orderedIdx(k-1));
%         nextIdx = intersect(unorderedIdx, hoodIdx);
%         if isempty(nextIdx)
%             % get endpoints of unordered index
%             umask = zeros(dims);
%             umask(unorderedIdx) = 1;
%             %umask = double(bwmorph(umask, 'thin'));
%             nn = (imfilter(umask, ones(3), 'same')-1) .* umask;
%             endpointIdx = find(nn<2 & umask==1);
% 
%             if ~isempty(endpointIdx)
%                 [yi, xi] = ind2sub(dims, orderedIdx(orderedIdx~=0));
%                 X = [xi yi];
%                 [yi, xi] = ind2sub(dims, endpointIdx);
%                 x0 = [xi yi];
%                 [~,dist] = KDTreeClosestPoint(X, x0);
%                 nextIdx = endpointIdx(find(dist==min(dist),1,'first')); % start over at closest endpoint
%             else
%                 nextIdx = unorderedIdx(1);
%             end
%         end
%         unorderedIdx(unorderedIdx==nextIdx(1)) = [];
%         orderedIdx(k) = nextIdx(1);
%     end
%     CC.PixelIdxList{i} = orderedIdx;
%     CC.rawAngle{i} = theta(orderedIdx);
%     cost = cos(CC.rawAngle{i});
%     sint = sin(CC.rawAngle{i});
%     [yi, xi] = ind2sub(dims, CC.PixelIdxList{i});
%     X = [xi+cost xi+2*cost];
%     Y = [yi+sint yi+2*sint];
%     CC.rval{i} = interp2(x, y, img, X, Y);
%     X = [xi-cost xi-2*cost];
%     Y = [yi-sint yi-2*sint];
%     CC.lval{i} = interp2(x, y, img, X, Y);
%     
%     % running average - POTENTIAL BUG: angle wrapping in (-pi/2..pi/2]
%     %if np>w
%     %    CC.smoothAngle{i} = conv([CC.rawAngle{i}(b:-1:2) CC.rawAngle{i} CC.rawAngle{i}(end-1:-1:end-b+1)], ones(1,w)/w, 'valid');
%     %else
%     %    CC.smoothAngle{i} = CC.rawAngle{i};
%     %end
% end
