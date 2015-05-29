% w2vsbdsup.m
% SEMF block minimization/maximization
% Author: Yitan Li@USTC
% Email: etali@mail.ustc.edu.cn

% Objective:  min MF(D, C*W) + \lambda MF(Dq, C*W*T)
function w2vsbdsup(co_mat_filename, question_mat_filename, maxiter, ...
                   inner_maxiter, stepsize, k, dim, lambda, ques_sampling, ...
                   verbose_acc, save_embedding_vector_filename)

% load('./data/w2vm.mat'); % load matrix H, each row of H is a explicit d
    load(co_mat_filename);
    rand('state',2014);
    H = full(w2vmatrix);
    % H = H(:,1:100);
    % sampling
    randlist = [];
    [sample_num, context_num] = size(H);
    % end sampling

    D = H';

    % set hyper-parameters
    % maxiter = 100;
    % inner_maxiter = 50;
    % stepsize = 0.0000005; %0.00005

    % k = 4;
    % dim = 200;
    eff = 1/k; %2.5
    % verbose_acc = 5;
    % lambda = 0.05;
    % ques_sampling = 0.7;

    % construct Q
    Qw = sum(H, 2);
    Pw = Qw/sum(Qw);
    weight = 1./Qw;
    weight = weight/max(weight);
    Qc = sum(H, 1);
    prob_Qc = Qc/sum(Qc);
    Qnum = sum(sum(H));

    Qtemp = Qw*Qc/(eff*Qnum); % k * 
    Q = Qtemp + H;

    disp('start construct T');
    load(question_mat_filename); %iqAL, iqBL, iqCL, iqDL
    query_num = length(iqAL);
    query_sample_num = round(ques_sampling*query_num);
    reorder = randperm(query_num);
    partial_reorder = reorder(1:query_sample_num);
    remaining_reorder = reorder((query_sample_num+1):end);
    partial_iqDL = iqDL(partial_reorder);
    Dq = D(:, partial_iqDL);
    T = zeros(sample_num, query_sample_num);
    for queryi = 1:query_sample_num
        queryi_idx = partial_reorder(queryi);
        T(iqAL(queryi_idx),queryi) = -1; 
        T(iqBL(queryi_idx),queryi) = 1;
        T(iqCL(queryi_idx),queryi) = 1;
    end
    T = sparse(T);
    disp(['end construct T, ', 'qnum:', num2str(length(reorder)),', sqnum:', num2str(length(partial_reorder))]);

    W = (rand(dim, sample_num) - 0.5)/dim;
    C = (rand(context_num, dim) - 0.5)/dim;

    accuracy_list = [];
    accuracy_train_list = [];
    accuracy_test_list = [];
    err_list = [];
    Obj_list = [];

    Wcount = 0;
    Ccount = 0;
    for iter = 1:maxiter
        W_last = W;
        C_last = C;
        if mod(iter,2)
            Wcount = Wcount + 1;
            % disp('descent W');
            for inner_iter = 1:inner_maxiter
                ED = Q'.*(1./(1 + exp(-C*W)));
                recons = D - ED;
                W_grad = C'*(recons + lambda*(Dq - ED(:,partial_iqDL))*T');
                W = W + stepsize*W_grad;
            end
        else
            Ccount = Ccount + 1;
            % disp('descent C');
            for inner_iter = 1:inner_maxiter
                ED = Q'.*(1./(1 + exp(-C*W)));
                recons = D - ED;
                C_grad = (recons + lambda*(Dq - ED(:,partial_iqDL))*T')*W';
                C = C + stepsize*C_grad;
            end
        end

        if 0 == mod(iter, verbose_acc)
            err = norm(recons, 'fro');
            err_list = [err_list err];
            W_reg_fro = norm(W, 'fro')/sample_num;
            C_reg_fro = norm(C, 'fro')/sample_num;
            % W_diff = norm(W - W_last, 'fro');
            % C_diff = norm(C - C_last, 'fro');
            % Prob = 1./(1 + exp(-C*W));
            % Obj = sum(sum(H.*log(Prob') + Qtemp.*log(1 - Prob')));
            % Obj_list = [Obj_list Obj];
            % disp(['ratio:',num2str(ques_sampling), ',lambda:', num2str(lambda), ',epoch:', num2str(iter), ',Obj:', num2str(Obj),',err:', num2str(err), ',W:', num2str(W_reg_fro), ...
            % ',Wdiff:', num2str(W_diff), ',C:', num2str(C_reg_fro), ',Cdiff:', num2str(C_diff) ...
            %  ',stepsize:', num2str(stepsize)]);
            disp([',epoch:', num2str(iter), 'ratio:',num2str(ques_sampling), ',lambda:', num2str(lambda), ...,
                ',err:', num2str(err), ',W:', num2str(W_reg_fro), ...,
                ',C:', num2str(C_reg_fro), ',stepsize:', num2str(stepsize)]);
        end
        if 0 == mod(iter, verbose_acc)
            % accuracy = accuracy_cos_selected(W', reorder);
            % accuracy_list = [accuracy_list accuracy];

            % Training error
            % accuracy = accuracy_cos_selected(W', partial_reorder);
            % accuracy_train_list = [accuracy_train_list accuracy];

            % Test error
            accuracy = accuracy_cos_selected(W', question_mat_filename, remaining_reorder);
            accuracy_test_list = [accuracy_test_list accuracy];
        end
    end
    C = C'; % transform C, so that the C is consistent with the C in our paper
    save(save_embedding_vector_filename, 'W', 'C');
end

