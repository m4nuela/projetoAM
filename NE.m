function [neighbor,distance] = NE(X, T, class)
    % Inicializando uma matrix de dist�ncias.
    distances = zeros(size(T,1),2);
    
    % Calcula a distancia de X para todos os vetores de treinamento
    for z = 1:size(T,1)
        Y = T(z,1:(end-1));
        distance = euclidean(X,Y);
        distances(z,:) = [z,distance];
    end
    
    %Ordenando pelas dist�ncias
    distances = sortrows(distances, 2);
    
    %indexs = label ~= T(distances(:,1),end);
    %distances = distances(indexs,:);
    
    for i = 1:size(distances,1)   
        if (class ~= T(distances(i,1),end))
            break;
        end
    end
    
    % Selecionando os indices dos k vetores mais pr�ximos
    %result = distances(k,:);
    neighbor = distances(i,1);
    distance = distances(i,2);

end

