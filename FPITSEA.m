classdef FPITSEA < ALGORITHM
% <multi/many> <real> <multimodal>
% Two-stage evolutionary algorithm with fuzzy preference indicator for multimodal multi-objective optimization
% p --- 0.25 ---
% fi --- 0.1 ---

%------------------------------- Reference --------------------------------
% 
%------------------------------- Copyright --------------------------------
% Copyright (c) 2023 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

    methods
        function main(Algorithm,Problem)

            p = Algorithm.ParameterSet(0.25);
            fi = Algorithm.ParameterSet(0.1);
            %% Generate random population
            N = Problem.N;
            Population = Problem.Initialization();
            [~,CD] = EnvironmentalSelectionS1(Population,N);
            %% Optimization
            while Algorithm.NotTerminated(Population)     
                if Problem.FE < p*Problem.maxFE
                  %% The first stage of evolution
                    Matingpool = TournamentSelection(2,N,CD);    
                    Offspring = OperatorGA(Population(Matingpool));   
                    Union = [Population Offspring];
                    [Population,CD] = EnvironmentalSelectionS1(Union,N);
                else
                  %% The second stage of evolution
                    Population = IndependentEvolution(Population,N,fi);
                end
            end
        end
    end
end