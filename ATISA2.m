function S = ATISA2(trainingSet)
    % Pre-processing, ENN
    T = ENN(trainingSet);
    
    % Threshold assignment
    % Calcula as distancias dos padroes ate seus vizinhos mais proximos
    Tetas = zeros(size(T,1),1);
    for i = 1:size(Tetas,1)
        X = T(i,1:end-1);
        class = T(i,end);
        [~, distance] = NE(X,T,class);
        Tetas(i) = distance;
    end
    
    % Ordering by NE distances
    temp = [T,Tetas];
    temp = sortrows(temp,-size(temp,2));
    T = temp;
    
    % Reduced set generation
    S = T(1,:);
    for i = 2:size(T,1)
        % Vetor atual sem classe
        X = T(i,1:end-2);
        % Recupera seu vizinhos mais proximo, com sua distancia e classe
        [neighbor, distance, class_max] = KNN(X,S(:,1:end-1),1);
        
        % Se o vizinho nao for de mesma classe ou for mais distante de X
        % do que de seu inimigo mais proximo
        if ((T(i,end-1) ~= class_max) | (distance > S(neighbor,end)))
            % Adiciona X ao conjunto de prototipos
            S = [S ; T(i,:)];
        end
    end
    
    % Retorna o conjutno de prototipos sem as distancias Tetas
    S = S(:,1:end-1);
    
end

