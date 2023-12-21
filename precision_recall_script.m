confidence_scores = [1, 0.95, 0.9, 0.95, 0.85, 0.8, 0.75, 0.70, 0.65, 0.60, 0.55, 0.50];

data_4 = [
    69.10714286	9.116565303	30.89285714	90.0900665;
    82.61904762	13.84813565	17.38095238	85.35849615;
    89.28571429	17.84956879	10.71428571	81.35706301;
    89.28571429	19.90474494	10.71428571	79.30188686;
    89.28571429	20.95038111	10.71428571	78.25625069;
    89.28571429	21.39030611	10.71428571	77.81632569;
    91.36904762	27.62782488	8.630952381	71.57880692;
    91.36904762	29.19114196	8.630952381	70.01548984;
    91.36904762	31.26663971	8.630952381	67.93999209;
    91.36904762	33.62628464	8.630952381	65.58034716;
    91.36904762	36.02397873	8.630952381	63.18265307
];

data_3 = [
    45.81766917	19.80762102	19.6976817	77.16328192;
    51.32362155	24.79608581	14.19172932	72.17481713;
    53.40695489	28.76953982	12.10839599	68.20136311;
    56.20300752	30.54109186	9.312343358	66.42981108;
    56.20300752	31.57649025	9.312343358	65.39441268;
    56.20300752	31.92747031	9.312343358	65.04343262;
    56.20300752	34.43441942	9.312343358	62.53648352;
    56.20300752	35.01777951	9.312343358	61.95312342;
    59.71177945	42.42403964	5.803571429	54.5468633;
    63.1343985	51.47641278	2.380952381	45.49449015;
    63.1343985	54.01510359	2.380952381	42.95579934
];

data_2 = [
    73.14102564	8.983333119	26.85897436	89.93607569;
    77.30769231	14.13068943	22.69230769	84.78871938;
    77.30769231	18.55897658	22.69230769	80.36043223;
    77.30769231	20.43868324	22.69230769	78.48072557;
    79.87179487	21.53982472	20.12820513	77.37958409;
    79.87179487	21.90466836	20.12820513	77.01474046;
    84.03846154	27.61545968	15.96153846	71.30394914;
    84.03846154	29.17193843	15.96153846	69.74747039;
    84.03846154	29.83735579	15.96153846	69.08205302;
    90.76923077	30.27284092	9.230769231	68.64656789;
    97.43589744	33.19475198	2.564102564	65.72465683
];

data_1 = [
    15.34090909	2.436914388	84.65909091	97.50019253;
    49.24242424	8.226021283	50.75757576	91.71108563;
    60.03787879	11.50391769	39.96212121	88.43318923;
    60.03787879	12.66661124	39.96212121	87.27049568;
    60.03787879	13.81252261	39.96212121	86.12458431;
    60.03787879	14.038681	39.96212121	85.89842592;
    60.03787879	15.18394768	39.96212121	84.75315924;
    62.31060606	16.09962252	37.68939394	83.83748439;
    66.66666667	16.49572059	33.33333333	83.44138633;
    71.21212121	16.88934578	28.78787879	83.04776114;
    75.75757576	18.57950109	24.24242424	81.35760583
];

data_avg = [
    50.85168669	10.08610846	40.52715103	88.67240416;
    65.12319643	15.25023304	26.25564129	83.50827957;
    70.00956007	19.17050072	21.36927765	79.58801189;
    70.70857323	20.88778282	20.67026449	77.8707298;
    71.34959887	21.96980467	20.02923885	76.78870794;
    71.34959887	22.31528144	20.02923885	76.44323117;
    72.91209887	26.21541291	18.46673885	72.5430997;
    73.48028068	27.37012061	17.89855704	71.38839201;
    75.44648882	30.00593893	15.9323489	68.75257369;
    79.12119952	33.06622103	12.2576382	65.69229158;
    81.92422983	35.45333385	9.454607892	63.30517877
];

