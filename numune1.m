

%% Başlanğıc dəyərlərin verilməsi
x0 = [0.1; 0.1];  % Axtarışın start nöqtəsi

%% fminimax funksiyasının işlədilməsi
% f(x) funksiyalar dəstindən maksimal dəyəri minimuma endiririk
[x, fval] = fminimax(‘myfun’, x0);

%% Nəticələrin ekrana çıxarılması
fprintf(’=== Nümunə 1: fminimax Nəticələri ===\n’);
fprintf(‘Optimal həll:\n’);
fprintf(’  x(1) = %.4f\n’, x(1));
fprintf(’  x(2) = %.4f\n’, x(2));
fprintf(’\nFunksiya dəyərləri (fval):\n’);
for i = 1:length(fval)
fprintf(’  f%d(x) = %.4f\n’, i, fval(i));
end
fprintf(’\nHəll: x = [%.0f, %.0f]\n’, x(1), x(2));
