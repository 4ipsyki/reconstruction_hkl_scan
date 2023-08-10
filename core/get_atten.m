function atten=get_atten(file)

atten=[];

fid=fopen(file,'r');

if (fid <0) 

   disp('Data filename has not been specified correctly')
   return;
   
end  

%----- Read through data file 

test='DIFF_ABSORBER';

dataline=fgetl(fid);
while strncmp(test,dataline,size(test,2))==0
    if ~isempty(dataline)
        if dataline==-1,fclose(fid);return, end 
    end
    dataline=fgetl(fid);
end
sl=split(dataline,"=");
atten = str2num(sl{2});
fclose(fid);
end

