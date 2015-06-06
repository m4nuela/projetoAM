function P = drop3(T)
    k = 3;
    
    S = ENN(T);
    
    m = size(S,1);
    
    Neighbors(1:m) = struct('neighbors', []);
    Associates(1:m) = struct('associates', []);
    
    for s = 1:m
        X = S(s,1:end-1);
        
        neighbors = KNN(X,S,k+1);
        Neighbors(s).neighbors = neighbors;
        %{
        associates = [];
        iter = 1:m;
        for j = iter(iter ~= i)
            Y = S(j,1:end-1);
            [neighbors,~] = KNN(Y,S,k);
            
            if(ismember(i,neighbors))
                associates = [associates ; j];
            end
        end
        Associates(i).associates = associates;
        %}
        for n = neighbors(1:k)'
            Associates(n).associates = [Associates(n).associates; s];
        end
    end
    
    % Threshold assignment
    Thetas = zeros(m,1);
    for i = 1:size(Thetas,1)
        X = S(i,1:end-1);
        class = S(i,end);
        [~, distance] = NE(X,T,class);
        Thetas(i) = distance;
    end
    
    % Ordering by NE distances
    indexes = (1:m)';
    temp = [indexes,S,Thetas];
    temp = sortrows(temp,-size(temp,2));
    
    order = temp(:,1)';
    marked = zeros(m,1);
    P = [];
    
    for s = order
        associates = Associates(s).associates;
        if(isempty(associates))
            marked(s) = 1;
        else
            x = 0; y = 0;
            for a =  associates'
                neighbors = Neighbors(a).neighbors(1:k+1); % testar aqui!
                neighbor_classes = S(neighbors,end); % TESTAR AQUI!

                class = class_max(neighbor_classes);
                if(S(a,end) == class)
                    x = x + 1;
                end

                neighbors = neighbors(neighbors ~= s);
                neighbor_classes = S(neighbors,end);

                class = class_max(neighbor_classes);
                if(S(a,end) == class)
                    y = y + 1;
                end    
            end

            if(y - x) >= 0
                marked(s) = 1;
            end
        end
        
        if(marked(s))
            for a = associates'
                neighbors = Neighbors(a).neighbors;
                neighbors = neighbors(s ~= neighbors);
                Neighbors(a).neighbors = neighbors;

                new_neighbor = neighbors(k);
                associates = Associates(new_neighbor).associates;
                Associates(new_neighbor).associates = [associates; a];
            end

            s_neighbors = Neighbors(s).neighbors(1:k);
            for n = s_neighbors'
                associates = Associates(n).associates;
                Associates(n).associates = associates(s ~= associates);
            end
            
        else
            P = [P; S(i,:)];
        end
    end
    
    %{
    for i = 1:m
       if ~marked(i)
           P = [P; S(i,:)];
       end
    end
    %}
    
    
end

