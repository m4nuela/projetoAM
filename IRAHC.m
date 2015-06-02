function S = IRAHC(trainingSet)

    % ALGORITMO IRAHC
    % PARTE I
    
    samples = trainingSet(:,1:end-1);
    labels = trainingSet(:,end);
    
    % Vetor unitario que multiplica TETA
    N = zeros(1,size(samples,2)) + 1;
    % Parametro de expansao
    O = 0.6;

    % Primeio padrão escolhido
    X = samples(1,:);

    % Cria um Hiper-retangulo HR1 a patir de X
    class = labels(1);
    mini = X;
    maxi = X;
    distance = dist(X, mini, maxi);
    HR(1) = struct( 'class', class, 'mini', mini, 'maxi', maxi, 'instances', 1, 'distances', distance);

    % Para todos os demais padrões de treinamento
    for p = 2:size(samples,1)

        X = samples(p,:);
        class = labels(p);

        % Flag para identificar se o padrão atual X pertence a algum cluster
        belongs = 0;

        % Calcula as distancias entre X e todos os Hiper-Retangulos
        distances = zeros(size(HR,1),2);
        for i = 1:size(distances,1)
            % Distancia entre X e o Hiper-Retangulo HR(i)
            distance = dist(X, HR(i).mini, HR(i).maxi);
            distances(i,:) = [i,distance];
        end

        %Ordenando pelas distâncias calculadas
        distances = sortrows(distances, 2);

        % Verifica se X pertence a algum hiper-retangulo de mesma classe
        for i = distances(:,1)'
            if ((HR(i).class == class) && (ismember(p, HR(i).instances)))
                belongs = 1;
                break;
            end
        end

        % Se nao pertence, procura por um HR que seja de mesma classe que X e 
        % satisfaça o criterio de expansao
        if (belongs == 0)
            for i = distances(:,1)'
                if (HR(i).class == class)
                    % Calcula a diferenca entre as colunas de X e do Hiper-Retangulo
                    diff = max(HR(i).maxi,X) - min(HR(i).mini,X);
                    % Compara com o parametro de expansao
                    resp = (diff <= N*O);

                    % Se satisfaz o criterio, entao expande HR(i) e add X
                    if not(ismember(0,resp))
                        mini = min(HR(i).mini, X);
                        maxi = max(HR(i).maxi, X);

                        HR(i).instances = [HR(i).instances ; p];
                        HR(i).distances = [HR(i).distances ; distances(i,2)];

                        belongs = 1;
                        break;
                    end
                end
            end
        end

        % Se nao encontrou um cluster, cria um novo HR, com X como representante
        if (belongs == 0)
            mini = X;
            maxi = X;
            distance = dist(X, mini, maxi);
            HR = [HR ; struct('class', class, 'mini', mini, 'maxi', maxi, 'instances', p, 'distances', distance)];
        end    

    end

    % PARTE II

    % Conjunto de prototipos a ser gerado
    S = [];

    for i = 1:size(HR,1)
        % Instancias do Hiper-Retangulo HR(i)
        HRiSamples = trainingSet(HR(i).instances,:);

        % Seleciona as classes das instancias do cluster atual
        classes = unique(HRiSamples(:,end));

        % Se sao da mesma classe, calcula a media e descarta o restante
        if (size(classes,1) == 1)
            m = mean(HRiSamples,1);
            S = [S ; m];
        % Caso contrário, todas as instancias do cluster farão parte de S
        else
            S = [S; HRiSamples];
        end
    end


end

