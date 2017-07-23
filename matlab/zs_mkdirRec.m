function zs_mkdirRec(dirname)
%ZS_MKDIRREC make the given directory
%   ZS_MKDIRREC(DIRNAME) constructs the directory 
%   given by the path DIRNAME.  If any of the folders
%   in its parental hierarchy do not exist, they are
%   constructed (recursively).

  while ~exist(fileparts(dirname), 'dir')
    zs_mkdirRec(fileparts(dirname)) ;
  end
  if ~exist(dirname, 'dir'), mkdir(dirname) ; end
