function [neighbor, distance] = KNN(X, trainingSet)
    
    % Inicializando uma matrix de distâncias.
    distances = zeros(size(trainingSet,1),2);

    % Calcula a distancia de X para todos os vetores de treinamento
    for z = 1:size(trainingSet,1)
        Y = trainingSet(z,1:(end-1));
        distance = euclidean(X,Y);
        distances(z,:) = [z,distance];
    end

    %Ordenando pelas distâncias
    distances = sortrows(distances, 2);

    if (distances(1,2) == 0)
        % Selecionando o indice do vetor mais próximo
        neighbor = distances(2,1);
        distance = distances(2,2);
    else
        neighbor = distances(1,1);
        distance = distances(1,2);
    end
    
end

