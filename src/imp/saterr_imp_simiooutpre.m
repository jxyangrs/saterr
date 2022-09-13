% I/O output
% removing redundant variables and fields
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/03/2018: original code

switch Path.scheme
    case 'A'
        % -----------------------------
        % count
        % -----------------------------
        tc = VarDynamic.tc_chan_out;
        tw = VarDynamic.tw_chan_out;
        cc = VarDynamic.cc_chan_out;
        cw = VarDynamic.cw_chan_out;
        cs = VarDynamic.cs_chan_out;
        
    case 'B'
        
        % -----------------------------
        % output
        % -----------------------------
        tc_chan = VarDynamic.tc_chan_out;
        tw_chan = VarDynamic.tw_chan_out;
        cc_chan = VarDynamic.cc_chan_out;
        cw_chan = VarDynamic.cw_chan_out;
        cs_chan = VarDynamic.cs_chan_out;
        
        tc = single(tc);
        tw = single(tw);
        cc = single(cc);
        cw = single(cw);
        cs = single(cs);      
        
        tb_mainlobe = AP.tb.mainlobe;
        tb_scene = AP.tb.tbscene;

        lat = single(Orbit.fov.lat);
        lon = single(Orbit.fov.lon);
end

