function result = isInInterval(x, a, b)
  isGreaterThanLowerBound = x > a;

  isLessThanUpperBound = x < b;

  result = isGreaterThanLowerBound & isLessThanUpperBound;
end

function [result, count] = minimizationMethod(a, b, e, f, showPoints, addPointsToPlot)
    % Check if f is a function handle
    if ~isa(f, 'function_handle')
        error('Input f must be a function handle');
    end
    
    variation = (b-a)/4;
    x0 = a;
    f0 = f(x0);
    
    if showPoints
        disp([num2str(x0, 6), ' , ', num2str(f0, 6)])
    end
    if addPointsToPlot
        plot(x0, f0, 'black*')
        %hold on
    end
    count = 1;

    while true
        if showPoints
        disp(' ')
        end
      while true
        x1 = x0 + variation;
        f1 = f(x1);
        count = count + 1;
        if showPoints 
            disp([num2str(x1, 6), ' , ', num2str(f1, 6)])
        end
        if addPointsToPlot 
            plot(x1, f1, 'r*')
            %plot(x0, f0, 'r*')
            pause(1);
            %plot(x0, f0, 'b*')
            plot(x1, f1, 'black*')
            %hold on
        end
        if f0 > f1
            x0 = x1;
            f0 = f1;

            if not(isInInterval(x0, a, b))
                break;
            end
        else
            break;
        end

      end

      if abs(variation) <= e
        result = x0;
        break;
      else
          x0 = x1;
          f0 = f1;
          variation = -variation/4;
      end
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

if showPlot 
    plot(result, f(result), 'r*')
end

function plotFunction(f)
  % Plot the function
  fplot(f,[0,1])
  hold on
  %plot(pointX, pointY, 'r*')
  xlabel('x')
  ylabel('y')
  title('Plot of the Function')
  grid on
end