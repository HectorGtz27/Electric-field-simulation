%El código muestra cómo generar una visualización del campo eléctrico creado por dos placas paralelas, una negativa y una positiva, 
% usando flechas para representar la dirección y magnitud del campo. El usuario ingresa los largos de las placas y el código establece los 
% límites del eje x y y para mostrar la visualización de manera adecuada. El código usa la ley de Coulomb y la densidad de carga en las placas 
% para calcular el campo eléctrico en cada punto de una grilla definida por la función "meshgrid". Luego, se utilizan las componentes "x" y "y" 
% del campo eléctrico para crear una visualización de flechas que representan la dirección y magnitud del campo eléctrico en cada punto de la
% grilla. Por último, se dibujan las placas negativa y positiva como rectángulos azul y rojo respectivamente, junto con textos que representan 
% las cargas.

%Estas líneas borran todas las variables previas, cierran todas las figuras abiertas y limpian la ventana de comandos.
clear; close all; clc;

%Aquí se solicita al usuario ingresar los largos de las dos placas.
l_negativa = input('Ingresa el largo de la placa negativa (placa corta): ');
l_positiva = input('Ingresa el largo de la placa positiva (placa larga): ');

%La variable l define el factor de zoom para la visualización de la figura y la variable N especifica la cantidad de flechas que se utilizan para visualizar el campo eléctrico.
l=10; % Zoom
N=20; % Número de flechas

%Aquí se definen las coordenadas de los puntos en los que se evaluará el campo eléctrico, creando una malla de puntos a lo largo del eje x y el eje y utilizando la función meshgrid().
minX=-15; maxX=15;
%Esto es importante para que quede centrado, por lo tanto es una mitad para
%arriba y otra mitad para abajo.
%Ahora en minY, donde termina la placa bajate 5
%En maxY, donde termina la placa subete 5
minY=-5-l/2; maxY=5+l/2;
x=linspace(minX,maxX,N);
y=linspace(minY,maxY,N);
[xG,yG]=meshgrid(x,y);

%Estas líneas definen las coordenadas (x,y) de los centros de las placas negativa y positiva respectivamente.
xCn=-5;    yCn=0;
xCp=5;    yCp=0;

%Aquí se definen las densidades de carga Qn y Qp de las placas negativa y positiva respectivamente, la permitividad eléctrica del vacío eps0 
% y la constante de Coulomb kC.
Qn=-l_negativa; %carga negativa
Qp= l_positiva; %carga positiva
eps0 = 8.854e-12; %constante electrica
kC = 1/(4*pi*eps0);%constante de Coulomb kC

%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%Este es un bucle "for" que itera desde -l_negativa/2 hasta l_negativa/2 con un incremento de 1 en cada iteración. 
% La variable "i" se utiliza para representar la posición en el eje y de cada placa (ya sea la placa negativa o la positiva). 
% El propósito de este bucle es calcular el campo eléctrico en cada punto de la cuadrícula (o grid) generado por la función "meshgrid" para las 
% dos placas (negativa y positiva) en cada posición "i" a lo largo del eje y, utilizando las forumulas del campo electrico de Coulomb 
% y la Ley de Gauss

%Auxiliares
Ex=0; %Componente x del campo electrcio
Ey=0;%Componente y del campo electrico

for(i=-l_negativa : 1 : l_negativa)
    %MUCHO OJO ambas cargas estan creando cargas, por eso se suman todos
    %contra todos y se crea ese flujo electrico
    
    % Campo placa negativa
    %Aqui en esta parte se calcula la distancia
    Rx = xG - xCn;
    %Aqui se divide la longitud entre la densidad, porque lo va comparar
    %para ver con que placa esta mas cercana y esto lo con cada punto de i
    Ry = yG - i*l_negativa/N;

    %Este cubo sale porque se divide entre su magnitud en la formula de
    %campo electrico y se divide para que el vector sea unitario, para que
    %siga esa direccion.  sqrt(Rx.^2 + Ry.^2) esto es mi r
    R = sqrt(Rx.^2 + Ry.^2).^3;

    %Aqui se tiene una de las cargas porque como se esta trabajando sacando el campo electrico que ejerce la carga negativa, por eso 
    % nomas aparece la negativa, por lo tanto la carga negativa esta
    % ejerciendo el campo aqui. El campo electrico es vectorial por eso las
    % flechas van cambiando acorde de lo que se de.
    %Aqui si se esta diviendo entre r cubica como dice en la formula =,
    %nomas que como aqui R = sqrt(Rx.^2 + Ry.^2).^3; ya se puso al cubo no
    %se ocupa ponerlo. Aqui se suman los componente en x y en y.
    
    
    Ex = Ex+kC .* Qn .* Rx ./ R; 
    Ey = Ey+kC .* Qn .* Ry ./ R;

    % Campo placa positiva
    %Aqui tambien es igual nomas que cambio la poscion a la posicion de la
    %carga positiva 
    Rx = xG - xCp;
    Ry = yG - i*l_positiva/N;

    %Aqui tambien es igual nomas que cambio la carga a la de la
    %carga positiva 
    R = sqrt(Rx.^2 + Ry.^2).^3;

    %Mas exacto: Lo que ya se tenia de la negativa de Ex sumaselo con lo
    %que se genero con la positiva que es + kC .* Qp .* Rx ./ R;
    Ex = Ex + kC .* Qp .* Rx ./ R;

    %Mas exacto: Lo que ya se tenia de la negativa de Ey sumaselo con lo
    %que se genero con la positiva que es + kC .* Qp .* Ry ./ R
    Ey = Ey + kC .* Qp .* Ry ./ R;

    %Ahora se saca el resultante del campo electrico
    E = sqrt(Ex.^2 + Ey.^2);
end;

% Componentes "x" y "y"
%Esto indica para donde van ir las flechitas y se hace para que todas las
%flechitas queden del mismo tamaño
u=Ex./E;
v=Ey./E;

% Creación de la figura
figure();
% Grafica las flechas del campo eléctrico
h=quiver(xG,yG,u,v, 'autoscalefactor',0.6);
% Establece el color y el grosor de las flechas
set(h,'color',[0 0.5 0.5], 'linewidth',1.5);
% Establece los límites del eje "x" y "y"
axis([-7 7 -l_negativa/2-5 l_positiva/2+5]);
% Establece que la gráfica sea proporcional en ambos ejes
axis equal;
% Activa el borde del cuadro de la figura
box on;

% Dibuja la placa negativa como un rectángulo azul con el tamaño y la posición dada
h=rectangle('Position',[-6, -l_negativa/2,2,l_negativa]); 
set(h,'Facecolor',[0.5 0.5 1],'Edgecolor',[0.5 0.5 1]);
% Añade un texto para representar la placa negativa
text(-5.5, 0,'-','Color','white','FontSize',40);

% Dibuja la placa positiva como un rectángulo rojo con el tamaño y la posición dada
h=rectangle('Position',[4, -l_positiva/2,2,l_positiva]); % Placa positiva
set(h,'Facecolor',[1 0.5 0.5],'Edgecolor',[1 0.5 0.5]);
% Añade un texto para representar la placa positiva
text(4.3, 0,'+','Color','white','FontSize',35);


