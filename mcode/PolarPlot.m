
clear all
close all
clc

pace  = 100; % ====================================================== STEP
init  = 1;

T = readtable('wind.csv'); 
T = table2array(T);

dir  = T(:,2);
vel  = T(:,3);

t     = linspace(1,length(dir),length(dir));
dir_r = ((2*3.14159265)/360).*dir;

%% Interpolation ----------------------------------------------------------

theta = dir_r;
rho   = vel;
z     = t;
[x,y,z] = pol2cart(theta,rho,z);

t_s = 1:0.1:length(z);
%t_s = 1:1:length(z);
z_s = t_s;

x_s1 = spline(z,x);
x_s = ppval(z_s,x_s1);

y_s1 = spline(z,y);
y_s = ppval(z_s,y_s1);

expone_s = (z_s.^40)./(10.^160);
expone = (t.^40)./(10.^160);

%% 3D Plot -- INTERPOLATED ------------------------------------------------

figure(1)
set(gcf,'Position',[100 100 550 500])
xlabel('wind speed [Km/h]')
ylabel('wind speed [Km/h]')
zlabel('records')
max_wind_speed = 70;

    for(i=1:10:max_wind_speed+10)
        hold on
        r=i-1;
        x0=0;
        y0=0;
        theta = linspace(0,2*pi,100);
        plot3(x0 + r*cos(theta),...
              y0 + r*sin(theta),...
              ones(length(theta)),...
              'Color',[0.8 0.8 0.8],'Linewidth',0.5)
    end

    for (i=1:22.5:360)
        temp = ((2*3.14159265)/360).*(i-1);
        plot3([0 cos(temp)*max_wind_speed],...
              [0 sin(temp)*max_wind_speed],...
              [0 0],'--','Color',[0.8 0.8 0.8],'Linewidth',0.5)
        hold on
    end

    cost = max_wind_speed + 5;

    temp = ((2*3.14159265)/360).*0;
    text(cos(temp)*cost, sin(temp)*cost,0,'N','horizontalalignment', 'center')
    temp = ((2*3.14159265)/360).*-22.5;
    text(cos(temp)*cost, sin(temp)*cost,0,'NNE','horizontalalignment', 'center')
    temp = ((2*3.14159265)/360).*-45;
    text(cos(temp)*cost, sin(temp)*cost,0,'NE','horizontalalignment', 'center')
    temp = ((2*3.14159265)/360).*-67.5;
    text(cos(temp)*cost, sin(temp)*cost,0,'ENE','horizontalalignment', 'center')
    temp = ((2*3.14159265)/360).*-90;
    text(cos(temp)*cost, sin(temp)*cost,0,'E','horizontalalignment', 'center')
    temp = ((2*3.14159265)/360).*-112.5;
    text(cos(temp)*cost, sin(temp)*cost,0,'ESE','horizontalalignment', 'center')
    temp = ((2*3.14159265)/360).*-135;
    text(cos(temp)*cost, sin(temp)*cost,0,'SE','horizontalalignment', 'center')
    temp = ((2*3.14159265)/360).*-157.5;
    text(cos(temp)*cost, sin(temp)*cost,0,'SSE','horizontalalignment', 'center')
    temp = ((2*3.14159265)/360).*-180;
    text(cos(temp)*cost, sin(temp)*cost,0,'S','horizontalalignment', 'center')
    temp = ((2*3.14159265)/360).*-202.5;
    text(cos(temp)*cost, sin(temp)*cost,0,'SSW','horizontalalignment', 'center')
    temp = ((2*3.14159265)/360).*-225;
    text(cos(temp)*cost, sin(temp)*cost,0,'SW','horizontalalignment', 'center')
    temp = ((2*3.14159265)/360).*-247.5;
    text(cos(temp)*cost, sin(temp)*cost,0,'WSW','horizontalalignment', 'center')
    temp = ((2*3.14159265)/360).*-270;
    text(cos(temp)*cost, sin(temp)*cost,0,'W','horizontalalignment', 'center')
    temp = ((2*3.14159265)/360).*-292.5;
    text(cos(temp)*cost, sin(temp)*cost,0,'WNW','horizontalalignment', 'center')
    temp = ((2*3.14159265)/360).*-315;
    text(cos(temp)*cost, sin(temp)*cost,0,'NW','horizontalalignment', 'center')
    temp = ((2*3.14159265)/360).*-337.5;
    text(cos(temp)*cost, sin(temp)*cost,0,'NW','horizontalalignment', 'center')

