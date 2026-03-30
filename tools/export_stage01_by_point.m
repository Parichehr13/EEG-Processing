function export_stage01_by_point(dpi)
%EXPORT_STAGE01_BY_POINT Run Stage 01 section-by-section and save figures.

if nargin < 1 || isempty(dpi)
    dpi = 600;
end

this_file = mfilename('fullpath');
repo_root = fileparts(fileparts(this_file));
script_dir = fullfile(repo_root, '01_preprocessing');
script_path = fullfile(script_dir, 'preprocessing_pipeline.m');
fig_dir = fullfile(script_dir, 'figures');

if ~exist(fig_dir, 'dir')
    mkdir(fig_dir);
end

raw = fileread(script_path);
lines = splitlines(raw);

point_idx = [];
point_num = [];
for i = 1:numel(lines)
    tok = regexp(lines{i}, '^%%\s*Stage 01 Point\s+(\d+)', 'tokens', 'once');
    if ~isempty(tok)
        point_idx(end+1) = i; %#ok<AGROW>
        point_num(end+1) = str2double(tok{1}); %#ok<AGROW>
    end
end

if isempty(point_idx)
    error('No "Stage 01 Point" sections found in %s', script_path);
end

orig_dir = pwd;
cleanup = onCleanup(@() cd(orig_dir));
cd(script_dir);

fprintf('Running Stage 01 by point from: %s\n', script_path);

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
    marker = sprintf('pre_section_%d_%d', p, k);
    for b = 1:numel(before)
        if isgraphics(before(b), 'figure')
            setappdata(before(b), marker, true);
        end
    end

    fprintf('[Point %d] Running lines %d-%d\n', p, s, e);
    evalin('base', code);

    after = findall(groot, 'Type', 'figure');
    new_figs = gobjects(0);
    for a = 1:numel(after)
        if ~isappdata(after(a), marker)
            new_figs(end+1) = after(a); %#ok<AGROW>
        end
    end

    if ~isempty(new_figs)
        [~, order] = sort(arrayfun(@(h) h.Number, new_figs));
        new_figs = new_figs(order);
    end

    prefix = sprintf('stage01_p%02d', p);
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
    fprintf('[Point %d] Saved %d new figure(s).\n', p, numel(saved));
end

fprintf('Done.\n');

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


