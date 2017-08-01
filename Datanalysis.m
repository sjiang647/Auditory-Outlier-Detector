% general outlines of autism in 2017
names = {'KPA', 'jm', 'AL'}; 

for i = 1:length(names)
    %% 1. Cleaning data

    % Iteratively call in individual subject data

    % Create a matrix for each data
    celerey{i} =  load(['Auditory_Outlier/' names{i} '/data.mat']);

    % Organize data so that outlier distance accounts for both +/-
    counterbalancing = celerey{i}.subjectData{4};

    % Calculate accuracy
    accuracy = celerey{i}.subjectData{5};

    % Create 'all_data' matrix that combines all data
    all_data = [counterbalancing; accuracy];

    % Apply certain row/column to j_fit to compare
    
    % ??????

    %% 2. Flipping data

    % Since we want to measure % that outlier is higher than mean, we
    % need to flip data for negative values.

        % (Hit = 1) in negative outliers are saying ?lower than mean? so we
    % want to flip that. Vice versa for 0s.

    % So, for negative outlier distances, we want to flip accuracies of 0s
    % to 1s and 1s to 0s

    for j = 1:length(all_data)
        if all_data(1, j) < 0
            all_data(3, j) = 1 - all_data(3, j);
        end
    end

    outlier_diffs = [-16 -14 -10 -6 6 10 14 16];
    accuracy_percentage = zeros(1, 8);
    for j = 1:length(outlier_diffs)
        indices = find(all_data(1,:) == outlier_diffs(j));
        results = all_data(3, indices);
        accuracy_percentage(j) = mean(results);
    end

    %% 3. Calling jfit

    % Make sure j_fit.m is in same folder as your analysis.m
    % Call in j_fit within your analysis.m code

    % ** You do not have to directly make changes on j_fit.m file

    [a_cond1, b_cond1] = j_fit(all_data(1,:)', all_data(3,:)','logistic1',2); 
end
