function [signal1, signal2, signal3] = alignment(signal1, signal2, signal3, time_stamp1, time_stamp2, time_stamp3, sample_rate)

tam1=length(signal1);

delay21=(time_stamp2-time_stamp1)*10^-9*sample_rate;
delay31=(time_stamp3-time_stamp1)*10^-9*sample_rate;
delay32=(time_stamp3-time_stamp2)*10^-9*sample_rate;

    signal1(1:delay31)=[];
    signal2(1:delay32)=[];
    tam2=length(signal2);
    signal3((tam1-delay31+1):tam1)=[];
    signal2((tam2-delay21+1):tam2)=[];