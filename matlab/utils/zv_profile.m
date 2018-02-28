% save profiling results to temporary file
resultsDir = '/tmp/profile' ;
profInfo = profile('info') ;

% use a modified version of profsave that doesn't open the web browser
zs_profSave(profInfo, resultsDir);
tmpPdf = fullfile(resultsDir, 'output.pdf') ;

% convert to pdf
generatedHtml = zs_getImgsInDir(resultsDir, 'html') ;
htmlArgs = sprintf('%s ', generatedHtml{:}) ;
command = sprintf('wkhtmltopdf %s %s', htmlArgs, tmpPdf) ;
system(command) ;

% and display inline
command = sprintf('imgcat %s', tmpPdf) ;
system(command) ;
delete tmpPdf ;
