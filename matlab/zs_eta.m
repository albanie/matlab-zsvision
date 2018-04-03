function etaStr = zs_eta(rate, completed, total)
%ZS_ETA - generate string estimating the time of completion
%   ZS_ETA(RATE, COMPLETED, TOTAL) - estimates the "time of arrival" based
%   on the current RATE (value in Hz), the count of completed samples and
%   the total to be performed.
%
%   Copyright (C) 2018 Samuel Albanie
%   All rights reserved.

  remSecs = (total - completed) / rate ;
  etaStr = duration(0, 0, remSecs) ;
end
