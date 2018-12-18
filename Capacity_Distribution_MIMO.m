clear,clc
L=10000; %Simulate for 10000 times 
rou=10; %SNR is 10dB, 10lg10=10 linearly
N=3; %Three transmit antennas
M=3; %Three receive antennas
number_of_intervals=100; %The number of intervals devided

C1=zeros(1,L);
C2=zeros(1,L);
C3=zeros(1,L);
for T=1:L %Calculate capacity for L times
    H1=1/sqrt(2)*(randn(3,3)+1j*randn(3,3)); %UHR model
    C1(T)=log2(det(eye(3)+rou/N*(H1*H1'))); %Channel capacity for UHR
    H2=(1/sqrt(2)*(randn(3,1)+1j*randn(3,1)))*(1/sqrt(2)*(randn(3,1)+1j*randn(3,1)))'; %ULR model
    C2(T)=log2(det(eye(3)+rou/N*(H2*H2'))); %Channel capacity for ULR
    H3=(1/sqrt(2)*(randn(1,1)+1j*randn(1,1)))*(1/sqrt(2)*(randn(1,1)+1j*randn(1,1)))'*[1;1;1]*[1,1,1]; %%CLR model
    C3(T)=log2(det(eye(3)+rou/N*(H3*H3'))); %Channel capacity for CLR
end
    
C1_number=hist(C1,number_of_intervals); %The number of C1s that lie in every interval
C2_number=hist(C2,number_of_intervals); %The number of C2s that lie in every interval
C3_number=hist(C3,number_of_intervals); %The number of C3s that lie in every interval  

C1_cumulative_number=zeros(1,number_of_intervals);
C2_cumulative_number=zeros(1,number_of_intervals);
C3_cumulative_number=zeros(1,number_of_intervals);

C1_cumulative_number(1)=C1_number(1); %Calculate the number of Cs that lie in every interval
C2_cumulative_number(1)=C2_number(1); 
C3_cumulative_number(1)=C3_number(1); 
for num=2:number_of_intervals 
        C1_cumulative_number(num)=C1_cumulative_number(num-1)+C1_number(num);
        C2_cumulative_number(num)=C2_cumulative_number(num-1)+C2_number(num);
        C3_cumulative_number(num)=C3_cumulative_number(num-1)+C3_number(num);
end

C1_cumulative_number=C1_cumulative_number/L; %Calculate cdf of C1
C2_cumulative_number=C2_cumulative_number/L; %Calculate cdf of C2
C3_cumulative_number=C3_cumulative_number/L; %Calculate cdf of C3
       
C1_min=min(C1);
C1_max=max(C1);
C2_min=min(C2);
C2_max=max(C2);
C3_min=min(C3);
C3_max=max(C3);

Capacity1=zeros(1,number_of_intervals);
Capacity2=zeros(1,number_of_intervals);
Capacity3=zeros(1,number_of_intervals);
for a=1:number_of_intervals %Calculate coordinates on x axis
    Capacity1(a)=C1_min+a/number_of_intervals*(C1_max-C1_min); 
    Capacity2(a)=C2_min+a/number_of_intervals*(C2_max-C2_min);
    Capacity3(a)=C3_min+a/number_of_intervals*(C3_max-C3_min);
end
plot(Capacity1, C1_cumulative_number,'r-'); %Plot cdf versus capacity
hold on;
plot(Capacity2, C2_cumulative_number,'m-');
plot(Capacity3, C3_cumulative_number,'b-');
grid on;

title('Capacity Distribution of Theoretical MIMO Channels at 10dB SNR')
xlabel('Capacity in bps/Hz')
ylabel('Prob[Capacity bps/Hz<abscissa]')
legend('3*3 UHR','3*3 ULR','3*3 CLR')