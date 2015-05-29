% w2vsbd.m
% EMF block minimization/maximization
% Author: Yitan Li@USTC
% Email: etali@mail.ustc.edu.cn

% Objective:  min MF(D, C*W)
% Algorithm:
%   While 1
%       while
%          C = C - MFgrad(C);
%       while
%          W = W - MFgrad(D);
%   Until Converge

function w2vsbd(co_mat_filename, question_mat_filename, maxiter, ...,
                inner_maxiter, stepsize, k, dim, verbose_acc, save_embedding_vector_filename)
    load(co_mat_filename); % './data/w2vm.mat' load matrix H
    rand('state',2014);
    H = full(w2vmatrix);
    randlist = [];
    [sample_num, context_num] = size(H);
    % load(question_mat_filename); % './data/questions.mat'
    % allquery = length(iqAL);
    D = H';

    % set hyper-parameters
    % maxiter = 200;
    % inner_maxiter = 50;
    % stepsize = 6e-7;
    % k = 6;
    % dim = 200;
    eff = 1/k;
    % verbose_stats = 1;
    % verbose_acc = 5;

    % construct Q
    Qw = sum(H, 2);
    Pw = Qw/sum(Qw);
    weight = 1./Qw;
    weight = weight/max(weight);
    Qc = sum(H, 1);
    prob_Qc = Qc/sum(Qc);
    Qnum = sum(sum(H));
    Qtemp = Qw*Qc./(eff*Qnum);
    Q = Qtemp + H;

    % random initialize
    W = (rand(dim, sample_num) - 0.5)/dim/200;
    C = (rand(context_num, dim) - 0.5)/dim;
    accuracy_list = [];
    err_list = [];

    for iter = 1:maxiter
        W_last = W;
        C_last = C;
        if mod(iter,2)
            % disp('descent W');
            for inner_iter = 1:inner_maxiter
                ED = Q'.*(1./(1 + exp(-C*W)));
                recons = D - ED;
                W_grad = C'*recons;
                W = W + stepsize*W_grad;
            end
        else
            % disp('descent C');
            for inner_iter = 1:inner_maxiter
                ED = Q'.*(1./(1 + exp(-C*W)));
                recons = D - ED;
                C_grad = recons*W';
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
            % disp(['epoch:', num2str(iter),',err:', num2str(err), ',W:', num2str(W_reg_fro), ...
            % ',Wdiff:', num2str(W_diff), ',C:', num2str(C_reg_fro), ',Cdiff:', num2str(C_diff) ...
            %  ',stepsize:', num2str(stepsize)]);
            disp(['epoch:', num2str(iter),',err:', num2str(err), ',W:', num2str(W_reg_fro), ...,
             ',C:', num2str(C_reg_fro), ',stepsize:', num2str(stepsize)]);
        end

        if 0 == mod(iter, verbose_acc)
            accuracy = accuracy_cos(W', question_mat_filename);
            accuracy_list = [accuracy_list accuracy];
        end
    end
    C = C'; % transform C, so that the C is consistent with the C in our paper
    save(save_embedding_vector_filename, 'W', 'C');
end
