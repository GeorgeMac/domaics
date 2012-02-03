function [ network ] = netCreate( in,hid,out,hiddenA,outputA,weights,classes )
%NETWORK Summary of this function goes here
%   Detailed explanation goes here
network = struct('in',in,'hid',hid,'out',out,'weightsOne',randn([in hid],'double'),...
    'weightsTwo',randn([hid out],'double'),'hiddenA',@sigmoid,'outputA',@void,...
    'biasHid',randn([1 hid]),'biasOut',(randn([1 out])),'classes',[]);

if nargin > 3
    network.hiddenA = hiddenA;
    if nargin > 4
        network.outputA = outputA;
        if nargin > 5
            network.weightsOne = weights.*ones([in hid]);
            network.weightsTwo = weights.*ones([hid out]);
            network.biasHid = weights.*ones([1 hid]);
            network.biasOut = weights.*ones([1 out]);
            if nargin > 6
                network.classes = classes;
            end
        end
    end
end


end

