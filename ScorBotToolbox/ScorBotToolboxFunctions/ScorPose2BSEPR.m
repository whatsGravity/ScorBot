function BSEPR = ScorPose2BSEPR(varargin)
% SCORPOSE2BSEPR calculate the the BSEPR joint parameters given the forward
% kinematics of the ScorBot.
%
% NOTE: "ScorIkin.m" is an alternate name for "ScorPose2BSEPR.m".
%
%   BSEPR = SCORPOSE2BSEPR(H) calculates 5-element BSEPR joint angle vector
%   (in radians) given a 4x4 homogeneous transformation representing the 
%   end-effector pose of ScorBot. The "elbow-up" solution with the smallest
%   shoulder angle above 0 is returned. If no solution exists, an empty set
%   is returned.
%       BSEPR - 5-element joint vector in radians
%           BSEPR(1) - base joint angle in radians
%           BSEPR(2) - shoulder joint angle in radians
%           BSEPR(3) - elbow joint angle in radians
%           BSEPR(4) - wrist pitch angle in radians
%           BSEPR(5) - wrist roll angle in radians
%       H - 4x4 homogeneous transformation with distance parameters
%           specified in millimeters
%
%   BSEPRs = SCORPOSE2BSEPR(H,'AllSolutions') calculates all possible 
%   5-element BSEPR joint angle vectors (in radians) given a 4x4 
%   homogeneous transformation representing the end-effector pose of 
%   ScorBot. If no solution exists, an empty set is returned.
%       BSEPRs - Nx5 (0 <= N <= 4) element array containing viable 
%       solutions
%           BSEPRs(1,:) - BSEPR solution 1
%           BSEPRs(2,:) - BSEPR solution 2
%           ...
%           BSEPRs(N,:) - BSEPR solution N
%
%   See also ScorIkin ScorBSEPR2Pose ScorFkin ScorDHtable DH DHtableToFkin
%
%   (c) M. Kutzer, 13Aug2015, USNA

H = varargin{1};

%% Get DH parameters
DHtable = ScorDHtable;
%theta = DHtable(:,1);
d = DHtable(:,2);
a = DHtable(:,3);
alpha = DHtable(:,4);

%% Calculate base angle candidates
b(1,1) = atan2(H(2,4), H(1,4));
% alternate base joint angle in radians
if b(1) > 0
    b(2,1) = b(1) - pi;
else
    b(2,1) = b(1) + pi;
end

%% Get forward kinematics in the manipulator plane and calculate candidate 
% solutions for each base angle
for i = 1:numel(b)
    H_inPlane = Rx(-alpha(1))*Tx(-a(1))*Tz(-d(1))*Rz(-b(i))*H*...
                Rx(-alpha(end))*Tx(-a(end))*Tz(-d(end));
    % Calculate wrist roll angle
    r(i,1) = atan2(H_inPlane(3,1),H_inPlane(3,2));
    % Calculate distance between shoulder and wrist
    d = norm(H_inPlane(1:2,4));
    if d > ( abs(a(2)) + abs(a(3)) )
        % No valid solution exists for this base joint angle
        s(i,1) = NaN;
        s(i,2) = NaN;
        e(i,1) = NaN;
        e(i,2) = NaN;
        p(i,1) = NaN;
        p(i,2) = NaN;
    else
        % Calculate rise angle of wrist relative to shoulder
        rise = atan2(H_inPlane(2,4),H_inPlane(1,4));
        % Calculate interior angles of Link(a2), Link(a3), d triangle
        %alpha2 = acos( (a(3)^2 + d^2 - a(1)^2)/(2*a(3)*d) );
        alpha3 = acos( (a(2)^2 + d^2 - a(3)^2)/(2*a(2)*d) );
        delta  = acos( (a(2)^2 + a(3)^2 - d^2)/(2*a(2)*a(3)) );
        % Calculate shoulder angles
        s(i,1) = rise + alpha3; % "Elbow up"
        s(i,2) = rise - alpha3; % "Elbow down"
        % Calculate elbow angles
        e(i,1) = delta - pi; % "Elbow up"
        e(i,2) = pi - delta; % "Elbow down"
        % Calculate XYZPR pitch angle
        pitch = atan2(H_inPlane(2,3),H_inPlane(1,3));
        % Calculate wrist pitch angle
        p(i,1) = pitch - e(i,1) - s(i,1);
        p(i,2) = pitch - e(i,2) - s(i,2);
    end
end

%% Account for repeated base angle and wrist roll solutions
b = repmat(b,1,2);
r = repmat(r,1,2);

%% Reshape and output
b = reshape(b,[],1);
s = reshape(s,[],1);
e = reshape(e,[],1);
p = reshape(p,[],1);
r = reshape(r,[],1);

BSEPR = [b,s,e,p,r];

% wrap joint angles to [-pi,pi]
BSEPR = wrapToPi(BSEPR);

% remove NaN solutions
[i,~] = find(isnan(BSEPR));
BSEPR(unique(i),:) = [];

% remove incorrect solutions
idx = [];
ZERO = 1e-3;
for i = 1:size(BSEPR,1)
    H_star = ScorBSEPR2Pose(BSEPR(i,:));
    if ~isZero(H-H_star,ZERO)
        idx(end+1) = i;
    end
end
BSEPR(idx,:) = [];

%% Package output
if ~isempty(BSEPR)
    if nargin == 1
        % TODO - select the solution described in help documentation
        % Output first BSEPR solution
        BSEPR = BSEPR(1,:);
    else
        switch lower(varargin{2})
            case 'allsolutions'
                % Output all BSEPR solutions
            case 'firstsolution'
                % Output first BSEPR solution
                BSEPR = BSEPR(1,:);
            case 1
                % Output first BSEPR solution
                BSEPR = BSEPR(1,:);
            case 2
                % Output all BSEPR solutions
            otherwise
                error('Unexpected property value.');
        end
    end
end

