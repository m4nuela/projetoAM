function result = TestKNN(trainingSet, testSet)
    
    k = 3;
    correct = 0;
    for w = 1:size(testSet,1)
        % Vetor de teste/entrada
        X = testSet(w,1:end-1);

        % Matrix que armazena as distancias de cada instancia Y do
        % conjunto de treinamento at� X
        distances = zeros(size(trainingSet,1),2);

        for z = 1:size(trainingSet,1)
            Y = trainingSet(z,1:(end-1));
            % Distancia euclidiana normalizada entre X e Y
            distance = euclidean(X,Y);
            distances(z,:) = [z,distance];
        end

        %Ordenando pelas dist�ncias
        distances = sortrows(distances, 2);
        % Selecionando os k vetores mais pr�ximos
        neighbors = distances(1:k,:);
        % Guardando as classes destes k vetores
        neighbors_classes = trainingSet(neighbors(:,1),end);
        % Selecioando as classes individuais dos vizinhos e
        % mapeando cada inst�ncia em um indice da respectiva classe 
        [near_classes, ~, map] = unique(neighbors_classes);

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
        resp = near_classes(winner);

        % Contador � incrementado quando a resposta predita for igual a
        % mesma classe do vetor de teste/entrada X.
        if (testSet(w,end) == resp)
            correct = correct + 1;
        end

    end
    
    % Guarda a precis�o computada e retorna seu valor
    result = (correct/size(testSet,1))*100;

    
end

