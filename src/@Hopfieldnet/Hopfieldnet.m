classdef Hopfieldnet < handle
    %Hopfield network implementation
    %   net consist of multiple neurons in a structure that is similiar to
    %   the object's it represents (e.g. n*m for an n*m picture, every 
    %   neuron represents a pixel)
    
    properties (SetAccess = private)
        % row vector containing all the neurons
        % the matrix definied by structure is converted to a row vector
        % column-by-column e.g:
        % (numbers represent resulting indices)
        % 1 4 7
        % 2 5 8
        % 3 6 9
        neurons
        % underlying structure
        structure
    end
    
    methods
        % Net constructor
        % neuroncount: number of neurons in the net
        function obj = Hopfieldnet(structure)
            if size(structure, 1) ~= 1 || length(structure) ~= 2
                disp('Structure has to be an integer vector: [height, width]')
            else
                obj.neurons = Neuron();
                obj.structure = structure;
                inputcount = structure(1) * structure(2);
                for i = inputcount:-1:1
                    obj.neurons(i) = Neuron(inputcount);
                end
            end
        end
        
        % see Kevin Gurney's book 7.5.1
        % examples: vector of data the net has to memorize (3D matrix)
        %   the data has to have the same structure as the net
        function store(obj, examples)
            trainingsize = size(examples);
            if isequal(trainingsize(1:2), obj.structure)
                networksize = prod(obj.structure);
                weights = zeros(1, networksize);
                for i = 1:networksize
                    for j = 1:networksize
                    % coordinates of the pixel represented by neuron i
                    pixeli = [mod(i - 1,obj.structure(1)) + 1 ...
                        ceil(i/obj.structure(1))];
                    % coordinates of the pixel represented by neuron j
                    pixelj = [mod(j - 1,obj.structure(1)) + 1 ...
                        ceil(j/obj.structure(1))];
                        weights(j) = ...
                            squeeze(examples(pixeli(1),pixeli(2), :)).'*...
                            squeeze(examples(pixelj(1),pixelj(2), :));
                    end
                    obj.neurons(i).weight = weights;
                end
            end
        end
        
        % plots the current network state on a heatmap
        function plotstate(obj)
            % get network state
            networksize = length(obj.neurons);
            state = zeros(1, networksize);
            for i = 1:networksize
                state(i) = obj.neurons(i).state;
            end
            state = reshape(state, obj.structure);
            heatmap(state);
        end
        
        % Updates the network multiple times. only one random neuron is
        % updated at every iteration.
        % input: data to run the network on. resets the network state. has
        % to have as many fields as neurons
        % iterations: number of times to update the network state.
        function run(obj, iterations, input) 
            if nargin == 2
                % get network state
                networksize = length(obj.neurons);
                netstate = zeros(1, networksize);
                for i = 1:networksize
                    netstate(i) = obj.neurons(i).state;
                end
                % update a random neuron
                for i = 1:iterations        
                    randomness = ceil(rand() * networksize);
                    netstate(randomness) = ...
                        obj.neurons(randomness).fire(netstate);
                end
            elseif nargin > 2
                networksize = length(obj.neurons);
                for i = 1:networksize
                    % coordinates of the pixel represented by neuron i
                    pixeli = [mod(i - 1,obj.structure(1)) + 1 ...
                        ceil(i/obj.structure(1))];
                    obj.neurons(i).state = input(pixeli(1), pixeli(2));
                end
                run(obj, iterations);
            end
        end
    end
    
end

