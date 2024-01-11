function Population = IndependentEvolution(Population,N,fi)
% Independent evolution strategy

    %% Use NBC to divide the population
    CD = Crowding(Population.decs);
    Popobj = Population.objs;
    Popobj = (Popobj-min(Popobj))./(repmat(max(Popobj)-min(Popobj),N,1));
    Z = min(Popobj,[],1);
    Fitness = pdist2(Popobj,Z);    
    HD = NBC(Population,-Fitness,fi);  

    lpop = cell(1,length(HD));
    lCD = cell(1,length(HD));
    lpopnum = zeros(1,length(HD));
    for i = 1:length(HD)
        lpop{i} = Population(HD{i});
        lpopnum(i) = length(lpop{i});
        lCD{i} = CD(HD{i});
    end        

    %% Reproduction within the subpopulation
    for i = 1:length(HD)
        subpop = lpop{i};
        subCD = lCD{i};
        mateidx = TournamentSelection(2,length(subpop),-subCD);
        Off = OperatorGA(subpop(mateidx));
        lpop{i} = [lpop{i} Off];
    end
    
    %% Environmental selection
    Population = EnvironmentalSelectionS2(lpop,N);
end

function Pop = EnvironmentalSelectionS2(lpop,N)
% Environmental Selection in the second stage of evolution

    %%
    ndpop = [];
    dpop = [];
    for i = 1:length(lpop)
        cpop = lpop{i};
        [FNo1,~] = NDSort(cpop.objs,length(cpop));
        ndpop = [ndpop cpop(FNo1==1)];  % Non-dominated solutions in subpopulation
        dpop = [dpop cpop(FNo1~=1)];    % Dominated solutions in subpopulation
    end
    
    [FNo2,~] = NDSort(dpop.objs,length(dpop));
    k = 1;
    while length(ndpop) < N
        ndpop = [ndpop dpop(FNo2==k)];
        k = k+1;
    end
    
    % Use IDSS to select the next generation of the population
    Pop = ndpop;
    if length(Pop) > N
        Pop = IDSS(Pop,N);
    end
end
