function [ trend ] = getTrend( signal, varargin)
%UNTITLED2 Summary of this function goes here
% Detailed explanation goes here
% Estimate a trend of the signal using moving average filter.
% This function is first developed for FEX module in Data Browser v1.3 
% Input :
% 1. signal : the signal we want to estimate the trend.
% 2. varargin : the size of moving window (#points)
%             : default size is set to 150 points which works for
%             patamp,oxipamp,sbp,dbp,ecg,pu_left/right from SCD consolidated files
% 3. Tip : window size is defined by the periodicity of the signal.(By eyes)
% 100-200 points are acceptable for patamp,oxipamp,sbp,dbp,ecg,pu_left/right.

% Example 
% 1. trend = getTrend(pu_left);
% 2. trend = getTrend(pu_left,'window',100); %100=#points
%   Developed : 2015-02-24 Toey.
% 

% define the moving average filter
if ~isempty(varargin),
    if strcmp(varargin{1},'window'),
        if mod(varargin{2},1)==0, window = varargin{2}; else error('Window size must be integer'); end
    end
else
    window = 150;
end
wts = [1/(2*window);repmat(1/window,window,1);1/(2*window)]; %size of wts = window+2;

trend = filtfilt(wts,1,signal); %Use filtfilt instead of conv because I want phaseshift = 0;

end

