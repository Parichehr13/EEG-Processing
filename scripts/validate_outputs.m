function ok = validate_outputs()
%VALIDATE_OUTPUTS Check key expected stage artifacts.
%
% Returns:
%   ok (logical): true if all checked artifacts exist, false otherwise.

repo_root = get_repo_root();

expected = {
    fullfile('01_preprocessing', 'sub-035_PreprocessStep1.mat'); ...
    fullfile('02_artifact_removal_ica', '05_pipeline_completion', 'sub035_pipeline_completion', 'sub-035_PreprocessStep2.mat'); ...
    fullfile('02_artifact_removal_ica', '05_pipeline_completion', 'sub003_pipeline_completion', 'sub-003_PreprocessStep2.mat'); ...
    fullfile('03_erp_analysis', 'figures', 'stage03a_p05_fig_001.png'); ...
    fullfile('03_erp_analysis', 'figures', 'stage03b_p03_fig_001.png'); ...
    fullfile('04_time_frequency_analysis', 'figures', 'stage04a_sub003_p07_fig_001.png'); ...
    fullfile('04_time_frequency_analysis', 'figures', 'stage04b_p02_fig_001.png'); ...
    fullfile('05_decoding_classification', 'figures', 'stage05_decoding_manifest.json') ...
};

missing = {};
for i = 1:numel(expected)
    rel = expected{i};
    abs_path = fullfile(repo_root, rel);
    if ~isfile(abs_path)
        missing{end+1} = rel; %#ok<AGROW>
    end
end

if isempty(missing)
    fprintf('[VALIDATE] OK: all checked artifacts exist.\n');
    ok = true;
else
    fprintf('[VALIDATE] Missing %d artifact(s):\n', numel(missing));
    for i = 1:numel(missing)
        fprintf('  - %s\n', missing{i});
    end
    ok = false;
end
end

function repo_root = get_repo_root()
this_file = mfilename('fullpath');
scripts_dir = fileparts(this_file);
repo_root = fileparts(scripts_dir);
end
