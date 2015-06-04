function S = ATISA2(trainingSet)
    % Pre-processing
    T = ENN(trainingSet);
    
    % Threshold assignment
    Thetas = zeros(size(T,1),1);
    for i = 1:size(Thetas,1)
        X = T(i,1:end-1);
        class = T(i,end);
        [~, distance] = NE(X,T,class);
        Thetas(i) = distance;
    end
    
    % Ordering by NE distances
    temp = [T,Thetas];
    temp = sortrows(temp,-size(temp,2));
    %T = temp(:,1:end-1);
    T = temp;
    
    % Reduced set generation
    S = T(1,:);
    for i = 2:size(T,1)
        X = T(i,1:end-2);
        
        [neighbor, distance] = KNN(X,S(:,1:end-1));
        
        if ((T(i,end-1) ~= S(neighbor,end-1)) | (distance > S(neighbor,end)))
            S = [S ; T(i,:)];
        end
    end
    
    S = S(:,1:end-1);
    
end

