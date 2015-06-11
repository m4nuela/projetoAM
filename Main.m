
% IMPORTACAO E PRE-PROCESSAMENTO DOS DADOS
clear all;

%ESCOLHA DA BASE DE DADOS
repetirLacoBase=1;
while repetirLacoBase
    escolha = input('Escolha a base de dados \n 0 - Iris \n 1 - Zoo \n 2 - Wine \n 3 - Sonar \n 4 - Glass \n 5 - Liver \n 6 - Ecoli \n 7 - Ionosphere \n 8 - PenDigits \n 9 - wdbc \n 10 - Heart \n 11 - Vehicle \n 12 - Yeast \n');
    if(escolha == 0)
        repetirLacoBase = 0;
        importIris;
        dataBaseName = 'Iris';
    elseif (escolha == 1)
        repetirLacoBase = 0;
        importZoo;
        dataBaseName = 'Zoo';
    elseif (escolha == 2)
        repetirLacoBase = 0;
        importWine;
        dataBaseName = 'Wine'; 
    elseif (escolha == 3)
        repetirLacoBase = 0;
        importSonar;
        dataBaseName = 'Sonar';
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
     elseif (escolha == 12)
        repetirLacoBase = 0;
        importYeast;
        dataBaseName = 'Yeast';
    end  
end


[m,n] = size(data);

% K-FOLD CROSS VALIDATION
k = 10;
kFolds = kFoldCrossValidation(data,k);

% DIVISAO DOS DADOS ANTIGA
%{
% Desordenando a base e criando os conjuntos de treinamento e teste (70% 
% e 30% de toda base importada, respectivamente).
mixedRows = data(randperm(m),:);

trainingSet = mixedRows(1:floor(m*0.7),:);
testSet = mixedRows(ceil(m*0.7):end,:);
%}

% Variacao de THETA
THETAS = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1];
% Taxas de acerto para valor de THETA de cada fold
TETAResults = zeros(10,10);
% Taxas balanceadas de erro para cada valor de THETA de cada fold
BERs = zeros(10,10);
% Taxa de reducao para cada valor de THETA de cada fold
InstanceReductions = zeros(10,10);

%tempo de computação do algoritmo IRAHC com TETHA escolhido
tempoI = 0;

ENN_Results = zeros(10,1);
ENN_IR = zeros(10,1);
ENN_BERs = zeros(10,1);
ENN_Time = 0;

ATISA2_Results = zeros(10,1);
ATISA2_IR = zeros(10,1);
ATISA2_BERs = zeros(10,1);
ATISA2_Time = 0;

DROP3_Results = zeros(10,1);
DROP3_IR = zeros(10,1);
DROP3_BERs = zeros(10,1);
DROP3_Time = 0;

