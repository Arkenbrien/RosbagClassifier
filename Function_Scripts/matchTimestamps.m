function [indexes, fromTimes, toTimes, diffs] = matchTimestamps(matchFrom, matchTo, maxDelta, matchFromOffset)
%MATCHTIMESTAMPS Match ROS timestamps from matchFrom into matchTo where 
%each of these is a cell array of ROS messages. This
%returns an array the same size as matchFrom which contains the
%corresponding index in matchTo for each message. 
%   Take two cell arrays of ROS messages with headers, and match the 
% timestamps from the first to the nearest message in the second. If the
% difference is greater than maxDelta then the index is returned as -1.
% The messages do not need to be in timestamp order.
% Requires the ROS toolbox
% INPUT: 
%   matchFrom - an Nx1 cell array of some ROS message type with a Header
%   field in each one. So that matchFrom{1}.Header.Stamp exists. 
%   matchTo - an Mx1 cell array of some ROS message type with a Header
%   field in each one. So that matchTo{1}.Header.Stamp exists. 
%   maxDelta (optional) - the maximum difference in seconds to match two messages
%   between. This is Inf by default.
%   matchFromOffset (optional) - an offset in seconds to apply to all
%   messages in 'matchFrom', in case they came from different clock sources
% OUTPUT:
%   indexes - an Nx1 matrix which maps each message in 'matchFrom'
%   to the nearest message in 'matchTo'. So the nearest message to
%   matchFrom{x} is matchTo{indexes(x)}
%   fromTimes - an Nx1 matrix of the matchFrom message times in seconds
%   toTimes - an Mx1 matrix of the matchTo message times in seconds
%   diffs - an Nx1 matrix of the match messages time differences
%   Published 2019 by https://github.com/jaspereb
%Defaults
if(~exist('maxDelta','var'))
    maxDelta = Inf;
end
if(~exist('matchFromOffset','var'))
    matchFromOffset = 0;
end
fromTimes = zeros(size(matchFrom,1),1);
toTimes = zeros(size(matchTo,1),1);
%Read both times into arrays
for n = 1:size(matchFrom,1)
   fromTimes(n) = double(matchFrom{n}.Header.Stamp.Sec) + (10^-9)*double(matchFrom{n}.Header.Stamp.Nsec);
end
for n = 1:size(matchTo,1)
   toTimes(n) = double(matchTo{n}.Header.Stamp.Sec) + (10^-9)*double(matchTo{n}.Header.Stamp.Nsec);
end
%For each element in the 'from' array, find the closest in the 'to' array
diffs = zeros(size(fromTimes,1),1);
indexes = zeros(size(fromTimes,1),1);
for n = 1:size(fromTimes,1)
   diff = toTimes - (fromTimes(n) + matchFromOffset);
   [diffs(n), idx] = min(abs(diff));
   if(diffs(n) < maxDelta)
       indexes(n) = idx;
   else
       indexes(n) = -1;
   end
   
end
end