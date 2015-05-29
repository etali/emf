% accuracy_cos_selected.m
% evaluation function for selected queries
% Author: Yitan Li@USTC
% Email: etali@mail.ustc.edu.cn

function [accuracy] = accuracy_cos_selected(CF, question_mat_filename, selected_q)
	%% accuracy for selected_q
	% max_{D\in data} cos(A-B+C, D)

	%% load data
	% disp('start accuracy evaluation');

	%[words, freq] = explicit_loaddict('word2vec3/dictc.txt');

	% accuracy count
	accuracy_count = 0;
	% normalize
	CFN = full(CF ./(sqrt(sum(CF.*CF, 2))*ones(1,size(CF,2))));
	load(question_mat_filename);
	% disp('end load');
	iqAL = iqAL(selected_q);
	iqBL = iqBL(selected_q);
	iqCL = iqCL(selected_q);
	iqDL = iqDL(selected_q);
	available_count = length(iqDL);

	% disp('start evaluate');
	% iq_queryL = full(CF(iqBL,:) - CF(iqAL,:) + CF(iqCL,:));
	iq_queryL = full(CFN(iqBL,:) - CFN(iqAL,:) + CFN(iqCL,:));
	% normalization = (full(sqrt(sum(iq_queryL.*iq_queryL,2)))*ones(1,size(iq_queryL,2)))';
	cosine = CFN*(iq_queryL'); % ./ normalization
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


