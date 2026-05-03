%% LABORATORY № 4
%% TS Fuzzy Controller for BIHER Mobile Robot
%% NO Fuzzy Logic Toolbox required — runs on MATLAB Online (free)
%% All fuzzy logic implemented manually from scratch

clear; clc; close all;

%% =====================================================================
%%  1. MEMBERSHIP FUNCTIONS  (replaces FIS Editor / fuzzy() command)
%% =====================================================================

% Input variable: x3, universe of discourse: [-1.5, 1.5]
x3_range = linspace(-1.5, 1.5, 300);

% Triangular membership function (trimf)
trimf = @(x, a, b, c) max(min((x-a)./(b-a+1e-10), (c-x)./(c-b+1e-10)), 0);

% Parameters from Figure 4.7:
%   M1x3 Params: -3  -1.5   0
%   M2x3 Params: -1.5  0   1.5
%   M3x3 Params:  0   1.5   3
M1 = trimf(x3_range, -3,   -1.5,  0  );
M2 = trimf(x3_range, -1.5,  0,    1.5);
M3 = trimf(x3_range,  0,    1.5,  3  );

% --- Plot membership functions (Figure 4.7 equivalent) ---
figure('Name', 'Membership Functions - Input X3');
plot(x3_range, M1, 'b-', 'LineWidth', 2); hold on;
plot(x3_range, M2, 'r-', 'LineWidth', 2);
plot(x3_range, M3, 'g-', 'LineWidth', 2);
xlabel('x_3');  ylabel('\mu(x_3)');
title('BIHER Robot — Input Membership Functions (M^1, M^2, M^3)');
legend('M^1(x_3)', 'M^2(x_3)', 'M^3(x_3)', 'Location', 'best');
grid on;  ylim([-0.1 1.1]);

%% =====================================================================
%%  2. OUTPUT PARAMETERS  (Sugeno-type: constant output values per rule)
%% =====================================================================

% Computed constant (from lab):  a2d = 0.0081 * 1.5
a2d = 0.0081 * 1.5;   % = 0.01215

% Fuzzy rules (from Section 4, Figure 4.12):
%   Rule 1: IF x3 is M1  THEN  y1 = 0,     y2 = 0
%   Rule 2: IF x3 is M2  THEN  y1 = -a2d,  y2 = +a2d
%   Rule 3: IF x3 is M3  THEN  y1 = -a2d,  y2 = -a2d
y1_rules = [0,    -a2d,  -a2d];
y2_rules = [0,    +a2d,  -a2d];

fprintf('a2d = %.5f\n', a2d);
fprintf('Y1 rule outputs : [%.5f,  %.5f,  %.5f]\n', y1_rules);
fprintf('Y2 rule outputs : [%.5f,  %.5f,  %.5f]\n', y2_rules);

%% =====================================================================
%%  3. SUGENO INFERENCE ENGINE  (replaces evalfis / FIS object)
%%     Weighted average defuzzification
%% =====================================================================

function [y1, y2] = sugeno_infer(x3_val, y1_rules, y2_rules)
    trimf = @(x, a, b, c) max(min((x-a)./(b-a+1e-10), (c-x)./(c-b+1e-10)), 0);

    % Firing strengths
    w1 = trimf(x3_val, -3,   -1.5, 0  );
    w2 = trimf(x3_val, -1.5,  0,   1.5);
    w3 = trimf(x3_val,  0,    1.5, 3  );
    W  = w1 + w2 + w3 + 1e-10;   % avoid division by zero

    % Normalized weights (hi = wi / sum(wi))
    h1 = w1/W;  h2 = w2/W;  h3 = w3/W;

    % Sugeno defuzzification: y = sum(hi * yi)
    y1 = h1*y1_rules(1) + h2*y1_rules(2) + h3*y1_rules(3);
    y2 = h1*y2_rules(1) + h2*y2_rules(2) + h3*y2_rules(3);
end

%% =====================================================================
%%  4. OUTPUT SURFACE  (replaces Surface Viewer, Figure 4.11-4.12)
%% =====================================================================

y1_out = zeros(size(x3_range));
y2_out = zeros(size(x3_range));

for k = 1:length(x3_range)
    [y1_out(k), y2_out(k)] = sugeno_infer(x3_range(k), y1_rules, y2_rules);
end

figure('Name', 'Output Surface');
subplot(2,1,1);
plot(x3_range, y1_out, 'b-', 'LineWidth', 2);
xlabel('x_3');  ylabel('y_1');
title('Sugeno Output: y_1 vs x_3');
grid on;

subplot(2,1,2);
plot(x3_range, y2_out, 'r-', 'LineWidth', 2);
xlabel('x_3');  ylabel('y_2');
title('Sugeno Output: y_2 vs x_3');
grid on;

%% =====================================================================
%%  5. RULE VIEWER  (replaces Rule Viewer GUI, Figure 4.9-4.10)
%% =====================================================================

x3_test = 0.5;   % arbitrary test value

trimf_s = @(x, a, b, c) max(min((x-a)./(b-a+1e-10), (c-x)./(c-b+1e-10)), 0);
w1_t = trimf_s(x3_test, -3,   -1.5, 0  );
w2_t = trimf_s(x3_test, -1.5,  0,   1.5);
w3_t = trimf_s(x3_test,  0,    1.5, 3  );
W_t  = w1_t + w2_t + w3_t + 1e-10;

