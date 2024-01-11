function ChoosePop = IDSS(Population,N)
% Improved distance-based subset selection method
   
    %%
    pop = [];
    decdist = pdist2(Population.decs,Population.decs,'euclidean','Smallest',2);
    objdist = pdist2(Population.objs,Population.objs,'euclidean','Smallest',2);
    decdist = decdist(2,:);
    objdist = objdist(2,:);
    nordecdist = (decdist-min(decdist))./(max(decdist)-min(decdist));
    norobjdist = (objdist-min(objdist))./(max(objdist)-min(objdist));    
    distsum = nordecdist+norobjdist;
    [~,midx] = max(distsum);
    pop = [pop Population(midx)];
    retainpop = Population;
    retainpop(midx) = [];

    %% Iterative selection
    while length(pop) < N
        decdist = pdist2(pop.decs,retainpop.decs,'euclidean','Smallest',1);
        objdist = pdist2(pop.objs,retainpop.objs,'euclidean','Smallest',1);
        nordecdist = (decdist-min(decdist))./(max(decdist)-min(decdist));
        norobjdist = (objdist-min(objdist))./(max(objdist)-min(objdist));
        distsum = nordecdist+norobjdist;
        [~,midx] = max(distsum);
        pop = [pop retainpop(midx)];
        retainpop(midx) = [];
    end
    
    ChoosePop = pop;
end

