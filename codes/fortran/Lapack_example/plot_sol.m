a = dir('u*.txt');

u = load(a(1).name);
x = linspace(0,1,length(u));

for i = 1:length(a)
    u = load(a(i).name);
    plot(x,u,'linewidth',2)
    axis([0 1 -1 3])
    drawnow
end
