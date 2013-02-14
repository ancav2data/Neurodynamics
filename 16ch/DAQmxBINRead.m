function [y,headerInfo,fileMark, ElSite] = DAQmxBINRead( fileName)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Filename:      DAQmxBINRead
%Description:   Reads data from a given file that is in the format created
%               by the NI LabVIEW example "Cont Acq&Graph Voltage-To
%               File(Binary).vi"
%Author:        Chris Minnella
%Inputs:        startScan: #scans into file to start reading [one double]
%               scans: #scans (points per channel) to read from file [one double]
%               fileName: File name of binary data file [one string]
%               pathName: File path of binary data file [one string]
%               dataBytes: #of bytes per sample (2 or 4) [one double]
%Outputs:       y: Converted data [scans x channels matrix of doubles]
%               headerInfo: Information contained in file header 
%                           [structure]:
%                   headerInfo.NumCoefficients: Number of scaling
%                   coefficients
%                   headerInfo.NumChannels: Number of channels
%                   headerInfo.Fs: Sampaling rate of data [Hertz]
%                   headerInfo.Coefficients: Scaling coefficients 
%                   [coefxchan]
%                   headerInfo.DataBytes: Data element size in bytes
%                   headerInfo.HeaderSize: Header size in bytes
%               fileMark: Ending position of binary file marker
%Project:       NA
%Created:       10/20/06
%Modified:     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%use switch cases to support different dataTypes

        dataType='int16'
        dataBytes=2;

%Read header information, return in a structure
[headerInfo,fileMark, ElSite, fileSize] = GetHeader(fileName, dataBytes);

%Open binary file Big endian format
fid=fopen(fileName,'rb','ieee-be');
fileSize=fileSize-fileMark;
%Move file marker to begining of scans
fseek(fid,fileMark,'bof');

%Read number of requested scans
%headerInfo.NumChannels*scans
y=fread(fid,round(fileSize/2),dataType);

ll=length(y);
y=y(1:headerInfo.NumChannels*floor(ll/headerInfo.NumChannels));
%Reshape data into a matrix [scans x channels]

y=reshape(y,headerInfo.NumChannels,[])';

%Close binary file
fclose(fid);

%Scale integer data to voltage
%For the number of channels
for i=1:headerInfo.NumChannels
    %Initilize a temp variable, redo each channel loop
   temp=zeros(size(y,1),1); 
   
   %For the number of coefficients
    for j=1:headerInfo.NumCoefficients
        %Use coefficients to scale data, store and sum in temp variable
        %Scaled=sum(Coeff(j)*Binary^(j-1));
        temp=temp+(y(:,i).^(j-1)).*(headerInfo.Coefficients(j,i));
    end
    %Set channel data to the temp scaled data
    y(:,i)=temp;
end

function [headerInfo,fileMark,ElSite,fileSize]= GetHeader(fileName, dataBytes)
%GETHEADER Extracts the header information from a LabVIEW binary file
% and places it into a cell array for use in the DAQmxBINRead function

%Get the file size
fileInfo=dir([fileName]);
fileSize=fileInfo.bytes;

%Open the file for binary read access with big endian byte ordering
fid=fopen(fileName,'rb','ieee-be');

Channels=fread(fid,1,'uint32');
OnSite=dec2binvec(Channels,16)
ActiveElectrodes=find(OnSite==1);
ElectrodeMap=[8,7,1,5,6,2,4,3,9,10,16,12,11,15,13,14];
DepthMap = [1 16 2 15 3 14 4 13 5 12 6 11 7 10 8 9]; 
ElSite = ElectrodeMap(ActiveElectrodes);
disp('Depth profile');
DepthMap(ActiveElectrodes)
%Get the number of coefficients
numCoeff=fread(fid,1,'double');

%Get the number of channels
numChans=fread(fid,1,'double');

%Get the Coefficient matrix
coeffArray=fread(fid,numChans*numCoeff,'double');

%Reshape coefficients (#Rows=Coefficients;#Column=Channels)
coeffArray=reshape(coeffArray,numCoeff,numChans);
size(coeffArray)
%Calculate total header size (bytes)
headerSize=ftell(fid);
SF=coeffArray(1,1)
%Set varibales into a structure
headerInfo.NumCoefficients=numCoeff-1;
headerInfo.NumChannels=numChans;
headerInfo.Coefficients=coeffArray(2:end,:);
headerInfo.HeaderSize=headerSize;
headerInfo.Scans=((fileSize-headerSize)/dataBytes)/numChans;
headerInfo.ScanRate=coeffArray(1,1);

% Set file mark
fileMark=ftell(fid);
fclose(fid);