% Grab TP TF TN FN from data
grav_true_4 = data_4(:, 1);
unkn_false_4 = data_4(:, 2);
grav_false_4 = data_4(:, 3);
unkn_true_4 = data_4(:, 4);
grav_true_3 = data_3(:, 1);
unkn_false_3 = data_3(:, 2);
grav_false_3 = data_3(:, 3);
unkn_true_3 = data_3(:, 4);
grav_true_2 = data_2(:, 1);
unkn_false_2 = data_2(:, 2);
grav_false_2 = data_2(:, 3);
unkn_true_2 = data_2(:, 4);
grav_true_1 = data_1(:, 1);
grav_false_1 = data_1(:, 2);
unkn_true_1 = data_1(:, 3);
unkn_false_1 = data_1(:, 4);
grav_true_avg = data_avg(:, 1);
grav_false_avg = data_avg(:, 2);
unkn_true_avg = data_avg(:, 3);
unkn_false_avg = data_avg(:, 4);

% Convert percentages to fractions
grav_true_4 = grav_true_4 / 100;
grav_false_4 = grav_false_4 / 100;
unkn_true_4 = unkn_true_4 / 100;
unkn_false_4 = unkn_false_4 / 100;
grav_true_3 = grav_true_3 / 100;
grav_false_3 = grav_false_3 / 100;
unkn_true_3 = unkn_true_3 / 100;
unkn_false_3 = unkn_false_3 / 100;
grav_true_2 = grav_true_2 / 100;
grav_false_2 = grav_false_2 / 100;
unkn_true_2 = unkn_true_2 / 100;
unkn_false_2 = unkn_false_2 / 100;
grav_true_1 = grav_true_1 / 100;
grav_false_1 = grav_false_1 / 100;
unkn_true_1 = unkn_true_1 / 100;
unkn_false_1 = unkn_false_1 / 100;
grav_true_avg = grav_true_avg / 100;
grav_false_avg = grav_false_avg / 100;
unkn_true_avg = unkn_true_avg / 100;
unkn_false_avg = unkn_false_avg / 100;

% Calculate precision and recall for Gravel
precision_gravel_4 = grav_true_4 ./ (grav_true_4 + grav_false_4);
recall_gravel_4 = grav_true_4 ./ (grav_true_4 + unkn_false_4);
precision_gravel_3 = grav_true_3 ./ (grav_true_3 + grav_false_3);
recall_gravel_3 = grav_true_3 ./ (grav_true_3 + unkn_false_3);
precision_gravel_2 = grav_true_2 ./ (grav_true_2 + grav_false_2);
recall_gravel_2 = grav_true_2 ./ (grav_true_2 + unkn_false_2);
precision_gravel_1 = grav_true_1 ./ (grav_true_1 + grav_false_1);
recall_gravel_1 = grav_true_1 ./ (grav_true_1 + unkn_false_1);
precision_gravel_avg = grav_true_avg ./ (grav_true_avg + grav_false_avg);
recall_gravel_avg = grav_true_avg ./ (grav_true_avg + unkn_false_avg);

% Plot the precision-recall curves
figure;
hold all;
plot(recall_gravel_1, precision_gravel_1, '-o', 'DisplayName', 'Run 1');
plot(recall_gravel_2, precision_gravel_2, '-o', 'DisplayName', 'Run 2');
plot(recall_gravel_3, precision_gravel_3, '-o', 'DisplayName', 'Run 3');
plot(recall_gravel_4, precision_gravel_4, '-o', 'DisplayName', 'Run 4');
plot(recall_gravel_avg, precision_gravel_avg, '-o', 'DisplayName', 'Averaged')
xlabel('Recall');
ylabel('Precision');
title('Precision-Recall Curve');
legend('Location', 'best');
text(recall_gravel_4, precision_gravel_4, arrayfun(@(x) sprintf('%.2f', x), confidence_scores, 'UniformOutput', false), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
grid on;

