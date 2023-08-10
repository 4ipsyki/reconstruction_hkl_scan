function int_f=fit_func(xyz,II,Eq,stp,parlim,nmax)
%
% fit is preformed until the output parameters are within limits defined in
% parlim, or the maximum number or iteration nmax is reached.
% each iteration will start with a new starting point by selecting randomly
% withing the limits.
% if no satisfactory fit is reached the intensity is set to -1
    
    pn=length(stp);
    stp_curr=stp;
    II(II==0)=nan;
    fitting=1;
    niter=0;
    while fitting
        int_f=nlinfit(xyz,II(:),Eq,stp_curr);
        int_f(1:2:pn-1)=abs(int_f(1:2:pn-1));
%         % plot
%         fitted=Eq(int_f,xyz);
%         fitted=reshape(fitted,size(II));
%         II(isnan(II))=0;
%         figure(4433)
%         xx=xyz(1:size(II,2),2);yy=xyz(1:size(II,1):size(II,1)*size(II,2),1);zz=xyz(1:size(II,1)*size(II,2):end,3);
%         h0=stp(4);k0=stp(2);l0=stp(6); dlq=0.01;
%         plot_datafit_hkl(II,fitted,xx,yy,zz,[h0 k0 l0],dlq,...
%             xx([1,end]),yy([1,end]),zz([1,end]),[1 min([max(II(:))/2 30])],...
%             niter);
        if mult((int_f-parlim(1:2:end))>=0) && mult((parlim(2:2:end)-int_f)>=0)
            % fitting=0;
            break
        else
            stp_curr = rand(1,pn).*(parlim(2:2:end)-parlim(1:2:end))+parlim(1:2:end);
        end
        niter=niter+1;
        if niter == nmax
            int_f(1)=-1;
            break
        end
%         pause
    end
    %
end

function Y=mult(X)
    Y=X(1);
    for idx=2:length(X)
        Y=Y*X(idx);
    end
    Y=boolean(Y);
end
