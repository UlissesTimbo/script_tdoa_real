function [Sinal1] = windowing(signal1)

tam=length(signal1);
particao=floor(tam/10);

for i=1:10
    for j=1:particao
        Sinal1(j,i)=signal1(j+particao*(i-1));
    end
end