% Para todas as K configurações de conjuntos (folds)
folds = 1:k;
for i = folds
    % Conjunto de treinamento será formado por todos os folds restantes
    trainingSet = [];
    for j = folds(folds~=i)
        trainingSet = [trainingSet ; kFolds(j).fold];
    end
    % Desordenando o conjunto de treinamento 
    trainingSet = trainingSet(randperm(size(trainingSet,1)),:);
    
    % Calcula o range pra cada coluna do conjunto de treinamento
    ranges = zeros((size(trainingSet,2)-1),2);
    for j = 1:(size(trainingSet,2)-1)
        Maxi = max(trainingSet(:,j));
        Mini = min(trainingSet(:,j));
        range = Maxi-Mini;
        if (Maxi-Mini)==0
            range = Maxi;
            if range == 0
                ranges(j,:) = [1, 0];
            else
                ranges(j,:) = [range, 0];
            end
        else
            ranges(j,:) = [range, Mini];
        end
        
    end
    
    % Normaliza o conjunto de treinamento
    for j = 1:size(trainingSet,2)-1
        trainingSet(:,j) = (trainingSet(:,j) - ranges(j,2))/ranges(j,1);
    end
    
    % Conjunto de teste será o i-ésimo fold
    testSet = kFolds(i).fold;
    
    % Normaliza o conjunto de teste
    for j = 1:size(testSet,2)-1
        testSet(:,j) = (testSet(:,j) - ranges(j,2))/ranges(j,1);
    end
    
    % ALGORITMO PROPOSTO
    
    % Para cada valor de expansao THETA
    for THETA = THETAS
        % Gera um conjunto de protótipos pelo IRAHC
        if THETA == 0.2
            tic
             S = IRAHC(trainingSet,THETA);
            tempoI = tempoI + toc;
        else
             S = IRAHC(trainingSet,THETA);
        end
      
        % Teste do KNN(k=3) sobre o parametro THETA atual
        [accuracy,BER] = TestKNN(S,testSet);
        
        % Armazena os diferentes resultados da iteracao atual
        TETAResults(i,THETA == THETAS) =  accuracy;
        
        reduction = ((size(trainingSet,1) - size(S,1)) / size(trainingSet,1)) * 100;
        InstanceReductions(i,THETA == THETAS) = reduction;
        
        BERs(i,THETA == THETAS) = BER;
    end
   
    % ENN
    tic
    S = ENN(trainingSet);
    ENN_Time = ENN_Time + toc;
    [accuracy,BER] = TestKNN(S,testSet);
    ENN_Results(i) = accuracy;
    reduction = ((size(trainingSet,1) - size(S,1)) / size(trainingSet,1)) * 100;
    ENN_IR(i) = reduction;
    ENN_BERs(i) = BER;
    
    % ATISA2
    tic
    S = ATISA2(trainingSet);
    ATISA2_Time = ATISA2_Time + toc;
    [accuracy,BER] = TestKNN(S,testSet);
    ATISA2_Results(i) = accuracy;
    reduction = ((size(trainingSet,1) - size(S,1)) / size(trainingSet,1)) * 100;
    ATISA2_IR(i) = reduction;
    ATISA2_BERs(i) = BER;
    
    % DROP3
    tic
    S = drop3(trainingSet);
    DROP3_Time = DROP3_Time + toc;
    [accuracy,BER] = TestKNN(S,testSet);
    DROP3_Results(i) = accuracy;
    reduction = ((size(trainingSet,1) - size(S,1)) / size(trainingSet,1)) * 100;
    DROP3_IR(i) = reduction;
    DROP3_BERs(i) = BER;
end


disp(dataBaseName);

% IRAHC RESULTS
disp('IRAHC RESULTS');
% Calcula a taxa de acerto média para cada THETA de cada fold
accuracy = mean(TETAResults);

% Calcula a taxa de erro média para cada THETA de cada fold
disp('Error Rate');
Errs = 100 - accuracy;
disp('    THETA     ERR');
disp([THETAS',Errs']);

% Calcula a taxa de redução média para cada THETA de cada fold
R = mean(InstanceReductions)';
disp('Reduction Percentage');
disp('    THETA     R');
disp([THETAS',R]);

disp('melhor teta tem maior');
disp([THETAS',(R./Errs')]);

% Calcula a taxa balanceada de erro média para cada THETA de cada fold
ber = mean(BERs)';
disp('Balance Error Rate');
disp('    THETA      BER');
disp([THETAS',ber]);

disp('Average computation time')
disp(tempoI/10);


% ENN RESULTS
disp('');
disp('ENN RESULTS');
accuracy = mean(ENN_Results);
disp('Error Rate');
Errs = 100 - accuracy;
disp(Errs);
disp('Reduction Percentage');
R = mean(ENN_IR);
disp(R);
disp('Balance Error Rate');
ber = mean(ENN_BERs);
disp(ber);
%disp('Accuracy x Reduction');
%AR = accuracy * R;
%disp(AR);
disp('Average computation time')
disp(ENN_Time/10);

% ATISA2 RESULTS
disp('');
disp('ATISA2 RESULTS');
accuracy = mean(ATISA2_Results);
disp('Error Rate');
Errs = 100 - accuracy;
disp(Errs);
disp('Reduction Percentage');
R = mean(ATISA2_IR);
disp(R);
disp('Balance Error Rate');
ber = mean(ATISA2_BERs);
disp(ber);
%disp('Accuracy x Reduction');
%AR = accuracy * R;
%disp(AR);
disp('Average computation time')
disp(ATISA2_Time/10);

% DROP3 RESULTS
disp('');
disp('DROP3 RESULTS');
accuracy = mean(DROP3_Results);
disp('Error Rate');
Errs = 100 - accuracy;
disp(Errs);
disp('Reduction Percentage');
R = mean(DROP3_IR);
disp(R);
disp('Balance Error Rate');
ber = mean(DROP3_BERs);
disp(ber);
%disp('Accuracy x Reduction');
%AR = accuracy * R;
%disp(AR);
disp('Average computation time')
disp(DROP3_Time/10);

