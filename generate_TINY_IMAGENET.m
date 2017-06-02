function generate_TINY_IMAGENET
% GENERATE_TINY_IMAGENET Prepare the imdb structure for the tiny_imagenet dataset
%
%   generate_ generates the imdb structure for the tiny_imagenet dataset.
%   The input files are downloaded if necessary.

%	a lot of the paths in this file may need to be tweaked to suit your
%	directory structure

% if the python-retrieved imdb files don't exist
if ~exist('<PATH TO FILES FROM "setup_imdb_files.py">/imdb_data1.mat','file')
	system('echo "Processing tiny imagenet dataset..."');
	system('python utils/setup_imdb_files.py');
	system('echo "Done."');
end

% Get data field
load('utils/imdb_files/imdb_data1.mat');
load('utils/imdb_files/imdb_data2.mat');
data = cat(4, data1, data2);

% Create images struct
images = load('utils/imdb_files/imdb_set_labels_mean.mat', 'labels', 'set', 'mean');
images.labels = cast(images.labels, 'single');
images.set = cast(images.set, 'uint8');
images.data = data;

% Create meta struct
meta = load('utils/imdb_files/imdb_meta.mat', 'classes');
meta.classes = reshape(meta.classes, 200, 1);
meta.sets = {'train', 'val', 'test'};

% Make directory for 'imdb.mat' file if it doesn't already exist
system('mkdir -p tiny_imagenet');
system('echo "Saving dataset to /imdb.mat..."');
% MAT-file version must be at least v7.3 to save variables larger than 2GB in size
save('tiny_imagenet/imdb.mat', 'images', 'meta', '-v7.3');
system('echo "Done."');
end
