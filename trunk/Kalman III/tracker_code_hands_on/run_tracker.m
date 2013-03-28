% Limpiando info. persistente de anteriores ejecuciones
%clear all

% A�adiendo rutas de b�squeda al path
cd src;
addpath(pwd);
cd lap;
addpath(pwd);
cd ..;
cd suptitle;
addpath(pwd);
cd ../..;


% Load parameters for Kalman tracking
kalparam = kalman_parameters(); 

% Finally, run the algorithm with the given data and parameters. 
track(kalparam);