title('3D Polar Plot, Wind Velocity Vs. Wind Direction Vs. Records')
y_s=-y_s;
plot3(x_s,y_s,z_s)
h = surface([x_s(:), x_s(:)],...
            [y_s(:), y_s(:)],...
            [z_s(:), z_s(:)],...
            [expone_s(:), expone_s(:)],...
            'EdgeColor','interp', 'FaceColor','interp','Linewidth',3);
colormap(parula);
daspect([1 1 60])
grid on
view(-90,90)

for(i=1:10:max_wind_speed+10)
    hold on
    r=i-1;
    x0=0;
    y0=0;
    theta = linspace(0,2*pi,100);
    plot3(x0 + r*cos(theta),y0 + r*sin(theta),ones(length(theta))+max(z_s),'Color',[0.8 0.8 0.8],'Linewidth',0.7)
end
for (i=1:22.5:360)
    temp = ((2*3.14159265)/360).*(i-1);
    plot3([0 cos(temp)*max_wind_speed],[0 sin(temp)*max_wind_speed],[max(z_s) max(z_s)],'--','Color',[0.8 0.8 0.8],'Linewidth',0.7)
    hold on
end

text( 0,0,max(z_s), '0','horizontalalignment', 'center')
text(10,0,max(z_s),'10','horizontalalignment', 'center')
text(20,0,max(z_s),'20','horizontalalignment', 'center')
text(30,0,max(z_s),'30','horizontalalignment', 'center')
text(40,0,max(z_s),'40','horizontalalignment', 'center')
text(50,0,max(z_s),'50','horizontalalignment', 'center')
text(60,0,max(z_s),'60','horizontalalignment', 'center')

%% Discretization ---------------------------------------------------------
layer = 0;
p1 = floor(length(z_s)./pace);
p2 = p1.*pace;
p3 = length(z_s)-p2+1;
x_s = x_s(p3:length(x_s));
y_s = y_s(p3:length(y_s));
z_s = z_s(p3:length(z_s));
expone_s = (z_s.^40)./(10.^160);

for i = 1:pace:length(z_s)
    z_s(i)   = layer;
    for j = 1:(pace-1)
        z_s(i+j) = layer;
    end
    layer  = layer + pace;
end
hold off

%% Trisurf Plot -----------------------------------------------------------

h = figure(2)
x=x_s;
y=y_s;
z=z_s;
expone=expone_s;

plot3(0,0,0);
set(gcf,'Position',[100 100 550 500])

title('3D Polar Plot, Wind Velocity Vs. Wind Direction Vs. Records')
xlabel('wind speed [Km/h]')
ylabel('wind speed [Km/h]')
zlabel('records')
view(-90,90)
max_wind_speed = 70;

for(i=1:10:max_wind_speed+10)
    hold on
    r=i-1;
    x0=0;
    y0=0;
    theta = linspace(0,2*pi,100);
    plot3(x0 + r*cos(theta),y0 + r*sin(theta),ones(length(theta)),'Color',[0.8 0.8 0.8],'Linewidth',0.7)
end

for (i=1:22.5:360)
    temp = ((2*3.14159265)/360).*(i-1);
    plot3([0 cos(temp)*max_wind_speed],[0 sin(temp)*max_wind_speed],[0 0],'--','Color',[0.8 0.8 0.8],'Linewidth',0.7)
    hold on
end

cost = max_wind_speed + 5;

