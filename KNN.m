function [neighbor, distance, class] = KNN(X, T, k)
    
    % Inicializando uma matrix de distâncias.
    distances = zeros(size(T,1),2);

    % Calcula a distancia de X para todos os vetores de treinamento
    for z = 1:size(T,1)
        Y = T(z,1:(end-1));
        distance = euclidean(X,Y);
        distances(z,:) = [z,distance];
    end

    %Ordenando pelas distâncias
    distances = sortrows(distances, 2);
    
    % Selecionando os indices e distancias dos k vizinhos mais proximos
    % Caso a distancia para o primeiro vizinho mais proximo seja 0
    if (distances(1,2) == 0)
        % Se existirem outros padroes, ignora este, pois corresponde ao X
        if size(distances,1) > 1
            neighbor = distances(2:k+1,1);
            distance = distances(2:k+1,2);
        else
             neighbor = distances(1,1);
             distance = distances(1,2);
        end
    else
        neighbor = distances(1:k,1);
        distance = distances(1:k,2);
    end
    
    % Guardando as classes destes k vetores
    neighbor_classes = T(neighbor,end);
    class = class_max(neighbor_classes);
    
end

