function zv_profSave(profInfo, dirname)
%ZV_PROFSAVE profsave, but without opening the browser
%   ZV_PROFSAVE performs the same function as profsave (see help profsave), 
%   with the small difference that it does not open the resulting html files
%   in the browser, and defaults to saving them in '/tmp/profile'
%   
%   This function is a minor modification of the MATLAB profsave function.

if nargin < 1
    profInfo = profile('info');
end

if nargin < 2
    dirname = '/tmp/profile';
end

pth = fileparts(dirname);

if isempty(pth)
    fullDirname = fullfile(cd,dirname);
else
    fullDirname = dirname;
end


if ~exist(fullDirname,'dir')
    if ~mkdir(fullDirname)
        error(message('MATLAB:profiler:UnableToCreateDirectory', fullDirname));
    end
end
    
for n = 0:length(profInfo.FunctionTable)
    str = profview(n,profInfo);
    
    str = regexprep(str,'<a href="matlab: profview\((\d+)\);">','<a href="file$1.html">');
    % The question mark makes the .* wildcard non-greedy
    str = regexprep(str,'<a href="matlab:.*?>(.*?)</a>','$1');
    % Remove all the forms
    str = regexprep(str,'<form.*?</form>','');

    insertStr = ['<body bgcolor="#F8F8F8"><strong>' getString(message('MATLAB:profiler:StaticCopyOfReport')) '</strong><p>' ...
        '<a href="file0.html">' getString(message('MATLAB:profiler:HomeUrl')) '</a><p>'];
    str = strrep(str,'<body>',insertStr);

    filename = fullfile(fullDirname,sprintf('file%d.html',n));
    fid = fopen(filename,'w','n','utf8');
    if fid > 0
        fprintf(fid,'%s',str);
        fclose(fid);
    else
        error(message('MATLAB:profiler:UnableToOpenFile', filename));
    end
    
end
