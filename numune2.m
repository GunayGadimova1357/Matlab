

%% Sistem matrisləri
A = [-0.5  0   0;
0   -2  10;
0    1  -2];

B = [ 1   0;
-2   2;
0   1];

C = [1  0  0;
0  0  1];

%% İlkin şərtlərin verilməsi
K0 = [-1  -1;
-1  -1];  % K tənzimləyicisinin başlanğıc matrisi

%% Hədəf vektoru və çəki əmsallarının verilməsi
goal   = [-5, -3, -1];       % Məqsəd vektoru (istənilən xüsusi ədədlər)
weight = abs(goal);           % Çəki əmsalı vektoru

%% K matrisi elementlərinin sərhədləri
lb = -4 * ones(size(K0));    % Aşağı sərhəd
ub =  4 * ones(size(K0));    % Yuxarı sərhəd

%% –– MƏRHƏLƏ 1: İlkin optimallaşdırma ––
fprintf(’=== MƏRHƏLƏ 1: İlkin Optimallaşdırma ===\n\n’);

options1 = optimset(‘Display’, ‘iter’);

[K1, fval1, attainfactor1] = fgoalattain(@eigfun, K0, goal, weight, …
[], [], [], [], lb, ub, [], options1, A, B, C);

fprintf(’\n— Nəticələr —\n’);
fprintf(‘K matrisi:\n’);
disp(K1);
fprintf(‘Xüsusi ədədlər (fval):\n’);
disp(fval1’);
fprintf(‘Məqsədə çatma əmsalı (attainfactor) = %.4f\n’, attainfactor1);
fprintf(’(Verilmiş hədəflər orta hesabla %.0f%% artıqlaması ilə yerinə yetirildi)\n\n’, …
abs(attainfactor1) * 100);

%% –– MƏRHƏLƏ 2: Daha dəqiq optimallaşdırma ––
fprintf(’=== MƏRHƏLƏ 2: Daha Dəqiq Optimallaşdırma (GoalsExactAchieve=3) ===\n\n’);

options2 = optimset(‘GoalsExactAchieve’, 3, ‘Display’, ‘iter’);

[K2, fval2, attainfactor2] = fgoalattain(@eigfun, K0, goal, weight, …
[], [], [], [], lb, ub, [], options2, A, B, C);

fprintf(’\n— Yekun Nəticələr —\n’);
fprintf(‘K matrisi:\n’);
disp(K2);
fprintf(‘Xüsusi ədədlər (fval):\n’);
disp(fval2’);
fprintf(‘Məqsədə çatma əmsalı (attainfactor) = %.4f\n’, attainfactor2);

if abs(attainfactor2) < 1e-4
fprintf(‘Nəticə tam qənaətbəxşdir: verilmiş xüsusi ədədlərə tam çatıldı.\n’);
else
fprintf(‘Nəticə qismən qənaətbəxşdir.\n’);
end