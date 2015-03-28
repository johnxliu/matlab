%Asume una onda transversal electrica
%CTES
%%%%%%%%%%%%%%%%%%%%
lo=632.8e-9;    %longitud de onda
c=3e8;          %velocidad de la luz
tau=lo/c;       %periodo de la onda
epsilonr=3;

paso=100;
%t0=20*tau;     %tiempo del maximo del pulso gaussiano
sigma=10;%2*tau;  %dispersion del pulso
dx=lo/10;       %tama�o del intervalo espacial
t0=20*dx*1e6;
J=@(t)2*exp(-0.5*((t-t0)/sigma).^2);  %puslo gaussiano como fuente
%J=@(x)sin(x*2*pi);
dt=dx/(2*c);   %tama�o d10el intervalo temporal
dy=dx;         %cuadrado
nx=300; nt=500; ny=nx;%n�mero de nodos espaciales y temporales
t=0;            %tiempo inicial  
x=dx*(1:nx)*1e6;%creamos las posiciones en micras
%inicializa los vectores de campo E y H (mas rapido que E(1:nz)=0
E=zeros(nx,ny); Hx=zeros(nx,ny); Hy=zeros(nx,ny);

%E(200,70:85)=cos(0.05*x(200:215)); %campo inicial

epsilon=epsilonr*fliplr(tril(ones(nx,ny),0)) + ~fliplr(tril(ones(nx,ny),0));

%condiciones de contorno absorbente
low1=zeros(1,nx);
low2=zeros(1,nx);
high2=zeros(1,nx);
high1=zeros(1,nx);
low11=zeros(1,nx);
low22=zeros(1,nx);
high22=zeros(1,nx);
high11=zeros(1,nx);

xf=nx*dx*1e6; %posicion final

%PREPARA GRAFICAS
figure(1)
colormap('jet')
axis image

for n=1:nt
    for i=2:nx-1 %Calcula E en todos los puntos menos en los extremos
        for j=2:ny-1
          E(i,j)=E(i,j)+0.5/epsilon(i,j)*( Hx(i,j-1)-Hx(i,j)-Hy(i,j)+Hy(i-1,j) );
        end
    end

    %Inserta fuente en el centro
    %E(150,100:150)=E(150,100:150)+J(t)*exp(-((x(100:150)-x(125))/20).^2)+J(t)*exp(-((x(100:150)-x(125))/20).^2)+exp(-((x(100:150)-x(125))/20).^2);
    %size([J(t)*exp(-((x(80:100)-x(125))/20).^2) ,J(t)*ones(1,49) , J(t)*exp(-((x(150:170)-x(125))/20).^2)])
    %size(E(150,80:170))
    E(100,80:170)=E(100,80:170)+[J(t)*exp(-((x(80:100)-x(125))/20).^2) ,J(t)*ones(1,49) , J(t)*exp(-((x(150:170)-x(125))/20).^2)];
    %E(101,80:170)=E(100,80:170)+[J(t)*exp(-((x(80:100)-x(125))/20).^2) ,J(t)*ones(1,49) , J(t)*exp(-((x(150:170)-x(125))/20).^2)];
    %E(102,80:170)=E(100,80:170)+[J(t)*exp(-((x(80:100)-x(125))/20).^2) ,J(t)*ones(1,49) , J(t)*exp(-((x(150:170)-x(125))/20).^2)];
    %condiciones de contorno absorbentes
    E(:,1) = low2;
    low2 = low1;
    low1 = E(:,2);
    E(:,nx)= high2;
    high2= high1;
    high1= E(:,nx-1);
    %------------------------
    E(1,:) = low22;
    low22 = low11;
    low11 = E(2,:);
    E(nx,:)= high22;
    high22= high11;
    high11= E(nx-1,:);
    
    for i=1:nx-1 %Calcula H menos en el extremo derecho
        for j=1:ny-1
            Hx(i,j)=Hx(i,j)+0.5*( E(i,j)-E(i,j+1) );
            Hy(i,j)=Hy(i,j)+0.5*( E(i,j)-E(i+1,j) );
          
        end
    end
    
    t=n*dt; %incrementa tiempo
    
    %GRAFICAS
    if not(mod(n,paso))
      imagesc([0 xf],[0 xf],E)
      colorbar()
      axis image
      pause;
    end
end
     
close all
