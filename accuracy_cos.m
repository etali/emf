% accuracy_cos.m
% evaluation function
% Author: Yitan Li@USTC
% Email: etali@mail.ustc.edu.cn

function [accuracy] = accuracy_cos(CF, question_mat_filename)
	%% accuracy 
	% not normalize all vector
	% max_{D\in data} cos(A-B+C/norm(A-B+C), D/norm(D))

	%% load data

	% accuracy counta
	accuracy_count = 0;
	% normalizeb
	CFN = full(CF ./(sqrt(sum(CF.*CF, 2))*ones(1,size(CF,2))));
	% load('./data/questions.mat');
	load(question_mat_filename);
	% disp('end load');

	% disp('start evaluate');
	iq_queryL = full(CFN(iqBL,:) - CFN(iqAL,:) + CFN(iqCL,:));
	normalization = (full(sqrt(sum(iq_queryL.*iq_queryL,2)))*ones(1,size(iq_queryL,2)))';
	cosine = CFN*(iq_queryL' ./ normalization);
	[sort_value, sort_index] = sort(cosine, 1, 'descend');

	% stupid method
	sort_index = sort_index(1:4,:)';
	[hit_index1, hit_index2] = find(sort_index == iqDL*ones(1,4));
	hit_num = 0;
	% disp('start stupid method');
	for pos = 1:size(hit_index1,1)
		hit = 1;
		for posp = 1:(hit_index2(pos)-1)
			temp = sort_index(hit_index1(pos), posp);
			if(temp ~= iqAL(hit_index1(pos)) && temp ~= iqBL(hit_index1(pos)) && temp ~= iqCL(hit_index1(pos)))
				hit = 0;
		    	break;
			end
		end
		hit_num = hit_num + hit;
	end

	% hit_num = sum(sum(sort_index(1:3,:)' == iqDL*ones(1,3)));
	accuracy = hit_num*100.0/available_count;
	disp(['accuracy:', num2str(accuracy), '%', '(',num2str(hit_num),'/',num2str(available_count),')']);

end


