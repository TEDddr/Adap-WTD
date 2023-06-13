%% 基于小波变换的阈值去噪
clc;
clear ;
close all;
[~, ~] =system('taskkill /F /IM EXCEL.EXE'); 		% Keill all running "EXCEL" processes.解决文件被锁定问题
% wavemenu  %工具箱分析
%% 寻优最佳参数
main_best;
%% a第一步a：对原始信号做一个初筛：
%筛出有降噪价值的数据
    %读取数据：理想信号a_x (原始信号)    噪音a_nt 
    %直接调用即可
    a_x=xlsread('(理想值)原始信号.xlsx','Sheet1','D1:D100');
    a_nt=xlsread('(波动值).xlsx','Sheet1','D1:D100');
    [a_m,~]=size(a_x);
    a_t=(1:1:a_m)';%序号
    %波动百分比计算
    a_bdz = abs(a_nt); %波动值绝对值
    a_Pbdz = a_bdz./a_x; %波动百分比
    aa = [a_t,a_x,a_x+a_nt,a_nt,a_Pbdz]; %原始数据表
    %[0.18,0.25]疑似故障、[0.03,0.05]较准确，都需要筛出
    a_Pbdz(a_Pbdz>0.18) = 1000;
    a_Pbdz(a_Pbdz<0.05) = 100; 
    a_FenJiB = [a_t,a_x,a_x+a_nt,a_nt,a_Pbdz];%原始数据表
    xlswrite('经分级的源数据.xlsx',a_FenJiB)
 [m1,n1]=size(a_FenJiB);
z=zeros(1,n1);  %列数对齐
for i=1:m1
    if(a_FenJiB(i,5) ~=100 & a_FenJiB(i,5) ~= 1000)
        z = [z;a_FenJiB(i,:)];
    end
end
a_ZaoYinB = z(2:size(z,1),:);
xlswrite('待小波滤波处理的数据.xlsx',a_ZaoYinB)
%筛选出待处理数据
a_ZaoYinC = z2(2:size(z2,1),:);
%% 第二步b：输入待处理信号
%读取数据：理想信号x (原始信号)    波动值nt  
b_x=xlsread('待小波滤波处理的数据.xlsx','Sheet1','B1:B100');
b_nt=xlsread('待小波滤波处理的数据.xlsx','Sheet1','D1:D100');
%得到含噪信号   y = x + nt
b_y=b_x+b_nt;
%数据t采样值   N采样数目
[m2,n2]=size(b_x);
t=(1:1:m2)';
%% 第三步c：求解函数确立and小波基选择  
    c_a5=appcoef(c_fjxs,l,'sym4',5);
    %取各层高频细节系数
    c_d5=detcoef(c_fjxs,l,5);
    c_d4=detcoef(c_fjxs,l,4);
    c_d3=detcoef(c_fjxs,l,3);
    c_d2=detcoef(c_fjxs,l,2);
    c_d1=detcoef(c_fjxs,l,1);
%% 第四步d：获取最佳参数    
d_thr=bestX_GA;
d_a = bestX_a;
% d_thr=thselect(b_y,'heursure'); % √去噪的阈值选择，
%% 第五步e：阈值函数选择：    
e_ysoft5=wthresh_i(c_d5,'s',d_thr,d_a);%改进的阙值函数
e_ysoft4=wthresh_i(c_d4,'s',d_thr,d_a); 
e_ysoft3=wthresh_i(c_d3,'s',d_thr,d_a);
e_ysoft2=wthresh_i(c_d2,'s',d_thr,d_a);
e_ysoft1=wthresh_i(c_d1,'s',d_thr,d_a);
e_c1=[c_a5;e_ysoft5;e_ysoft4;e_ysoft3;e_ysoft2;e_ysoft1];
% wthcoef   %一维信号小波系数的阙值处理
%% 第六步f：重构信号
f_CgXh=waverec(e_c1,l,'sym4'); %多尺度一维小波重构   
f_bdz=f_CgXh-b_x;%降噪后波动值
%% 第七步g：重组信号  
%按顺序，将[0,0.05]+[降噪部分]+[0.18,∞]给拼接起来
% 针对F
g_JzQian=aa(:,1:4);%降噪前
g_JzHou=[a_ZaoYinA(:,1:4);f_fin;a_ZaoYinC(:,1:4)];%降噪后
g_JzHou_rank=sortrows(g_JzHou);%降噪后，按序号排序