figure('Name', 'Rule Viewer');
bar([w1_t, w2_t, w3_t], 'FaceColor', [0.2 0.55 0.85]);
set(gca, 'XTickLabel', {'Rule 1','Rule 2','Rule 3'});
ylabel('Firing strength  w_i');
title(sprintf('Rule Viewer  —  x_3 = %.2f', x3_test));
ylim([0 1.2]);  grid on;
for i = 1:3
    vals = [w1_t, w2_t, w3_t];
    text(i, vals(i)+0.04, sprintf('%.3f', vals(i)/W_t), ...
        'HorizontalAlignment','center', 'FontSize', 10, 'FontWeight', 'bold');
end

[y1_t, y2_t] = sugeno_infer(x3_test, y1_rules, y2_rules);
fprintf('\n--- Test point  x3 = %.2f ---\n', x3_test);
fprintf('  y1 = %.6f\n', y1_t);
fprintf('  y2 = %.6f\n', y2_t);

%% =====================================================================
%%  6. CLOSED-LOOP SIMULATION  (replaces Simulink model)
%%     State equation (4.6a) integrated with Euler method
%%     TS fuzzy controller from equation (4.5)
%% =====================================================================

% --- Subsystem matrices for BIHER robot ---
% State: x = [x1; x2]  (position, velocity)
% Subsystem 1 (M1 active):
A1 = [-1   0.5;  -0.5  -1  ];   B1 = [1;   0  ];
% Subsystem 2 (M2 active):
A2 = [-1   1;    -1    -0.8];   B2 = [1;   0.5];
% Subsystem 3 (M3 active):
A3 = [-0.8 0.5;  -0.5  -1.2];  B3 = [0.8; 0.3];

% Output matrix (same for all subsystems)
C = [1 0];

% Controller gain matrices Fi (state feedback) and Gi (integral gain)
F1 = [-1.0  -0.5];   G1 = 1.0;
F2 = [-1.2  -0.6];   G2 = 1.2;
F3 = [-0.9  -0.4];   G3 = 0.9;

% --- Simulation settings ---
dt = 0.01;        % time step [s]
T  = 10;          % total time [s]
t  = 0:dt:T;
N  = length(t);

x = zeros(2, N);  % state trajectory
e = zeros(1, N);  % tracking error
u = zeros(1, N);  % control input
r = ones(1,  N);  % reference (unit step)
x(:,1) = [0; 0];  % initial conditions

trimf_sim = @(x, a, b, c) max(min((x-a)./(b-a+1e-10), (c-x)./(c-b+1e-10)), 0);

for k = 1:N-1
    x3_k = x(2, k);   % x3 is mapped to the velocity state

    % --- Firing strengths (eq. 4.2) ---
    w1 = trimf_sim(x3_k, -3,   -1.5, 0  );
    w2 = trimf_sim(x3_k, -1.5,  0,   1.5);
    w3 = trimf_sim(x3_k,  0,    1.5, 3  );
    W  = w1 + w2 + w3 + 1e-10;
    h1 = w1/W;  h2 = w2/W;  h3 = w3/W;

    % --- System output (eq. 4.2b) ---
    y_k = h1*(C*x(:,k)) + h2*(C*x(:,k)) + h3*(C*x(:,k));

    % --- Tracking error (eq. 4.3) ---
    e(k) = r(k) - y_k;

    % --- TS fuzzy controller (eq. 4.5) ---
    u(k) = h1*(F1*x(:,k) + G1*e(k)) + ...
           h2*(F2*x(:,k) + G2*e(k)) + ...
           h3*(F3*x(:,k) + G3*e(k));

    % --- State update (eq. 4.6a) — Euler integration ---
    dx = h1*(A1*x(:,k) + B1*u(k)) + ...
         h2*(A2*x(:,k) + B2*u(k)) + ...
         h3*(A3*x(:,k) + B3*u(k));
    x(:,k+1) = x(:,k) + dt*dx;
end
e(end) = r(end) - C*x(:,end);

%% =====================================================================
%%  7. PLOT SIMULATION RESULTS
%% =====================================================================

y_sim = C(1)*x(1,:);   % output signal

figure('Name', 'Simulation Results', 'Position', [100 100 900 650]);

subplot(3,1,1);
plot(t, r,     'k--', 'LineWidth', 1.5); hold on;
plot(t, y_sim, 'b-',  'LineWidth', 2);
xlabel('Time (s)');  ylabel('y(t)');
title('BIHER Robot — TS Fuzzy Controller: Closed-Loop Response');
legend('Reference r(t)', 'Output y(t)', 'Location', 'best');
grid on;

subplot(3,1,2);
plot(t, e, 'r-', 'LineWidth', 1.5);
xlabel('Time (s)');  ylabel('e(t)');
title('Tracking Error  e(t) = r(t) - y(t)');
grid on;

subplot(3,1,3);
plot(t, u, 'm-', 'LineWidth', 1.5);
xlabel('Time (s)');  ylabel('u(t)');
title('TS Controller Output  u(t)');
grid on;

fprintf('\n=== SIMULATION COMPLETE ===\n');
fprintf('Final error  : e(T) = %.6f\n', e(end));
fprintf('Final output : y(T) = %.6f\n', y_sim(end));