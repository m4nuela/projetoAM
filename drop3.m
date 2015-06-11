function P = drop3(T)
    
    % Quantidade de vizinhos mais proximos
    k = 3;
    % Aplica o ENN previamente para remover os ruidos
    S = ENN(T);
    % Tamanho de S
    m = size(S,1);
    
    % Mapeamento de vizinhos e associados de cada exemplo de S
    Neighbors(1:m) = struct('neighbors', []);
    Associates(1:m) = struct('associates', []);
    
    % Procura os vizinhos de cada padrao s 
    for s = 1:m
        % Padrao atual
        X = S(s,1:end-1);
        % Armazena uma quantidade maior de vizinhos para a fase de busca 
        % pelo outro vizinho mais proximo
        neighbors = KNN(X,S,k+25);
        Neighbors(s).neighbors = neighbors;
        
        % Adiciona s as listas de associados de seus vizinhos
        for n = neighbors(1:k)'
            Associates(n).associates = [Associates(n).associates; s];
        end
    end
    
    % Threshold assignment
    % Calcula as distancias dos padroes para seus inimigos mais proximos
    Thetas = zeros(m,1);
    for i = 1:size(Thetas,1)
        X = S(i,1:end-1);
        class = S(i,end);
        [~, distance] = NE(X,T,class);
        Thetas(i) = distance;
    end
    
    % Ordenando pelas distancias NE
    indexes = (1:m)';
    temp = [indexes,S,Thetas];
    temp = sortrows(temp,-size(temp,2));
    
    % Indices dos exemplos de S ordenados
    order = temp(:,1)';
    % Marca quem de S deverá ser removido
    marked = zeros(m,1);
    
    % Conjunto final de prototipos
    P = [];
    
    for s = order
        % Lista de associados de s
        associates = Associates(s).associates;
        if(~isempty(associates))
            x = 0; y = 0;
            % Para cada associado verifica se a presença de s piora ou 
            % mantem a capacidade de classificação
            for a =  associates'
                neighbors = Neighbors(a).neighbors(1:k+1);
                % k vizinhos mais proximos
                neighbor_classes = S(neighbors(1:k),end);
                
                % Contabiliza se classificou corretamente
                class = class_max(neighbor_classes);
                if (S(a,end) == class)
                    x = x + 1;
                end
                
                % k vizinhos mais proximos retirando s
                neighbors = neighbors(neighbors ~= s);
                neighbor_classes = S(neighbors,end);
                
                % Contabiliza se classificou erroneamente
                class = class_max(neighbor_classes);
                if (S(a,end) == class)
                    y = y + 1;
                end    
            end
            % Caso piore ou mantenha a classificacao, remove s
            if(y - x) >= 0
                marked(s) = 1;
            end
        end
        % Se estiver marcado para remocao
        if(marked(s))
            for a = associates'
                % Retira s da lista de vizinhos de seus associados
                neighbors = Neighbors(a).neighbors;
                neighbors = neighbors(s ~= neighbors);
                Neighbors(a).neighbors = neighbors;
                
                % Procura pelo proximo vizinho mais proximo e poe o
                % associado a em sua respectiva lista de associados
                new_neighbor = neighbors(k);
                associates = Associates(new_neighbor).associates;
                Associates(new_neighbor).associates = [associates; a];
            end
            
            % Remove s da lista de associados de seus vizinhos
            s_neighbors = Neighbors(s).neighbors(1:k);
            for n = s_neighbors'
                associates = Associates(n).associates;
                Associates(n).associates = associates(s ~= associates);
            end
            
        else
            % Caso não esteja marcado, coloca s no conjunto de prototipos
            P = [P; S(s,:)];
        end
    end
    
    
end

