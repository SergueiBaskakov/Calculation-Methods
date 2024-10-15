function [result, count] = minimizationMethod(a, b, e, delta, f, showPoints, showPlot, modified)
    if ~isa(f, 'function_handle')
        error('Input f must be a function handle');
    end

    x0 = (a + b)/2;

    if showPlot
        plot(x0, f(x0), 'r*')
        pause(1)
        plot(x0, f(x0), 'b*')
    end


    count = 0;
    iteration = 1;
    %df = diff(f);
    %ddf = diff(df);
    if modified
        fAprox1 = f(x0 + delta);
        fAprox2 = f(x0 - delta);
        fAprox3 = f(x0);
        f1 = (fAprox1 - fAprox2) / (2*delta);
        f2 = ( fAprox1 - 2*fAprox3 + fAprox2 ) / (delta ^ 2);

        count = count + 3;
    end

    while true 
        if showPoints
            disp(' ')
            disp(['Iteration: ', num2str(iteration)])
            disp(['x0: ',num2str(x0, 10)])
            disp(['f(x0): ',num2str(f(x0), 10)])
            iteration = iteration + 1;
        end

        if ~ modified
            fAprox1 = f(x0 + delta);
            fAprox2 = f(x0 - delta);
            f1 = (fAprox1 - fAprox2) / (2*delta);

            count = count + 2;
        end
        
        %f1 = double(subs(df, x, x0));
        
        if showPoints
            disp(['df(x0): ',num2str(f1, 10)])
        end

        if abs(f1) <= e
            result = x0;
            break;
        end

        %f2 = double(subs(ddf, x, x0));
        if ~ modified
            fAprox3 = f(x0);
            f2 = ( fAprox1 - 2*fAprox3 + fAprox2 ) / (delta ^ 2);
            count = count + 1;
        end
        
        if showPoints
            disp(['ddf(x0): ',num2str(f2, 10)])
        end

        newX0 = x0;
        x0 = newX0 - f1/f2;
        
        if modified
            fAprox1 = f(x0 + delta);
            fAprox2 = f(x0 - delta);
            f1 = (fAprox1 - fAprox2) / (2*delta);
            count = count + 2;
        end

        if showPlot
            plot(x0, f(x0), 'r*')
            pause(10)
            plot(x0, f(x0), 'b*')
        end
    
    end
    
end

% Define your function f(x)
% syms x;
f = @(x) -(log10(-sqrt(3)*x.^4 - x.^2 + 5*x + 1) + tanh((-x.^5 - 2*x.^4 - x.^3 + 3*x.^2 + 6*x + 3 - sqrt(5)) / (x.^2 + 2*x + 1)) - 1);
%f = -(log10(-sqrt(3)*x.^4 - x.^2 + 5*x + 1) + tanh((-x.^5 - 2*x.^4 - x.^3 + 3*x.^2 + 6*x + 3 - sqrt(5)) / (x.^2 + 2*x + 1)) - 1);

% Define a, b and e
a = 0;
b = 1;

showPlot = true;

%e = 10^-2;
%e = 10^-4;
e = 10^-10;
delta = 10^-6;

modified = false;

if showPlot
    plotFunction(f)
end

% Call the minimizationMethod with the parameters and the function handle
[result, count] = minimizationMethod(a, b, e, delta, f, true, showPlot, modified);

% Display the result
disp(' ')
disp('Result:')
disp(['x*: ', num2str(result, 10)]);
disp(['f*: ', num2str(f(result), 10)]);
disp(['N: ', num2str(count)]);

% Using fminbnd
options = optimset('TolX', e);
%profile on;
[x_min, f_min] = fminbnd(f, a, b, options);
%profile off;
%profile report;
disp(['fminbnd x*: ', num2str(x_min, 10)]);
disp(['fminbnd f*: ', num2str(f_min, 10)]);

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

