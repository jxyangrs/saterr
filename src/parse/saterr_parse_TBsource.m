function saterr_parse_TBsource(tb_source)
% parsing TB source
%
% Input:
%       tb_source
% Output:
%       TBsrc
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/06/2019: original code

global Rad TBsrc

% index of cc,cw,cs,c_null
nchan = Rad.num_chan;
n1 = Rad.ind_CT_num(1);
n2 = Rad.num_alongtrack;

switch tb_source
    case 0
        n = size(TBsrc.Tas);
        if ~isequal(n,[1,nchan])
            error('size of TBsrc.Tas is not equal Rad.num_chan')
        end
        n = size(TBsrc.E);
        if ~isequal(n,[1,nchan])
            error('size of TBsrc.Tas is not equal Rad.num_chan')
        end
        
    case 'constant'
        n = size(TBsrc.Tas);
        if ~isequal(n,[1,nchan])
            error('size of TBsrc.Tas is not equal Rad.num_chan')
        end
        n = size(TBsrc.E);
        if ~isequal(n,[1,nchan])
            error('size of TBsrc.Tas is not equal Rad.num_chan')
        end
        
    case 'ocean'
        n = size(TBsrc.ocean.sst);
        if ~(isequal(n,[1,1]) || isequal(n,[n1,n2]))
            error('size of TBsrc.ocean.sst is wrong')
        end
        n = size(TBsrc.ocean.wind);
        if ~(isequal(n,[1,1]) || isequal(n,[n1,n2]))
            error('size of TBsrc.ocean.wind is wrong')
        end
        
    case 'land'
        n = size(TBsrc.land.tmp);
        if ~(isequal(n,[1,1]) || isequal(n,[n1,n2]))
            error('size of TBsrc.land.tmp is wrong')
        end
        n = size(TBsrc.land.E);
        if ~(isequal(n,[1,1]) || isequal(n,[n1,n2]))
            error('size of TBsrc.land.E is wrong')
        end
        
    case 'cosmic'
        n = size(TBsrc.Tcosmic);
        if ~(isequal(n,[1,1]))
            error('size of TBsrc.Tcosmic is wrong')
        end
        
    case 'waveform'
        s = sum(strcmp(TBsrc.wave.type,{'constant','sine','square','triangle','sawtooth'}));
        if s==0
            error('TBsrc.wave.type is wrong')
        end
        
        n = size(TBsrc.wave.amp);
        if ~(isequal(n,[nchan,1]))
            error('size of TBsrc.wave.amp is wrong')
        end
        n = size(TBsrc.wave.dc);
        if ~(isequal(n,[nchan,1]))
            error('size of TBsrc.wave.dc is wrong')
        end
        n = size(TBsrc.wave.num_period);
        if ~(isequal(n,[nchan,1]))
            error('size of TBsrc.wave.num_period is wrong')
        end
        n = size(TBsrc.wave.phase);
        if ~(isequal(n,[nchan,1]))
            error('size of TBsrc.wave.phase is wrong')
        end
        s = sum(TBsrc.wave.scan == [1,2]);
        if s==0
            error('size of TBsrc.wave.phase is wrong')
        end
        if strcmp(TBsrc.wave.type,'sawtooth')
            if ~isscalar(TBsrc.wave.sawwidth)
                error('TBsrc.wave.sawwidth is not a scalar')
            end
        end
 
        
    case 'customize'
        n1 = 4;
        n2 = Rad.ind_CT_num(1);
        n3 = Rad.num_alongtrack(1);
        n4 = Rad.num_chan;
        n = size(TBsrc.Tas);
        if ~isequal(n,[n1,n2,n3,n4])
            error('size of TBsrc.Tas is not equal Rad.num_chan')
        end
        n = size(TBsrc.E);
        if ~isequal(n,[n1,n2,n3,n4])
            error('size of TBsrc.Tas is not equal Rad.num_chan')
        end
        
    case 'linear'
        n = size(TBsrc.linear.tbrange); % range of tb, [min,max]
        if ~(isequal(n,[1,2]))
            error('size of TBsrc.linear.tbrange is wrong')
        end

    otherwise
        error('TBsrc.source error')
end
