
clear all;

% Melhor valor de teta, alterado para cada base
best_teta = 0.2;

%ESCOLHA DA BASE DE DADOS
repetirLacoBase=1;
while repetirLacoBase
    escolha = input('Escolha a base de dados \n 0 - Iris \n 1 - Zoo \n 2 - Wine \n 3 - Sonar \n 4 - Glass \n 5 - Liver \n 6 - Ecoli \n 7 - Ionosphere \n 8 - PenDigits \n 9 - wdbc \n 10 - Heart \n 11 - Vehicle \n 12 - Yeast \n');
    if(escolha == 0)
        repetirLacoBase = 0;
        importIris;
        dataBaseName = 'Iris';
        best_teta = 0.1;
    elseif (escolha == 1)
        repetirLacoBase = 0;
        importZoo;
        dataBaseName = 'Zoo';
        best_teta = 0.4;
    elseif (escolha == 2)
        repetirLacoBase = 0;
        importWine;
        dataBaseName = 'Wine';
        best_teta = 0.4;
    elseif (escolha == 3)
        repetirLacoBase = 0;
        importSonar;
        dataBaseName = 'Sonar';
        best_teta = 0.7;
    elseif (escolha == 4)
        repetirLacoBase = 0;
        importGlass;
        dataBaseName = 'Glass'; 
    elseif (escolha == 5)
        repetirLacoBase = 0;
        importLiver;
        dataBaseName = 'Liver';  
    elseif (escolha == 6)
        repetirLacoBase = 0;
        importEcoli;
        dataBaseName = 'Ecoli';
    elseif (escolha == 7)
        repetirLacoBase = 0;
        importIono;
        dataBaseName = 'Ionosphere';
        best_teta = 0.3;
    elseif (escolha == 8)
        repetirLacoBase = 0;
        importPendigits;
        dataBaseName = 'Pendigits';
     elseif (escolha == 9)
        repetirLacoBase = 0;
        importWdbc;
        dataBaseName = 'wdbc';
     elseif (escolha == 10)
        repetirLacoBase = 0;
        importHeart;
        dataBaseName = 'heart';
     elseif (escolha == 11)
        repetirLacoBase = 0;
        importVehicle;
        dataBaseName = 'Vehicle';
        best_teta = 0.2;
     elseif (escolha == 12)
        repetirLacoBase = 0;
        importYeast;
        dataBaseName = 'Yeast';
    end  
end

% IMPORTACAO E PRE-PROCESSAMENTO DOS DADOS
[m,n] = size(data);

% K-FOLD CROSS VALIDATION
k = 10;
kFolds = kFoldCrossValidation(data,k);

% Variacao do parametro de expansao TETA
TETAS = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1];
% Taxas de acerto para valor de TETA de cada fold
IRAHC_Results = zeros(10,10);
% Taxas de erro balanceada para cada valor de TETA de cada fold
IRAHC_BERs = zeros(10,10);
% Taxa de reducao para cada valor de TETA de cada fold
IRAHC_Reductions = zeros(10,10);
% Tempo de computação para cada valor de TETA de cada fold
IRAHC_Times = 0;

% Resultados do ENN para todos os folds
ENN_Results = zeros(10,1);
ENN_Reductions = zeros(10,1);
ENN_BERs = zeros(10,1);
ENN_Time = 0;

% Resultados do ATISA2 para todos os folds
ATISA2_Results = zeros(10,1);
ATISA2_Reductions = zeros(10,1);
ATISA2_BERs = zeros(10,1);
ATISA2_Time = 0;

% Resultados do DROP3 para todos os folds
DROP3_Results = zeros(10,1);
DROP3_Reductions = zeros(10,1);
DROP3_BERs = zeros(10,1);
DROP3_Time = 0;

