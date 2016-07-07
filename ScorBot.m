%classdef ScorBot < matlab.mixin.SetGet
classdef ScorBot < hgsetget
    properties(GetAccess = 'public', SetAccess = 'public')
        MoveTime
        MoveType
        BSEPR       %Joint angles
        XYZPR       %Task Space
        Pose        %Task Space (SE3)
        Gripper
        Speed
        Control
        IsMoving
        PendantMode
        IsReady
        GripperOffset
    end
    
    methods(Access = 'public')
        function obj = ScorBot
            ScorInit;
            ScorHome;
            initialize(obj);
        end
        
        function delete(obj)
            ScorSafeShutdown;
            delete(obj);
        end
        
        function initialize(obj)
            obj.MoveTime = ScorGetMoveTime;
            obj.MoveType = 'LinearJoint';
            obj.BSEPR = ScorGetBSEPR;
            obj.XYZPR = ScorGetXYZPR;
            obj.Pose = ScorGetPose;
            obj.Gripper = ScorGetGripper;
            obj.Speed = ScorGetSpeed;
        end
    end
    
    methods
        function BSEPR = get.BSEPR(obj)
            disp('TEST')
            BSEPR = ScorGetBSEPR;
        end
        
        function XYZPR = get.XYZPR(obj)
            XYZPR = ScorGetXYZPR;
        end
        
        function Pose = get.Pose(obj)
            Pose = ScorGetPose;
        end
        
        function Gripper = get.Gripper(obj)
            Gripper = ScorGetGripper;
        end

        function Speed = get.Speed(obj)
            Speed = ScorGetSpeed;
        end
        
        function IsMoving = get.IsMoving(obj)
            IsMoving = ScorIsMoving;
        end
        
        function Control = get.Control(obj)
            Control = ScorGetControl;
        end
        
        function PendantMode = get.PendantMode(obj)
            PendantMode = ScorGetPendantMode;
        end
        
        function IsReady = get.IsReady(obj)
            IsReady = ScorIsReady;
        end
        
        function GripperOffset = get.GripperOffset(obj)
            GripperOffset = scorGetGripperOffset;
        end
        %% all the setter methods

        function obj = set.BSEPR(obj, value)
            obj.BSEPR = value;
            ScorSetBSEPR(value, 'MoveType', obj.MoveType);
        end
        
        function obj = set.XYZPR(obj, value)
            obj.XYZPR = value;
            ScorSetXYZPR(value, 'MoveType', obj.MoveType);
        end
        
        function obj = set.Pose(obj, value)
            obj.Pose = value;
            ScorSetPose(value);
        end
        
        function obj = set.Gripper(obj, value)
            obj.Gripper = value;
            ScorSetGripper(value);
        end
        
        function obj = set.Speed(obj, value)
            obj.Speed = value;
            ScorSetSpeed(value);
        end
        
        function obj = set.MoveTime(obj, value)
            obj.MoveTime = value;
            ScorSetMoveTime(value);
        end
        
        function obj = set.MoveType(obj, value)
            switch(lower(value))
                case 'linearjoint'
                    obj.MoveType = 'LinearJoint';
                case 'lineartask'
                    obj.MoveType = 'LinearTask';
                otherwise
                    error('Move Type must be LinearTask or LinearJoint');   
            end
        end
        
        function obj = set.dBSEPR(obj, value)
            ScorSetDeltaBSEPR(value);
            obj.dBSEPR = value;
            obj.BSEPR = ScorGetBSEPR;    
        end
        
        function obj = set.dXYZPR(obj, value)
            ScorSetDeltaXYZPR(value);
            obj.dXYZPR = value;
            obj.XYZPR = ScorGetXYZPR;    
        end
        
        function obj = set.dPose(obj, value)
            ScorSetDeltaPose(value);
            obj.dPose = value;
            obj.Pose = ScorGetPose;    
        end
        
        function obj = set.Control(obj, value)
            switch(lower(value))
                case 'on'
                    obj.Control = value;
                    ScorSetControl(value);
                case 'off'
                    obj.Control = 'Off';
                    ScorSetControl('Off');
                otherwise
                    error('Control must be on or off');
            end
        end
        
        function obj = set.PendantMode(obj, value)
            switch(lower(value))
                case('auto')
                    obj.PendantMode = 'Auto'
                    ScorSetPedantMode('Auto');
                case('teach')
                    obj.PendantMode = 'teach';
                    ScorSetPendantMode('teach');
                otherwise
                    error('PendantMode must be Auto or Teach');
            end
        end
            %% action commands
        function goHome(obj)
            ScorGoHome;
        end
        
        function undo(obj)
            ScorSetBSEPR(obj.prevBSEPR);
            obj.prevBSEPR = obj.BSEPR;
            obj.BSEPR = ScorGetBSEPR;
        end
        
        function waitForMove(varargin)
            ScorWaitForMove(varargin);
        end
        
        function createVector(vName, n)
            ScorCreateVector(vName, n);
        end
        

        function setPoint(varargin)
            ScorSetPoint(varargin)
        end
        
        function gotoPoint(varargin)
            ScorGoroPoint(varargin)
        end
    end
end