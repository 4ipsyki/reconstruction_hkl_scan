function [data,datastr]=bw5data(file)
%
% function [data,datastr]=bw5data(file)
%
% MATLAB function to load BW5 data from HASYLAB
%
% DFM: 5.12.02
%
%----- Open TASCOM data file

data=[]; datastr=[];

dferror=0;

fid=fopen(file,'r');

if (fid <0) 

   disp('Data filename has not been specified correctly')
   return;
   
end  

%----- Read through data file 

test=[];
data=[];
datastr=[];

while strncmp(test,'%d',2)==0

    dataline=fgetl(fid);
%     disp(num2str(dataline)); % for debug
    if ~isempty(dataline)
        if dataline==-1, dferror=1; fclose(fid);return, end 
    end
    test=strtok(dataline);
    if ~isempty(test), test=dataline; end
           
end

% file=strtok(file,'.');
file=fliplr(strtok(fliplr(file(1:end-4)),'.'));
if 1==1
% Patch to avoid problems with file names when standing outside the data directory:
% Get rid of additional folder information.  27/06
file=fliplr(strtok(fliplr(file),'/'));
end


colnum=1;
while(1)
    
    dataline=fgetl(fid);
%     ic=strfind(dataline,'Col');
    ic=findstr('Col',dataline);
    if isempty(ic), break, end
    ii=isspace(dataline);
    a=find(ii==1);
    c=deblank(fliplr(deblank(fliplr(lower(dataline(a(3):a(4)))))));
    ifs=findstr(lower(file),c);
    ch=c(length(file)+ifs+1:end);
    if colnum==1 && isempty(ch), ch='x'; colnum=2; end
    if colnum==2 && isempty(ch), ch='idet'; colnum=3; end
    if colnum==3 && isempty(ch), ch='C'; colnum=4; end  % NBC 6/12 2002
    
%     datastr=strvcat(datastr,ch);
    datastr=char(datastr,ch);
    
end
datastr=datastr(2:end,:);
while(2)


   if ~isempty(dataline), a=sscanf(dataline,'%f'); data=[data; a']; end
   dataline=fgetl(fid);
   if dataline==-1, fclose(fid);return, end 

end

fclose(fid)

