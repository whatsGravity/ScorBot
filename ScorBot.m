classdef ScorBot < matlab.mixin.SetGet
    properties(GetAccess = 'public', SetAccess = 'public')
        MoveTime;
        MoveType;
        BSEPR;       %Joint angles
        XYZPR;       %Task Space
        Pose;        %Task Space (SE3)
        Gripper;
        Speed;
<<<<<<< HEAD

=======
>>>>>>> parent of cf59648... Fixed Setters
    end
    methods(Access = 'public')
        function obj = ScorBot
            ScorInit;
            ScorHome;
        end
        
        function delete(obj)
            ScorSafeShutdown;
        end            
    end
    
    methods
        function BSEPR = get.BSEPR(obj)
            BSEPR = obj.ScorGetBSEPR;
        end
        
        function XYZPR = get.XYZPR(obj)
            XYZPR = obj.ScorGetXYZPR;
        end
        
        function Pose = get.Pose(obj)
            Pose = obj.ScorGetPose;
        end
        
        function Gripper = get.Gripper(obj)
            Gripper = obj.ScorGetGripper;
        end
        
        function Speed = get.Speed(obj)
            Speed = obj.ScorGetSpeed;
        end
        
        function obj = set.BSEPR(obj, value)
            obj.BSEPR = value;
        end
        
        function obj = set.XYZPR(obj, value)
            obj.XYZPR = value;
        end
        
        function obj = set.Pose(obj, value)
            obj.Pose = value;
        end
        
        function obj = set.Gripper(obj, value)
            obj.Gripper = value;
        end
        
        function obj = set.Speed(obj, value)
            obj.Speed = value;
        end
    end
end