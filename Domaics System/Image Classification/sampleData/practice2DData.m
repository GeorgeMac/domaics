function [ dataIn, dataClass, dataCentres ] = practice2DData( XLim, YLim, noOfCentres, noOfDatums )
%PRACTICE2DDATA Summary of this function goes here
%   Detailed explanation goes here
figure('name','Generate Data');
axes('XLim',XLim,'YLim',YLim);

hold on;

pointer = 1;

dataClass = [];

dataCentres = [];

dataIn = [];

while pointer < (noOfCentres + 1)
    [ x y ] = ginput(1);
    dataCentres = [ dataCentres; [ x y ] ];
    
    for i = 1 : noOfDatums
        datum = normrnd([ x y ],mean(abs([XLim YLim]))/10);
        dataIn = [ dataIn; datum];
        dataClass = [ dataClass; pointer ];
        text(datum(1,1),datum(1,2),int2str(pointer));
    end
    
    pointer = pointer + 1;
    
%     [m n] = size(dataIn);
%     for i = 1 : m
%         if dataClass(i,1) == pointer
%             text(dataIn(i,1),dataIn(i,2),int2str(dataClass(i,1)));
%         end
%     end
    
    
end

hold off;

end

