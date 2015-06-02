
% IMPORTACAO E PRE-PROCESSAMENTO DOS DADOS
clear all;

importIris;
%importWine;
%importZoo;
%importSonar;

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

% Variacao de Teta
TETAS = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1];
% Taxas de acerto para valor de teta de cada fold
TETAResults = zeros(10,10);
% Taxas balanceadas de erro para cada valor de teta de cada fold
BERs = zeros(10,10);
% Taxa de reducao para cada valor de teta de cada fold
InstanceReductions = zeros(10,10);

ENN_Results = zeros(10,1);
ENN_IR = zeros(10,1);
ENN_BERs = zeros(10,1);

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
        ranges(j,:) = [(Maxi - Mini), Mini];
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
    
    % Para cada valor de expansao teta
    for TETA = TETAS
        % Gera um conjunto de protótipos pelo IRAHC
        S = IRAHC(trainingSet,TETA);
      
        % Teste do KNN(k=3) sobre o parametro teta atual
        [accuracy,BER] = TestKNN(S,testSet);
        
        % Armazena os diferentes resultados da iteracao atual
        TETAResults(i,TETA == TETAS) =  accuracy;
        
        reduction = ((size(trainingSet,1) - size(S,1)) / size(trainingSet,1)) * 100;
        InstanceReductions(i,TETA == TETAS) = reduction;
        
        BERs(i,TETA == TETAS) = BER;
    end
   
    % ENN
    S = ENN(trainingSet);
    [accuracy,BER] = TestKNN(S,testSet);
    ENN_Results(i) = accuracy;
    reduction = ((size(trainingSet,1) - size(S,1)) / size(trainingSet,1)) * 100;
    ENN_IR(i) = reduction;
    ENN_BERs(i) = BER;
    
end

%% IRAHC RESULTS
disp('IRAHC RESULTS');
% Calcula a taxa de acerto média para cada teta de cada fold
accuracy = mean(TETAResults);

% Calcula a taxa de erro média para cada teta de cada fold
disp('Error Rate');
Errs = 100 - accuracy;
disp('    TETA     ERR');
disp([TETAS',Errs']);

% Calcula a taxa de redução média para cada teta de cada fold
IR = mean(InstanceReductions)';
disp('Reduction Percentage');
disp('    TETA     IR');
disp([TETAS',IR]);

% Calcula a taxa balanceada de erro média para cada teta de cada fold
ber = mean(BERs)';
disp('Balance Error Rate');
disp('    TETA      BER');
disp([TETAS',ber]);


%% ENN RESULTS
disp('');
disp('ENN RESULTS');
accuracy = mean(ENN_Results);
disp('Error Rate');
Errs = 100 - accuracy;
disp(Errs);
disp('Reduction Percentage');
IR = mean(ENN_IR);
disp(IR);
disp('Balance Error Rate');
ber = mean(ENN_BERs);
disp(ber);

%{
:Iris:
    IRAHC (TETA=0.2) => ERR=4; IR=66.3; BER=1.3
    ENN => ERR=4; RI=4.6; BER=0.47

:Zoo:

:Wine:

:Sonar:

%}


