clear all 


names = {'KPA','jm','AL'};


for person = 1:length(names)
    cd('Auditory_Outlier');
    cd(names{person})
    load('data.mat');
    outlier_dist = responseArray(1).outlierDistance;



    all_accuracy = responseArray(1).accuracy;

    data_new = vertcat(outlier_dist,all_accuracy);
    data_new = horzcat(outlier_dist', all_accuracy');
    data_cmp = data_new;
    for i = 1:280
        if data_new(i, 1) < 0 
            data_new(i, 2) = abs(data_new(i, 2)-1);
        end
    end

    cd ../..


    [a_cond1, b_cond1] = j_fit(data_new(:, 1), data_new(:, 2),'logistic1',2);
end

 