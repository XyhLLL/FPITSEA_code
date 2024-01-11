function IFP = CalFP(Union)
% Calculate fuzzy preference indicator

    IFP = zeros(1,length(Union));

    %% Convergence indicator
    Obj = Union.objs;
    n = length(Union);
    % Determine the dominance relationship between the solution
    Dominate = false(n);
    for i = 1 : n-1
        for j = i+1 : n
            k = any(Obj(i,:)<Obj(j,:)) - any(Obj(i,:)>Obj(j,:));
            if k == 1
                Dominate(i,j) = true;
            elseif k == -1
                Dominate(j,i) = true;
            end
        end
    end
    Conv = sum(Dominate);
    Con = (Conv-min(Conv))./(max(Conv)-min(Conv));

    %% Diversity indicator
    CD = Crowding(Union.decs);
    Div = (CD-min(CD))./(max(CD)-min(CD));
    
    %% Calculate the fuzzy preference indicator for each solution
    Con = Con';
    Div = Div';
    for i = 1:n
        A = 1:n;
        A = setdiff(A,i);
        d_div12 = (Div(i)-Div(A))';
        d_con12 = (Con(A)-Con(i))';
        udiv12 = 1./(1+exp(-d_div12./1));
        ucon12 = 1./(1+exp(-d_con12./1));
        tmp = sum(udiv12.*ucon12);
        IFP(i) = tmp;
    end
    
end

