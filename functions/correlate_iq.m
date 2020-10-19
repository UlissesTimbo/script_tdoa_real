function [ iq_corr ] = correlate_iq( iq1, iq2 )
%correlate_iq correlates two complex iq signals according to the specified strategy
% iq1: first complex IQ signal
% iq2: second complex IQ signal
% corr_strategy ={'abs', 'dphase'}
%   'abs': use absolute value of iq signals
%   'dphase': use differential phase of iq signals
% smoothing_factor

            abs1 = remove_mean(abs(iq1));
            abs2 = remove_mean(abs(iq2));

            abs_corr = xcorr(abs1, abs2);
            
            abs_corr1 = abs_corr ./ max(abs_corr); %normalize
            iq_corr = abs_corr1;
                        
        