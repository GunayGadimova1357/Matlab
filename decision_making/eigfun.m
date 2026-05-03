function F = eigfun(K, A, B, C)
% Nümunə 2 üçün xüsusi ədədləri hesablayan funksiya
% A + B*K*C matrisinin xüsusi ədədlərini tapır və qaydaya salır

F = sort(eig(A + B*K*C));  % Xüsusi ədədlərin tapılması və sıralanması