temp = ((2*3.14159265)/360).*0;
text(cos(temp)*cost, sin(temp)*cost,0,'N','horizontalalignment', 'center')
temp = ((2*3.14159265)/360).*-22.5;
text(cos(temp)*cost, sin(temp)*cost,0,'NNE','horizontalalignment', 'center')
temp = ((2*3.14159265)/360).*-45;
text(cos(temp)*cost, sin(temp)*cost,0,'NE','horizontalalignment', 'center')
temp = ((2*3.14159265)/360).*-67.5;
text(cos(temp)*cost, sin(temp)*cost,0,'ENE','horizontalalignment', 'center')
temp = ((2*3.14159265)/360).*-90;
text(cos(temp)*cost, sin(temp)*cost,0,'E','horizontalalignment', 'center')
temp = ((2*3.14159265)/360).*-112.5;
text(cos(temp)*cost, sin(temp)*cost,0,'ESE','horizontalalignment', 'center')
temp = ((2*3.14159265)/360).*-135;
text(cos(temp)*cost, sin(temp)*cost,0,'SE','horizontalalignment', 'center')
temp = ((2*3.14159265)/360).*-157.5;
text(cos(temp)*cost, sin(temp)*cost,0,'SSE','horizontalalignment', 'center')
temp = ((2*3.14159265)/360).*-180;
text(cos(temp)*cost, sin(temp)*cost,0,'S','horizontalalignment', 'center')
temp = ((2*3.14159265)/360).*-202.5;
text(cos(temp)*cost, sin(temp)*cost,0,'SSW','horizontalalignment', 'center')
temp = ((2*3.14159265)/360).*-225;
text(cos(temp)*cost, sin(temp)*cost,0,'SW','horizontalalignment', 'center')
temp = ((2*3.14159265)/360).*-247.5;
text(cos(temp)*cost, sin(temp)*cost,0,'WSW','horizontalalignment', 'center')
temp = ((2*3.14159265)/360).*-270;
text(cos(temp)*cost, sin(temp)*cost,0,'W','horizontalalignment', 'center')
temp = ((2*3.14159265)/360).*-292.5;
text(cos(temp)*cost, sin(temp)*cost,0,'WNW','horizontalalignment', 'center')
temp = ((2*3.14159265)/360).*-315;
text(cos(temp)*cost, sin(temp)*cost,0,'NW','horizontalalignment', 'center')
temp = ((2*3.14159265)/360).*-337.5;
text(cos(temp)*cost, sin(temp)*cost,0,'NW','horizontalalignment', 'center')

c1 = parula(256);

c1(251,1) = c1(150,1);
c1(251,2) = c1(150,2);
c1(251,3) = c1(150,3);
 
c1(252,1) = c1(170,1);
c1(252,2) = c1(170,2);
c1(252,3) = c1(170,3);
 
c1(253,1) = c1(190,1);
c1(253,2) = c1(190,2);
c1(253,3) = c1(190,3);
 
c1(254,1) = c1(210,1);
c1(254,2) = c1(210,2);
c1(254,3) = c1(210,3);
 
c1(255,1) = c1(230,1);
c1(255,2) = c1(230,2);
c1(255,3) = c1(230,3);
 
for i=231:250        
   c1(i,1) = c1(15,1);
   c1(i,2) = c1(15,2);
   c1(i,3) = c1(15,3);
end
 
for i=1:230      
   c1(i,1) = c1(1,1);
   c1(i,2) = c1(1,2);
   c1(i,3) = c1(1,3);
end

%c = parula(256);
%c =((c+1.999).^30)/(20.^11);
c = c1;

for (i = init:pace:length(x))
    x1 = x(i:i+pace-1)';
    y1 = y(i:i+pace-1)';
    z1 = z(i:i+pace-1);
    expone1 = expone(i:i+pace-1);
    
    dt = delaunayTriangulation(x1,y1) ;
    tri = dt.ConnectivityList ;
    xi = dt.Points(:,1) ; 
    yi = dt.Points(:,2) ; 
    F = scatteredInterpolant(x1,y1,z1');
    zi = F(xi,yi) ;
  
    h = trisurf(tri,xi,yi,zi); 
    colormap(c);
    
    shading flat
    
    pause(0);
    
    hold on 
    clc
    disp(string(i)+'/'+string(length(x)))
    
    %saveas(h,sprintf('FIG%d.png',i));  % ********************************** SAVE
    
    k=i;
    
end

daspect([1 1 600])

for(i=1:10:max_wind_speed+10)
    hold on
    r=i-1;
    x0=0;
    y0=0;
    theta = linspace(0,2*pi,100);
    plot3(x0 + r*cos(theta),y0 + r*sin(theta),ones(length(theta))+max(z_s),'Color',[0.8 0.8 0.8],'Linewidth',0.7)
end
for (i=1:22.5:360)
    temp = ((2*3.14159265)/360).*(i-1);
    plot3([0 cos(temp)*max_wind_speed],[0 sin(temp)*max_wind_speed],[max(z_s) max(z_s)],'--','Color',[0.8 0.8 0.8],'Linewidth',0.7)
    hold on
end

text( 0,0,max(z_s), '0','horizontalalignment', 'center')
text(10,0,max(z_s),'10','horizontalalignment', 'center')
text(20,0,max(z_s),'20','horizontalalignment', 'center')
text(30,0,max(z_s),'30','horizontalalignment', 'center')
text(40,0,max(z_s),'40','horizontalalignment', 'center')
text(50,0,max(z_s),'50','horizontalalignment', 'center')
text(60,0,max(z_s),'60','horizontalalignment', 'center')
view(-90,90)

%saveas(h,sprintf('FIG%d.png',k)); % ********************************** SAVE

