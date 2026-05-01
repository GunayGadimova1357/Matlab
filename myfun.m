function f = myfun(x)
% Nümunə 1 üçün funksiyalar dəsti
% Minimax məsələsinin həlli üçün istifadə olunur

f(1) = 2*x(1)^2 + x(2)^2 - 48*x(1) - 40*x(2) + 304;
f(2) = -x(1)^2 - 3*x(2)^2;
f(3) = x(1) + 3*x(2) - 18;
f(4) = -x(1) - x(2);
f(5) = x(1) + x(2) - 8;