% Para todas as K configurações de conjuntos de dados(folds)
folds = 1:k;
for i = folds
    % Conjunto de treinamento será formado por todos os folds ~= de i
    trainingSet = [];
    for j = folds(folds~=i)
        trainingSet = [trainingSet ; kFolds(j).fold];
    end
    % Desordenando o conjunto de treinamento 
    trainingSet = trainingSet(randperm(size(trainingSet,1)),:);
    
    % Calcula o range e valor minimo pra cada coluna do conjunto de treinamento
    ranges = zeros((size(trainingSet,2)-1),2);
    for j = 1:(size(trainingSet,2)-1)
        Maxi = max(trainingSet(:,j));
        Mini = min(trainingSet(:,j));
        range = Maxi-Mini;
        if ((Maxi-Mini) == 0)
            range = Maxi;
            if (range == 0)
                ranges(j,:) = [1, 0];
            else
                ranges(j,:) = [range, 0];
            end
        else
            ranges(j,:) = [range, Mini];
        end
        
    end
    
    % Normaliza o conjunto de treinamento ((X - MIN) / (MAX-MIN))
    for j = 1:size(trainingSet,2)-1
        trainingSet(:,j) = (trainingSet(:,j) - ranges(j,2))/ranges(j,1);
    end
    
    % Conjunto de teste será o i-ésimo fold
    testSet = kFolds(i).fold;
    
    % Normaliza o conjunto de teste
    for j = 1:size(testSet,2)-1
        testSet(:,j) = (testSet(:,j) - ranges(j,2))/ranges(j,1);
    end
    
    % ALGORITMO PROPOSTO - IRAHC
    
    % Para cada valor de expansao TETA
    for TETA = TETAS
        % Gera um conjunto de protótipos pelo IRAHC
        
        % Calcula o tempo para o teta escolhido
        if TETA == best_teta
            tic
            S = IRAHC(trainingSet,TETA);
            IRAHC_Times = IRAHC_Times + toc;
        else
             S = IRAHC(trainingSet,TETA);
        end
      
        % Teste do KNN(k=3) sobre o parametro TETA atual
        [accuracy,BER] = TestKNN(S,testSet);
        
        % Armazena os diferentes resultados da iteracao atual
        IRAHC_Results(i,TETA == TETAS) =  accuracy;
        
        reduction = ((size(trainingSet,1) - size(S,1)) / size(trainingSet,1)) * 100;
        IRAHC_Reductions(i,TETA == TETAS) = reduction;
        
        IRAHC_BERs(i,TETA == TETAS) = BER;
    end
   
    % Armazena o desempenho dos algoritmos concorrentes
    
    % ENN
    tic
    S = ENN(trainingSet);
    ENN_Time = ENN_Time + toc;
    [accuracy,BER] = TestKNN(S,testSet);
    ENN_Results(i) = accuracy;
    reduction = ((size(trainingSet,1) - size(S,1)) / size(trainingSet,1)) * 100;
    ENN_Reductions(i) = reduction;
    ENN_BERs(i) = BER;
    
    % ATISA2
    tic
    S = ATISA2(trainingSet);
    ATISA2_Time = ATISA2_Time + toc;
    [accuracy,BER] = TestKNN(S,testSet);
    ATISA2_Results(i) = accuracy;
    reduction = ((size(trainingSet,1) - size(S,1)) / size(trainingSet,1)) * 100;
    ATISA2_Reductions(i) = reduction;
    ATISA2_BERs(i) = BER;
    
    % DROP3
    tic
    S = drop3(trainingSet);
    DROP3_Time = DROP3_Time + toc;
    [accuracy,BER] = TestKNN(S,testSet);
    DROP3_Results(i) = accuracy;
    reduction = ((size(trainingSet,1) - size(S,1)) / size(trainingSet,1)) * 100;
    DROP3_Reductions(i) = reduction;
    DROP3_BERs(i) = BER;
end


disp(dataBaseName);

% IRAHC RESULTS
disp('IRAHC RESULTS');
% Calcula a taxa de acerto média para cada TETA
accuracy = mean(IRAHC_Results);

% Calcula a taxa de erro média para cada TETA
disp('Error Rate');
Errs = 100 - accuracy;
disp('    TETA     ERR');
disp([TETAS',Errs']);

% Calcula a taxa de redução média para cada TETA
R = mean(IRAHC_Reductions)';
disp('Reduction Percentage');
disp('    TETA     R');
disp([TETAS',R]);

disp('Razao entre R e Err');
disp([TETAS',(R./Errs')]);

% Calcula a taxa de erro balanceada média para cada TETA
ber = mean(IRAHC_BERs)';
disp('Balance Error Rate');
disp('    TETA      BER');
disp([TETAS',ber]);

% Calcula o tempo de computacao médio do teta escolhido
disp('Average computation time')
disp(IRAHC_Times/10);


% ENN RESULTS
disp('');
disp('ENN RESULTS');
accuracy = mean(ENN_Results);
disp('Error Rate');
Errs = 100 - accuracy;
disp(Errs);
disp('Reduction Percentage');
R = mean(ENN_Reductions);
disp(R);
disp('Balance Error Rate');
ber = mean(ENN_BERs);
disp(ber);
disp('Average Computation Time');
disp(ENN_Time/10);

% ATISA2 RESULTS
disp('');
disp('ATISA2 RESULTS');
accuracy = mean(ATISA2_Results);
disp('Error Rate');
Errs = 100 - accuracy;
disp(Errs);
disp('Reduction Percentage');
R = mean(ATISA2_Reductions);
disp(R);
disp('Balance Error Rate');
ber = mean(ATISA2_BERs);
disp(ber);
%disp('Accuracy x Reduction');
%AR = accuracy * R;
%disp(AR);
disp('Average Computation Time');
disp(ATISA2_Time/10);

% DROP3 RESULTS
disp('');
disp('DROP3 RESULTS');
accuracy = mean(DROP3_Results);
disp('Error Rate');
Errs = 100 - accuracy;
disp(Errs);
disp('Reduction Percentage');
R = mean(DROP3_Reductions);
disp(R);
disp('Balance Error Rate');
ber = mean(DROP3_BERs);
disp(ber);
disp('Average Computation Time');
disp(DROP3_Time/10);

