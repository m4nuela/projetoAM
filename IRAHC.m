function S = IRAHC(trainingSet, TETA)
    % PARTE I - AGRUPAMENTO EM HIPER-RETANGULOS
    
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

    % Para todos os demais padrOes de treinamento
    for p = 2:size(samples,1)

        X = samples(p,:);
        class = labels(p);

        % Flag para identificar se o padrAo atual X foi alocado a algum cluster
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

        % Para todos os hiper-retangulos, verifica se X possui mesma classe
        % e dista deste por um valor nao-positivo
        for i = distances(:,1)'
            if ((HR(i).class == class) && (distances(i,2) <= 0))
                % Adiciona X a este cluster
                HR(i).instances = [HR(i).instances ; p];
                
                belongs = 1;
                break;
            end
        end

        % Se nao encontrar, procura por um HR que seja de mesma classe que 
        % X e satisfaça o criterio de expansao em funcao de Teta
        if (belongs == 0)
            for i = distances(:,1)'
                    % Calcula a diferenca entre os atributos maximos e minimos
                    % entre X e as arestas de HR(i) 
                    maxi = max(HR(i).maxi, X);
                    mini = min(HR(i).mini, X);
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

        % Se ainda nao encontrou um cluster, cria um novo HR, com X como 
        % representante, ou seja, de mesma classe e no mesmo ponto
        if (belongs == 0)
            mini = X;
            maxi = X;
            HR = [HR ; struct('class', class, 'mini', mini, 'maxi', maxi, 'instances', p)];
        end    

    end

    % PARTE II - CRIACAO DO CONJUNTO DE PROTOTIPOS
    % Conjunto de prototipos a ser gerado
    S = [];
    
    % Para todos os clusters
    for i = 1:size(HR,1)
        % Remover instâncias com distancias maiores que zero
        no_positives = [];
        for j = 1:size(HR(i).instances)
            Pi = trainingSet(HR(i).instances(j),1:end-1);
            distance = dist(Pi, HR(i).mini, HR(i).maxi);
            if (distance <= 0)
                no_positives = [no_positives; HR(i).instances(j)];
            end
        end
        
        % Instancias remanescentes do Hiper-Retangulo HR(i)
        HRiSamples = trainingSet(no_positives,:);

        % Seleciona as classes das instancias do cluster atual
        classes = unique(HRiSamples(:,end));

        % Se sao da mesma classe, calcula a media e descarta o restante
        if (size(classes,1) == 1)
            m = mean(HRiSamples,1);
            S = [S ; m];
        % Caso contrário, todas as instancias do cluster serao preservadas
        else
            S = [S; HRiSamples];
        end
    end
    
end


