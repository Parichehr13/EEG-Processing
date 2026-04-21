function run_full_pipeline(include_subject_003)
%RUN_FULL_PIPELINE Run the main EEG workflow in dependency order.
%
% run_full_pipeline() -> includes subject-003 completion
% run_full_pipeline(false) -> skips subject-003 completion

if nargin < 1 || isempty(include_subject_003)
    include_subject_003 = true;
end

fprintf('[PIPELINE] EEG workflow start\n');
run_preprocessing();
run_ica_workflows(include_subject_003);
run_erp_analysis();
run_time_frequency_analysis();
fprintf('[PIPELINE] EEG workflow complete\n');
end
