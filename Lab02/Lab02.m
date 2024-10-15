function [result, count] = minimizationMethod(a, b, e, f, showPoints, addPointsToPlot)
    % Check if f is a function handle
    if ~isa(f, 'function_handle')
        error('Input f must be a function handle');
    end
    
    r = (sqrt(5) - 1) / 2; 
    l = b - a;

    x1 = b - r*l;
    x2 = a + r*l;
    f1 = f(x1);
    f2 = f(x2);

    count = 2;

    while true
        if showPoints 
            disp([num2str(a, 6), ' , ', num2str(b, 6)]);
        end

        if addPointsToPlot
            hold off
            plotFunction(f)
            fplot(f,[a,b],'r');
            fa = f(a);
            fb = f(b);
            plot(a, fa, 'r*');
            plot(b, fb, 'r*');
            pause(1);
        end
        if not(l > 2*e)
            result = (a + b)/2;
            break;
        end

        if f1 <= f2
            b = x2;
            l = b - a;

            x2 = x1;
            f2 = f1;

            x1 = b - r*l;
            f1 = f(x1);
        else
            a = x1;
            l = b - a;

            x1 = x2;
            f1 = f2;

            x2 = a + r*l;
            f2 = f(x2);
        end

        count = count + 1;
    end
end

% Define your function f(x)
f = @(x) -(log10(-sqrt(3)*x.^4 - x.^2 + 5*x + 1) + tanh((-x.^5 - 2*x.^4 - x.^3 + 3*x.^2 + 6*x + 3 - sqrt(5)) / (x.^2 + 2*x + 1)) - 1);

% Define a, b and e
a = 0;
b = 1;

showPlot = true;
%e = 0.01;
%e = 0.0001;
%e = 0.000001;

%e = 10^-2;
%e = 10^-4;
e = 10^-6;

% Call the function to generate the plot
if showPlot
    plotFunction(f)
end

% Call the minimizationMethod with the parameters and the function handle
[result, count] = minimizationMethod(a, b, e, f, true, showPlot);

% Display the result
disp(['x*: ', num2str(result, 6)]);
disp(['f*: ', num2str(f(result), 6)]);
disp(['N: ', num2str(count)]);

% Call the function to generate the plot
if showPlot
    plot(result, f(result), 'r*')
end

function plotFunction(f)
  % Plot the function
  fplot(f,[0,1],'b')
  hold on
  %plot(pointX, pointY, 'r*')
  xlabel('x')
  ylabel('y')
  title('Plot of the Function')
  grid on
end



