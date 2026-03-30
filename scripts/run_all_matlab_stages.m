function run_all_matlab_stages(include_sub003)
%RUN_ALL_MATLAB_STAGES Run Stages 01-04 in dependency order.
%
% run_all_matlab_stages() -> includes sub-003 branch in Stage 02E
% run_all_matlab_stages(false) -> skip sub-003 branch in Stage 02E

if nargin < 1 || isempty(include_sub003)
    include_sub003 = true;
end

fprintf('[PIPELINE] MATLAB stages start\n');
run_stage01();
run_stage02(include_sub003);
run_stage03();
run_stage04();
fprintf('[PIPELINE] MATLAB stages complete\n');
end
