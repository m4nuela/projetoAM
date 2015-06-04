function S = IRAHC(trainingSet, TETA)
    % PARTE I
    
    % Separa os dados e suas classes
    samples = trainingSet(:,1:end-1);
    labels = trainingSet(:,end);
    
    % Vetor unitario que multiplica TETA
    N = zeros(1,size(samples,2)) + 1;
    
    % Primeio padrão escolhido
    X = samples(1,:);

    % Cria um Hiper-retangulo HR1 a patir de X
    class = labels(1);
    mini = X;
    maxi = X;
    HR(1) = struct( 'class', class, 'mini', mini, 'maxi', maxi, 'instances', 1);

    % Para todos os demais padrões de treinamento
    for p = 2:size(samples,1)

        X = samples(p,:);
        class = labels(p);

        % Flag para identificar se o padrão atual X foi alocado a algum cluster
        belongs = 0;

        % Calcula as distancias entre X e todos os Hiper-Retangulos
        distances = zeros(size(HR,1),2);
        for i = 1:size(HR,1)
            % Distancia entre X e o Hiper-Retangulo HR(i)
            distance = dist(X, HR(i).mini, HR(i).maxi);
            distances(i,:) = [i,distance];
        end

        %Ordenando pelas distâncias calculadas
        distances = sortrows(distances, 2);

        % Verifica se X pertence a algum hiper-retangulo de mesma classe
        for i = distances(:,1)'
            if ((HR(i).class == class) && (distances(i,2) <= 0))
                if not(ismember(p, HR(i).instances))
                    HR(i).instances = [HR(i).instances ; p];
                end;
                
                belongs = 1;
                break;
            end
        end

        % Se nao pertence, procura por um HR que seja de mesma classe que X e 
        % satisfaça o criterio de expansao
        if (belongs == 0)
            for i = distances(:,1)' %1:size(HR,1) 
                    maxi = max(HR(i).maxi, X);
                    mini = min(HR(i).mini, X);
                    % Calcula a diferenca entre as colunas de X e do Hiper-Retangulo
                    diff = maxi - mini;
                    % Compara com o parametro de expansao
                    resp = (diff <= N*TETA);

                    % Se satisfaz o criterio, entao expande HR(i) e add X
                    if not(ismember(0,resp))
                        HR(i).mini = mini;
                        HR(i).maxi = maxi;
                        HR(i).instances = [HR(i).instances ; p];
                        
                        belongs = 1;
                        break;
                    end
            end
        end

        % Se nao encontrou um cluster, cria um novo HR, com X como representante
        if (belongs == 0)
            mini = X;
            maxi = X;
            HR = [HR ; struct('class', class, 'mini', mini, 'maxi', maxi, 'instances', p)];
        end    

    end
%{
    % teste das distancias nao-positivas
    for i = 1:size(HR,1)
        allNoPositive = 1;
        for j = 1:size(HR(i).instances)
            Pi = trainingSet(HR(i).instances(j),1:end-1);
            distance = dist(Pi, HR(i).mini, HR(i).maxi);
            if(distance > 0 )
                allNoPositive = 0;
                break;
            end
        end
        disp(allNoPositive);
    end
%}
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

