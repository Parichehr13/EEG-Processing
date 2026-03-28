function export_exercise8_by_point(dpi)
%EXPORT_EXERCISE8_BY_POINT Run Exercise 8a/8b section-by-section and save figures.

if nargin < 1 || isempty(dpi)
    dpi = 600;
end

this_file = mfilename('fullpath');
repo_root = fileparts(fileparts(this_file));
ex_dir = fullfile(repo_root, 'exercise8');
fig_dir = fullfile(ex_dir, 'figures');

if ~exist(fig_dir, 'dir')
    mkdir(fig_dir);
end

% Add EEGLAB if available (needed by topoplot).
eeglab_candidates = {
    'D:\Eeg signal\programing\eeglab2024.1', ...
    fullfile(getenv('USERPROFILE'), 'Documents', 'MATLAB', 'eeglab2024.1'), ...
    fullfile(getenv('USERPROFILE'), 'Documents', 'MATLAB', 'eeglab2021.1')
};
for i = 1:numel(eeglab_candidates)
    root = eeglab_candidates{i};
    if isfile(fullfile(root, 'eeglab.m'))
        addpath(genpath(root));
        fprintf('EEGLAB path added: %s\n', root);
        break;
    end
end

run_script_by_point(ex_dir, fig_dir, 'Exercise8a_Solution.m', 'exercise8a', dpi);
run_script_by_point(ex_dir, fig_dir, 'Exercise8b_Solution.m', 'exercise8b', dpi);

fprintf('Exercise 8 export complete.\n');
end

function run_script_by_point(ex_dir, fig_dir, script_name, prefix_root, dpi)
script_path = fullfile(ex_dir, script_name);
raw = fileread(script_path);
lines = splitlines(raw);

point_idx = [];
point_num = [];
for i = 1:numel(lines)
    tok = regexp(lines{i}, '^\s*%%\s*Exercise\s+8[ab]\s+Point(?:s)?\s+(\d+)', 'tokens', 'once');
    if ~isempty(tok)
        point_idx(end+1) = i; %#ok<AGROW>
        point_num(end+1) = str2double(tok{1}); %#ok<AGROW>
    end
end

if isempty(point_idx)
    error('No Exercise 8 point sections found in %s', script_path);
end

orig_dir = pwd;
cleanup = onCleanup(@() cd(orig_dir)); %#ok<NASGU>
cd(ex_dir);

fprintf('\nRunning %s by point...\n', script_name);
for k = 1:numel(point_idx)
    p = point_num(k);
    s = point_idx(k);
    if k < numel(point_idx)
        e = point_idx(k+1) - 1;
    else
        e = numel(lines);
    end

    code = strjoin(lines(s:e), newline);

    before = findall(groot, 'Type', 'figure');
    marker = sprintf('pre_%s_%d_%d', prefix_root, p, k);
    for b = 1:numel(before)
        if isgraphics(before(b), 'figure')
            setappdata(before(b), marker, true);
        end
    end

    fprintf('[%s Point %d] Running lines %d-%d\n', prefix_root, p, s, e);
    evalin('base', code);

    after = findall(groot, 'Type', 'figure');
    new_figs = gobjects(0);
    for a = 1:numel(after)
        if ~isappdata(after(a), marker)
            new_figs(end+1) = after(a); %#ok<AGROW>
        end
    end

    if ~isempty(new_figs)
        [~, ord] = sort(arrayfun(@(h) h.Number, new_figs));
        new_figs = new_figs(ord);
    end

    prefix = sprintf('%s_p%02d', prefix_root, p);
    old = dir(fullfile(fig_dir, sprintf('%s_fig_*.png', prefix)));
    for j = 1:numel(old)
        delete(fullfile(old(j).folder, old(j).name));
    end

    saved = cell(1, numel(new_figs));
    for j = 1:numel(new_figs)
        name = sprintf('%s_fig_%03d.png', prefix, j);
        outp = fullfile(fig_dir, name);
        saved{j} = name;
        prepare_figure_for_export(new_figs(j));
        try
            exportgraphics(new_figs(j), outp, 'Resolution', dpi);
        catch
            print(new_figs(j), outp, '-dpng', sprintf('-r%d', dpi));
        end
    end

    manifest = fullfile(fig_dir, sprintf('%s_manifest.json', prefix));
    write_manifest(manifest, saved);
    fprintf('[%s Point %d] Saved %d new figure(s).\n', prefix_root, p, numel(saved));
end
end

function prepare_figure_for_export(fig)
set(fig, 'Units', 'pixels');
pos = get(fig, 'Position');
pos(3) = max(pos(3), 2200);
pos(4) = max(pos(4), 1400);
set(fig, 'Position', pos);
end

function write_manifest(path, files)
fid = fopen(path, 'w');
if fid < 0
    error('Could not open manifest: %s', path);
end
cleanup = onCleanup(@() fclose(fid)); %#ok<NASGU>

fprintf(fid, '[');
for i = 1:numel(files)
    fprintf(fid, '"%s"', files{i});
    if i < numel(files)
        fprintf(fid, ',');
    end
end
fprintf(fid, ']\n');
end
