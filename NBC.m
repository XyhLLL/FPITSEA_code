function cluster = NBC(Pop,Fitness,fi)
%% Nearest-better clustering
    Popobj = Pop.objs;
    Popdec = Pop.decs;
    [N,~] = size(Popobj);
    input = Popdec;
    output = Fitness;
    [nodelist, ~] = NBC2Climbing(input,output,fi);
    nodelist = nodelist(:, [1 3]);
    cluster = CreateHeap(nodelist,N);
end

function [nodelist, nodelist2] = NBC2Climbing(input,output,fi)
    theta = 3;
    maxth = max(input);
    minth = min(input);
    threshold = fi*sqrt(sum((maxth-minth).^2));
    [samnum, Dim] = size(input);
    nodelist = zeros(samnum, 3);
    % distance matrix of each point
    DisGraph = pdist2(input, input);

    for samith = 1 : samnum
        Parent = 0;
        disEdge = 0;
        pointI = input(samith, :);
        fitnessI = output(samith);
        disTemp = DisGraph(samith, :);%sqrt(sum((repmat(pointI, samnum, 1) - input) .^ 2, 2))';%euclidean metric
        %         disTemp = sum(abs((repmat(pointI, samnum, 1) - input)) , 2)';%Manhattan Distance
        disTemp(disTemp == 0) = NaN;
        [dismat, disindex] = sort(disTemp);
        % find the nearest-better point
        for disindexIth = 1 : samnum
            if output(disindex(disindexIth)) > fitnessI
                disEdge = dismat(disindexIth);
                Parent = disindex(disindexIth);
                break;
            end
        end
        nodelist(samith, :) = [samith disEdge Parent];  
    end
    nodelist2 = nodelist;

    %%
    avedis = mean(nodelist(:, 2));
    [~, cutedgeindex] = find(nodelist(:, 2)' > threshold);
    nodelist(nodelist(:, 2) > threshold, 3) = -1;
    nodelist(nodelist(:, 3) == 0, 3) = -1;
    nodelist2(nodelist2(:, 2) > threshold, :) = [];
    nodelist2(nodelist2(:, 3) == 0, :) = [];

end

function Cluster = CreateHeap(nodelist, NodeNum)
% DFS(Depth-First-Search) algotighm to obtain sub-graphs
    %%
    CheckList = nodelist(:, 1) - nodelist(:, 2);
    if ~all(CheckList)
        nodelist(~CheckList, 2) = -1;
    end
    %%
    % start from the i-th point
    for i = 1 : NodeNum
        T = nodelist(i, 1);
        Path = [T];
        % Traverse from the i-th point to it's ROOT point (unitl the j-th point has no end_point)
        while nodelist(T, 2) ~= -1
            T = nodelist(T, 2);
            Path = [Path T];
        end
        Path(end) = [];
        nodelist(Path, 2) = T;
    end
    %%
    Root = find(nodelist(:, 2) == -1)';
    i = 1;
    NodeNum = zeros(length(Root), 1);
    for root = Root
        Node = [root, find(nodelist(:, 2) == root)'];
        Node = sort(Node);
        Cluster(i) = {Node};
        NodeNum(i) = length(Node);
        i = i + 1;
    end
    %%
    [~, Order] = find(NodeNum' == 1);
    if length(Order) > 1
        Merge = cell2mat(Cluster(Order));
        Cluster(end + 1) = {Merge};
        NodeNum(end + 1) = length(Merge);
        Cluster(NodeNum == 1) = [];
        NodeNum(NodeNum == 1) = [];
        Cluster(cellfun(@isempty, Cluster))=[];
        NodeNum(NodeNum == 0) = [];
        [~, Order] = sort(NodeNum);
        Cluster = Cluster(Order);
    end
end