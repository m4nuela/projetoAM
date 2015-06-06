function class = class_max(neighbor_classes)
    % Selecioando as classes individuais dos vizinhos e
    % mapeando cada inst�ncia em um indice da respectiva classe 
    [near_classes, ~, map] = unique(neighbor_classes);

    % Contador para selecionar a classe vizinha com maior
    % frequ�ncia
    temp = 0;
    winner = 0;
    for i = 1:size(near_classes)
        count = sum(ismember(map,i));
        if count > temp
            temp = count;
            winner = i;
        end
    end

    % Esta classe ser� a resposta/sa�da predita
    class = near_classes(winner);

end

