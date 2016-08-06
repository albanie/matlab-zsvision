function fileName = removeExt(fileName)
%REMOVEEXT returns fileName without its extension
%   REMOVEEXT removes the suffix from a string of 
%   the form 'abc.xyz' and returns 'abc'
%
%   Copyright (C) 2016 Samuel Albanie
%   All rights reserved.

tokens = strsplit(fileName, '.');
fileName = tokens{1};
