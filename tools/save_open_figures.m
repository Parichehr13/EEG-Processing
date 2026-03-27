function files = save_open_figures(figures_dir, prefix, max_figures)
%SAVE_OPEN_FIGURES Export currently open MATLAB figures to PNG files.
%   files = SAVE_OPEN_FIGURES(figures_dir, prefix, max_figures)
%   saves open figures as <prefix>_fig_001.png, ... and writes
%   <prefix>_manifest.json in the same folder.

if nargin < 3 || isempty(max_figures)
    max_figures = inf;
end

if ~exist(figures_dir, 'dir')
    mkdir(figures_dir);
end

pattern = fullfile(figures_dir, sprintf('%s_fig_*.png', prefix));
old_files = dir(pattern);
for i = 1:numel(old_files)
    delete(fullfile(old_files(i).folder, old_files(i).name));
end

figs = findall(groot, 'Type', 'figure');
files = {};

if isempty(figs)
    write_manifest(figures_dir, prefix, files);
    return;
end

fig_nums = arrayfun(@(f) f.Number, figs);
[~, order] = sort(fig_nums);
figs = figs(order);

n_save = min(numel(figs), max_figures);
files = cell(1, n_save);

for k = 1:n_save
    name = sprintf('%s_fig_%03d.png', prefix, k);
    out_path = fullfile(figures_dir, name);
    files{k} = name;

    try
        exportgraphics(figs(k), out_path, 'Resolution', 180);
    catch
        saveas(figs(k), out_path);
    end
end

write_manifest(figures_dir, prefix, files);

end

function write_manifest(figures_dir, prefix, files)
manifest_path = fullfile(figures_dir, sprintf('%s_manifest.json', prefix));
fid = fopen(manifest_path, 'w');
if fid < 0
    error('Could not write manifest file: %s', manifest_path);
end
cleanup = onCleanup(@() fclose(fid));

fprintf(fid, '[');
for i = 1:numel(files)
    fprintf(fid, '"%s"', files{i});
    if i < numel(files)
        fprintf(fid, ',');
    end
end
fprintf(fid, ']\n');
end
