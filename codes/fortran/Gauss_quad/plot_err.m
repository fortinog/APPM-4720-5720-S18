% Simple program for generating a plot

x = load('out.txt');

set(gca,'fontsize',18)
loglog(x(:,1),x(:,3),'o-',x(:,1),x(:,1).^(-2),'k--','linewidth',2)
xlabel('number of gridpoints')
ylabel('Maximum error')
legend('Computed error','n^{-2}')

print -depsc2 error_v1
print -dpng error_v1

exit