% 针对整表波动值
g_JzQ_ZbBdz=abs(xlsread('(波动值)rcoFT.xlsx'));
g_jzH_ZbBdz=abs([g_JzQ_ZbBdz(:,1:3),g_JzHou_rank(:,4),g_JzQ_ZbBdz(:,5)]);
%% 第八步h：降噪指标    
%信噪比（实际-降噪后）
        h_SNR1=sum(b_x.^2); %纯净信号
        h_SNR2=sum(f_CgXh.^2);%去噪后信号
        h_SNR3=sum((b_x-f_CgXh).^2);%降噪后的差值
        SNR=10*log10(h_SNR1/h_SNR3);%信噪比
        %原始信噪比  （实际-理想）
        h_SNR4=sum((b_nt).^2); %原始噪音值
        SNR_Q=10*log10(h_SNR1/h_SNR4);%信噪比，
      
% 针对整个数据表
        % 降噪前数据评分:权重*波动值
        h_JzQ_ZB_Score=(h_Qzz(:,1:5) * g_JzQ_ZbBdz')';
        h_JzQ_ZB_PjzScore=mean(h_JzQ_ZB_Score,1);
        % 降噪后数据评分
        h_JzH_ZB_Score=(h_Qzz(:,1:5) * g_jzH_ZbBdz')';
        h_JzH_ZB_PjzScore=mean(h_JzH_ZB_Score,1);
%% 最后一部分fin：拼接各评价指标
  %信噪比
  %降噪后噪音分、前后分数差额；降噪后整表噪音均分、前后整表分数差额
  %原分数只需要简单提一下即可，为方便观察，也把原分数放在fin部分
  fin_bdz=h_JzQ_Bdz;
  fin_bdz_bfb=(h_JzH_Bdz - h_JzQ_Bdz)/h_JzQ_Bdz;
  
  fin_Fscore=h_JzQ_Score;
  fin_Fscore_bfb=(h_JzH_Score - h_JzQ_Score)/h_JzQ_Score;
  
  fin_ZBscore=h_JzQ_ZB_PjzScore;
  fin_ZBscore_bfb=(h_JzH_ZB_PjzScore - h_JzQ_ZB_PjzScore)/h_JzQ_ZB_PjzScore;
  
  fin_SNR_bfb=(SNR-SNR_Q)/SNR_Q;
  fin_all=[h_JzH_AEFF,fin_EFF_bfb, h_JzH_Bdz,fin_bdz_bfb ,SNR,fin_SNR_bfb,h_JzH_Score,fin_Fscore_bfb ,h_JzH_ZB_PjzScore,fin_ZBscore_bfb];
%% 额外部分：画图
% 频数波形对比图
figure;
hold on;    
%根据需要去调整
% subplot(2,2,1);plot(t,b_x);xlabel('频数f');ylabel('值');title('理想信号值x');
% subplot(2,2,2);plot(t,b_y);xlabel('频数f');ylabel('值');title('含噪信号值y');
% subplot(2,2,3);plot(t,f_CgXh);xlabel('频数f');ylabel('值');title('去噪后信号值X');
% subplot(3,1,1);plot(t,f_CgXh);xlabel('         频数\newline(g)自己所提自适应阈值降噪算法');ylabel('值');axis([0,60,100,200]);

%属性设置
plot(t,b_y);%含噪值
plot(t,b_x,'--'); %理想值
% plot(t,f_CgXh,'-b');%降噪后值
% legend('理想信号值s(t)','含噪信号值f(t)','去噪后信号值X');   %右上角标注
%% 画迭代曲线
% load('color_list')
% figure(2)
% color_all=color_list(randperm(length(color_list)),:);
% %画迭代过程曲线
% for N=1:length(Fival_compare)
%      plot(curve_compare(N,:),'Color',color_all(N,:),'LineWidth',2)
%      hold on
% end
% xlabel('迭代次数');
% ylabel('目标函数值');
% grid on
% box on
% legend(name_all)
