function  data = bifurcacion(funcion, intervar, interpar)

scale = 100000; % determines the level of rounding
maxpoints = 200; % determines maximum values to plot
N = 1000; % number of "r" values to simulate
a = intervar(1); % starting value of "x"
b = intervar(2); % final value of "x"
p = interpar(1); % starting value of "s"
q = interpar(2); % final value of "s"
vs = linspace(p, q, N); % vector of "s" values
M = 10000; % number of iterations 

% Loop through the "s" values
for j = 1: length(vs)
    s = vs(j); % get current "s"
    x = zeros(M, 1); % allocate memory
    rd = rand; 
    x(1) = rd*a + (1 - rd)*b; % initial condition
  
    for i = 2 : M % iterate
        x(i) = funcion(x(i - 1), s);
    end
    % only save those unique, semi-stable values
    out{j} = unique(round(scale*x(end - maxpoints : end)));
end

% Rearrange cell array into a large 2-by-n vector for plotting
data = [];
for k = 1 : length(vs)
    n = length(out{k});
    data = [data;  vs(k)*ones(n,1), out{k}];
end
data(:, 2) = data(:, 2)/scale;
data = transpose(data);



