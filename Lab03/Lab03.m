function [x_1, x_2, x_3, count] = choseInitialX(a, b, f)
    if ~isa(f, 'function_handle')
        error('Input f must be a function handle');
    end
    
    r = (sqrt(5) - 1) / 2; 
    l = b - a;

    x1 = b - r*l;
    x2 = a + r*l;
    f1 = f(x1);
    f2 = f(x2);

    fa = f(a);
    fb = f(b);

    count = 2;

    while true
        if ((a < x1) && (x1 < x2)) && ((fa >= f1) && (f1 <= f2))
            x_1 = a;
            x_2 = x1;
            x_3 = x2;
            break;
        elseif ((x1 < x2) && (x2 < b)) && ((f1 >= f2) && (f2 <= fb))
            x_1 = x1;
            x_2 = x2;
            x_3 = b;
            break;
        end

        if f1 <= f2
            b = x2;
            l = b - a;

            fb = f2;

            x2 = x1;
            f2 = f1;

            x1 = b - r*l;
            f1 = f(x1);
        else
            a = x1;
            l = b - a;

            fa = f1;

            x1 = x2;
            f1 = f2;

            x2 = a + r*l;
            f2 = f(x2);
        end

        count = count + 1;
    end
end

function [result, count] = minimizationMethod(a, b, e, f, showPoints, addPointsToPlot)
    % Check if f is a function handle
    if ~isa(f, 'function_handle')
        error('Input f must be a function handle');
    end
    
    [x1, x2, x3, count] = choseInitialX(a, b, f);
    
    f1 = f(x1);
    f2 = f(x2);
    f3 = f(x3);

    a1 = (f2 - f1)/(x2 - x1);
    a2 = ((f3 - f1)/(x3 - x1) - (f2 - f1)/(x2 - x1))/(x3 - x2);
    x0 = (x1 + x2 - a1/a2)/2;
    f0 = f(x0);

    count = count + 4;
    iteration = 1;

    if showPoints 
        disp(['Iteration ', num2str(iteration), ':']);
        disp(['x1: ', num2str(x1, 10)]);
        disp(['x2: ', num2str(x2, 10)]);
        disp(['x3: ', num2str(x3, 10)]);
        disp(['x0: ', num2str(x0, 10)]);
        disp(['f1: ', num2str(f1, 10)]);
        disp(['f2: ', num2str(f2, 10)]);
        disp(['f3: ', num2str(f3, 10)]);
        disp(['f0: ', num2str(f0, 10)]);
        %disp([num2str(x1, 10), ' , ', num2str(x3, 10)]);
    end

    if addPointsToPlot
        hold off
        plotFunction(f)
        fplot(f,[x1,x3],'r');
        f1 = f(x1);
        f3 = f(x3);
        plot(x1, f1, 'r*');
        plot(x3, f3, 'r*');
        pause(1)
    end
    while true
        iteration = iteration + 1;
        newX0 = x0;

        if x0 < x2
            if f0 <= f2
                x3 = x2;
                x2 = x0;
                f3 = f2;
                f2 = f0;
            else
                x1 = x0;
                f1 = f0;
            end
        else
            if f2 <= f0
                x3 = x0;
                f3 = f0;
            else
                x1 = x2;
                x2 = x0;
                f1 = f2;
                f2 = f0;
            end
        end

        a1 = (f2 - f1)/(x2 - x1);
        a2 = ((f3 - f1)/(x3 - x1) - (f2 - f1)/(x2 - x1))/(x3 - x2);
        x0 = (x1 + x2 - a1/a2)/2;
        f0 = f(x0);

        count = count + 1;

        if showPoints 
            %disp([num2str(x1, 10), ' , ', num2str(x3, 10)]);
            disp(' ');
            disp(['Iteration ', num2str(iteration), ':']);
            disp(['x1: ', num2str(x1, 10)]);
            disp(['x2: ', num2str(x2, 10)]);
            disp(['x3: ', num2str(x3, 10)]);
            disp(['x0: ', num2str(x0, 10)]);
            disp(['newX0: ', num2str(newX0, 10)]);
            disp(['f1: ', num2str(f1, 10)]);
            disp(['f2: ', num2str(f2, 10)]);
            disp(['f3: ', num2str(f3, 10)]);
            disp(['f0: ', num2str(f0, 10)]);
        end

        if addPointsToPlot
            hold off
            plotFunction(f)
            fplot(f,[x1,x3],'r')
            f1 = f(x1);
            f3 = f(x3);
            plot(x1, f1, 'r*');
            plot(x3, f3, 'r*');
            pause(1)
        end

        if abs(x0 - newX0) <= e
            result = x0;
            break;
        end
    end
end

% Define your function f(x)
%f = @(x) -(log10(-sqrt(3)*x.^4 - x.^2 + 5*x + 1) + tanh((-x.^5 - 2*x.^4 - x.^3 + 3*x.^2 + 6*x + 3 - sqrt(5)) / (x.^2 + 2*x + 1)) - 1);
f = @(x) 1 -  cos(x - 0.444);
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
disp(['x*: ', num2str(result, 10)]);
disp(['f*: ', num2str(f(result), 10)]);
disp(['N: ', num2str(count)]);

% Call the function to generate the plot
if showPlot 
    hold off
    plotFunction(f)
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