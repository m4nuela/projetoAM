function result = KNN(Xv, trainingSet, k)
    % calcula o range pra cada coluna
    ranges = [];
    for i = 1:(size(trainingSet,2)-1)
        Maxi = max(trainingSet(:,i));
        Mini = min(trainingSet(:,i));
        ranges = vertcat(ranges, Maxi - Mini);
    end

    % Inicializando uma matrix de distâncias.
    distances = zeros(size(trainingSet,1),2);
    
    % Calcula a distancia de X para todos os vetores de treinamento
    for z = 1:size(trainingSet,1)
        Yv = trainingSet(z,1:(end-1));
        distance = euclideanNorm(Xv,Yv,ranges);
        distances(z,:) = [z,distance];
    end
    
    %Ordenando pelas distâncias
    distances = sortrows(distances, 2);
    
    % Selecionando os indices dos k vetores mais próximos
    result = distances(1:k,1);
    
end

