function [result,BER] = TestKNN(trainingSet, testSet)

    k = 3;
    correct = 0;
    [classes, ~, map_classes] = unique(testSet(:,end));
    % Conta o numero de padroes erroneamente classificados de cada classe
    berArray = [classes,zeros(size(classes,1),1)]; %zeros(size(classes,1),2);
    %berArray(:,1) = 1:size(classes,1);
    % Taxa balanceada do erro
    BER = 0;
    
    for w = 1:size(testSet,1)
        % Vetor de teste/entrada
        X = testSet(w,1:end-1);

        % Matrix que armazena as distancias de cada instancia Y do
        % conjunto de treinamento até X
        distances = zeros(size(trainingSet,1),2);

        for z = 1:size(trainingSet,1)
            Y = trainingSet(z,1:(end-1));
            % Distancia euclidiana normalizada entre X e Y
            distance = euclidean(X,Y); %euclideanNorm(X,Y,ranges);
            distances(z,:) = [z,distance];
        end

        %Ordenando pelas distâncias
        distances = sortrows(distances, 2);
        % Selecionando os k vetores mais próximos
        neighbors = distances(1:k,:);
        % Guardando as classes destes k vetores
        neighbors_classes = trainingSet(neighbors(:,1),end);
        % Selecioando as classes individuais dos vizinhos e
        % mapeando cada instância em um indice da respectiva classe 
        [near_classes, ~, map] = unique(neighbors_classes);

        % Contador para selecionar a classe vizinha com maior
        % frequência
        temp = 0;
        winner = 0;
        for i = 1:size(near_classes)
            count = sum(ismember(map,i));
            if count > temp
                temp = count;
                winner = i;
            end
        end

        % Esta classe será a resposta/saída predita
        resp = near_classes(winner);

        % Contador é incrementado quando a resposta predita for igual a
        % mesma classe do vetor de teste/entrada X.
        realClass = testSet(w,end);
        if (realClass == resp)
            correct = correct + 1;
        else
            index = find(berArray(:,1) == realClass);
            berArray(index,2) = berArray(index,2) + 1;
        end
        

    end
    
    % Guarda a precisão computada e retorna seu valor
    result = (correct/size(testSet,1))*100;
    
    % Calcula a taxa balanceada do erro
    for m = 1:size(classes,1)
        % Para cada classe, divide o numero de instancias erroneamente
        % classificadas pelo total de instancias da classe atual
        countm = sum(ismember(map_classes,m));
        BER = BER + (berArray(m,2)/countm);
    end
    
    BER = (1/size(classes,1)) * BER * 100;
   
end

