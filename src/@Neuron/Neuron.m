classdef Neuron < handle
    %Simple neuron implementation
    %   Currently this is binary a threshold unit, arbitrary activation 
    %   functions might come later
    
    properties (SetAccess = {?Hopfieldnet}, GetAccess = public)
        weight
        bias
        state
    end
    
    methods
        % Constructor
        % inputcount: number of neuron inputs
        function obj = Neuron(inputcount) 
            if  nargin > 0
                    obj.weight = rand(1, inputcount) - 0.5;
                    obj. bias = 0;
            end
        end
        
        % Feeds the data through the neuron
        % input: input data. has to be a row vector with as many fields as
        % inputs (weights) in the neuron
        function X = fire(obj, input)
            X = obj.weight * input.' + obj.bias;
            if X < 0 
                X = -1;
            else
                X = 1;
            end
            obj.state = X;
        end
    end
end

