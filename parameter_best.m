clear;clc;close all
[~, ~] =system('taskkill /F /IM EXCEL.EXE'); % Keill all running "EXCEL" processes.解决文件被锁定问题

Function_name='F1'; % 使用所求目标函数的名字，对应 Functions_details 文件
[lb,ub,dim,fobj]=fobj(Function_name);  %得到具体的方程即目标函数，变量的维度，变量的上下限
pop_num=8;  %  种群数量
Max_iter=8;    %  最大迭代次数    
%各种优化算法性能的比较
Time_compare=[];      %算法的运行时间比较
Fival_compare=[];       %算法的最终目标比较
curve_compare=[];     %算法的过程函数比较
name_all=[];     %算法的名称记录
iter=1;%迭代次数

%要用什么算法就把什么算法解除注释即可，可以多个算法包一同比较优劣。
%各类算法包，可以从网上自己调包。
%% 模拟退火优化算法 SA
% t1=clock;
% [fMin_SA,bestX2,SA_curve]=SA(Max_iter,lb,ub,dim,fobj);                               % 模拟退火优化算法
% t2=clock;
% time_SA=(t2(end)+t2(end-1)*60+t2(end-2)*3600-t1(end)-t1(end-1)*60-t1(end-2)*3600);
% Fival_compare=[Fival_compare,fMin_SA];
% Time_compare=[Time_compare,time_SA(end)];
% curve_compare=[curve_compare;SA_curve];
% name_all{1,iter}='SA';
% iter=iter+1;

%% 遗传算法优化算法 √  GA
% t1=clock;
% [fMin_GA,bestX_GA,GA_curve]=GA(pop_num,Max_iter,lb,ub,dim,fobj);     % 遗传算法优化算法  
% %[目标函数最小值，最佳x值，迭代曲线]
% time_GA=(clock-t1);
% Fival_compare=[Fival_compare,fMin_GA];
% Time_compare=[Time_compare,time_GA(end)];
% curve_compare=[curve_compare;GA_curve];
% name_all{1,iter}='GA';
% iter=iter+1;

%% 画迭代曲线
load('color_list')
figure(2)
color_all=color_list(randperm(length(color_list)),:);
%画迭代过程曲线
for N=1:length(Fival_compare)
     plot(curve_compare(N,:),'Color',color_all(N,:),'LineWidth',2)
     hold on
end
xlabel('迭代次数');
ylabel('目标函数值');
grid on
box on
legend(name_all)
%以下可以显示
% display(['The best solution obtained by SSA is : ', num2str(bestX)]);
% display(['The best optimal value of the objective funciton found by SSA is : ', num2str(fMin)]);
