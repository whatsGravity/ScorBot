function h = showTriadLabels(h,axisVal)
% SHOWTRIADLABELS shows the x, y, and z-direction labels of the specified
% triad object (a transform object with three orthogonal lines as 
% children).
%   SHOWTRIADLABELS(h) shows the axes labels associated with the transform 
%   object(s) specified in h. Multiple objects must be specified in an 
%   array.
%
%   SHOWTRIADLABELS(h,axisVal) only shows the axes labels specified by 
%   the array axisVal (1 for x, 2 for y, 3 for z).
%   
%   See also hgtransform triad hideTriad showTriad hideTriadLabels 
%
%   (c) M. Kutzer 13Aug2015, USNA

% Updates
%   11Sep2015 - Added axisVal parameter to enable showing specific labels

%% Check inputs 
if nargin < 2
    axisVal = 1:3;
end

%% Show labels
axs_lbls = {'X-Label','Y-Label','Z-Label'};
for i = 1:numel(h)
    kids = get(h(i),'Children');
    %for j = 1:numel(axs_lbls)
    for j = axisVal
        idx = find(~cellfun(@isempty, strfind(get(kids,'Tag'),axs_lbls{j})));
        for k = 1:numel(idx)
            if strcmpi( get(kids(idx(k)),'Type'), 'Text' )
                set(kids(idx(k)),'Visible','on');
            end
        end
    end
end