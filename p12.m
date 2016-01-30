clear;
[a, b, c, data] = arffread('./spambase.arff');
tp = 0; % true positive - identified spam
tn = 0; % true negative - identified nonspam
fp = 0; % false positive - nonspam identified as spam
fn = 0; % false negative - spam identified as nonspam
for i = 1 : size(data, 1)
    trdata = [ones(size(data, 1), 1) data];
    tstdata = [ones(1, 1) data(i, :)];
    trdata(i, :) = [];
    X = trdata(:, 1:end-1);
    Y = trdata(:, end);
    alpha = 1e-6;
    beta = zeros(size(data, 2), 1);
    beta_old = beta - alpha * X' * (1./(1+exp(-X*beta))-Y);
    for count = 1 : 25
        beta = beta_old - alpha * X' * (1./(1+exp(-X*beta_old))-Y);
        beta_old = beta;
    end
    pinfer = 1/(1 + exp(-tstdata(1:end-1)*beta));
    if pinfer > 0.5 % identified as positive, spam
        if tstdata(end) == 1 % tp
            tp = tp + 1;
        else % fp
            fp = fp + 1;
        end
    else 
        if tstdata(end) == 1 % fn
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