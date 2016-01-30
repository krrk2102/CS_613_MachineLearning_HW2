clear;
[a, b, c, data] = arffread('./spambase.arff');
tp = 0; % true positive - identified spam
tn = 0; % true negative - identified nonspam
fp = 0; % false positive - nonspam identified as spam
fn = 0; % false negative - spam identified as nonspam
for i = 1 : size(data, 1)
    trdata = data;
    tstdata = data(i, 1:end-1);
    trdata(i, :) = [];
    Cond1 = trdata(:, end) == 0;
    Cond2 = trdata(:, end) == 1;
    trnonspam = trdata(Cond1, 1:end-1);
    trspam = trdata(Cond2, 1:end-1);
    pspam = size(trspam, 1) / size(trdata, 1);
    pnonspam = size(trnonspam, 1) / size(trdata, 1);
    unonspam = mean(trnonspam);
    varnonspam = var(trnonspam);
    uspam = mean(trspam);
    varspam = var(trspam);
    ppositive = 1; % regard as spam
    pnegative = 1;
    for j = 1 : size(tstdata, 2)
        ppositive = ppositive * 1/sqrt(2*pi*varspam(j))*exp(-(tstdata(j)-uspam(j))^2/(2*varspam(j)));
        pnegative = pnegative * 1/sqrt(2*pi*varnonspam(j))*exp(-(tstdata(j)-unonspam(j))^2/(2*varnonspam(j)));
    end
    pinfer = ppositive * pspam / (ppositive*pspam + pnegative*pnonspam);
    if pinfer > 0.5 % identified as positive, spam
        if data(i, end) == 1 % tp
            tp = tp + 1;
        else % fp
            fp = fp + 1;
        end
    else 
        if data(i, end) == 1 % fn
            fn = fn + 1;
        else % tn
            tn = tn + 1;
        end
    end
end
precision = tp / (tp + fp);
display(precision);
recall = tp / (tp + fn);
display(recall);
fmeasure = 2*precision*recall / (precision + recall);
display(fmeasure);
accuracy = (tp + tn) / (tp + tn + fp + fn);
display(accuracy);