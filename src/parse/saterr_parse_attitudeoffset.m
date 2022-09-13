% parse spacecraft attitude
% 
% 
% Output:
%       Orbit.sc.roll,      [crosstrack,alongtrack]/0
%       Orbit.sc.pitch,     [crosstrack,alongtrack]/0
%       Orbit.sc.yaw,       [crosstrack,alongtrack]/0
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/04/2019: original code

% -----------------------------
% parse
% -----------------------------
if Orbit.attitude.onoff==1
    n1 = Rad.ind_CT_num(1);
    n2 = Rad.num_alongtrack;
    
    m = size(roll);m2=size(pitch);m3=size(yaw);
    d = bsxfun(@minus,[m2;m3],m);
    if sum(abs(d(:)))>0
        error('Sizes are different for roll, pitch, yaw')
    end
    
    if isequal(m,[1,1])
        Orbit.sc.roll = roll*ones(n1,n2);
        Orbit.sc.pitch = pitch*ones(n1,n2);
        Orbit.sc.yaw = yaw*ones(n1,n2);
    elseif isequal(m,[1,n2])
        Orbit.sc.roll = roll(ones(n1,1),:);
        Orbit.sc.pitch = pitch(ones(n1,1),:);
        Orbit.sc.yaw = yaw(ones(n1,1),:);
    elseif isequal(m,[n1,n2])
        Orbit.sc.roll = roll;
        Orbit.sc.pitch = pitch;
        Orbit.sc.yaw = yaw;
    else
        error('Size error of roll,pitch,yaw')
    end
    
else
    Orbit.sc.roll = 0;
    Orbit.sc.pitch = 0;
    Orbit.sc.yaw = 0;
    
end
