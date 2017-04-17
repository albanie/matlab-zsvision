function zs_dispFig
%ZS_DISPFIG shows matlab plots inline in iTermt
%   ZS_DISPFIG displays the current matlab figure inline
%   by saving it to a temporary file, displaying the
%   file and then cleaning up.
%
%   Note: This function requires the use of an iTerm 
%   terminal (available from https://www.iterm2.com)
%   and requires that the `imgcat` script is on your
%   $PATH. It can be useful when running MATLAB on a 
%   server when you don't have access to a GUI to 
%   display figures.
%
%   Copyright (C) 2016 Samuel Albanie
%   All rights reserved.

% save figure as jpeg image 
print('_tmp.jpg', '-djpeg');

% display in iterm
!imgcat _tmp.jpg

% clear up
delete('_tmp.jpg');
