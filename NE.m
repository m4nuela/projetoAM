function [neighbor,distance] = NE(X, T, class)
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
    
    % Procura o inimigo mais proximo
    for i = 1:size(distances,1)   
        if (class ~= T(distances(i,1),end))
            break;
        end
    end
    
    % Retorna o indice do inimigo mais proximo da tabela de treinamento T
    neighbor = distances(i,1);
    distance = distances(i,2);

end

