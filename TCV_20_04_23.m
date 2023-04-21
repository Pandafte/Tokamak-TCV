% Change this to suit your installation
home='/home/yafte/Documentos/Servicio Social/Fiesta_8_Mar_2023/Fiesta_V8.10_B';
disp(home)
addpath([home '/Source'], '-end');
addpath([home '/Source/Pde'], '-end');
addpath([home '/Source/Tokamak'], '-end');
addpath([home '/Data/demo'], '-end');
%addpath(['C:/Users/fgaon/Downloads/Matlab Pruebas/'], '-end');
warning off backtrace
warning off verbose

close all
clear all
%% Grid

%fiddle the grid slightly to avoid NaNs in GridCoil mutual
grid=fiesta_grid(0.01,3, 2^9+1, -1.31, 1.31, 2^7+1);
plasma_ini=[0.61 0];


%% Coilset

%generate set of coils

%Solenoid
    f=fiesta_filament(0.015*ones(1, 100),linspace(-0.75, 0.75, 100), 0.01, 0.01); %(,Extensiónvertical,anchocuadros,altocuadros)
    solenoid_coil=fiesta_coil('solenoid_coil', f);
    solenoid_circuit=fiesta_circuit('solenoid', 1, solenoid_coil);

%PF Coils Dx
    r=linspace(0.8, 0.9, 5);
z=linspace(1.2, 1.3, 5);
    [r, z]=meshgrid(r, z);
f=fiesta_filament(r(:)', z(:)', 0.02, 0.02); %(,,dx,dy)
upper_Dx_coil=fiesta_coil('Dx', f);
lower_Dx_coil=reflect(upper_Dx_coil);
 
upper_Dx_circuit=fiesta_circuit('upper_Dx', 1, upper_Dx_coil);
lower_Dx_circuit=fiesta_circuit('lower_Dx', 1, lower_Dx_coil);   
    
 %PF Coils Cx
    r=linspace(0.6, 0.7, 5);
z=linspace(1, 1.1, 5);
    [r, z]=meshgrid(r, z);
f=fiesta_filament(r(:)', z(:)', 0.02, 0.02);
upper_cx_coil=fiesta_coil('cx', f);
lower_cx_coil=reflect(upper_cx_coil);
 
upper_cx_circuit=fiesta_circuit('upper_cx', 1, upper_cx_coil);
lower_cx_circuit=fiesta_circuit('lower_cx', 1, lower_cx_coil);
   
    
 %PF Coils
    r=linspace(1.2, 1.3, 5);
z=linspace(0.75, 0.85, 5);
    [r, z]=meshgrid(r, z);
f=fiesta_filament(r(:)', z(:)', 0.02, 0.02);
upper_bv_coil=fiesta_coil('bv', f);
lower_bv_coil=reflect(upper_bv_coil);

    %put the upper and lower bv coils into separate circuits so they can be used for Z control
upper_bv_circuit=fiesta_circuit('upper_bv', 1, upper_bv_coil);
lower_bv_circuit=fiesta_circuit('lower_bv', 1, lower_bv_coil);
   
%PF Coils 2
    r=linspace(1.2, 1.3, 5);
z=linspace(0.6, 0.7, 5);
    [r, z]=meshgrid(r, z);
f=fiesta_filament(r(:)', z(:)', 0.02, 0.02);
upper_bv_coil2=fiesta_coil('bv2', f);
lower_bv_coil2=reflect(upper_bv_coil2);

    %put the upper and lower bv coils into separate circuits so they can be used for Z control
upper_bv_circuit2=fiesta_circuit('upper_bv2', 1, upper_bv_coil2);
lower_bv_circuit2=fiesta_circuit('lower_bv2', 1, lower_bv_coil2);
   
%PF Coils 3
    r=linspace(1.2, 1.3, 5);
z=linspace(0.2, 0.3, 5);
    [r, z]=meshgrid(r, z);
f=fiesta_filament(r(:)', z(:)', 0.02, 0.02);
upper_bv_coil3=fiesta_coil('bv3', f);
lower_bv_coil3=reflect(upper_bv_coil3);

    %put the upper and lower bv coils into separate circuits so they can be used for Z control
upper_bv_circuit3=fiesta_circuit('upper_bv3', 1, upper_bv_coil3);
lower_bv_circuit3=fiesta_circuit('lower_bv3', 1, lower_bv_coil3);
   
%PF Coils 4
    r=linspace(1.2, 1.3, 5);
z=linspace(0.35, 0.45, 5);
    [r, z]=meshgrid(r, z);
f=fiesta_filament(r(:)', z(:)', 0.02, 0.02);
upper_bv_coil4=fiesta_coil('bv4', f);
lower_bv_coil4=reflect(upper_bv_coil4);

    %put the upper and lower bv coils into separate circuits so they can be used for Z control
upper_bv_circuit4=fiesta_circuit('upper_bv4', 1, upper_bv_coil4);
lower_bv_circuit4=fiesta_circuit('lower_bv4', 1, lower_bv_coil4);

%Bobinas adicionales traseras

 
 %PF Coils
    r=linspace(0.4, 0.5, 5);
z=linspace(0.75, 0.85, 5);
    [r, z]=meshgrid(r, z);
f=fiesta_filament(r(:)', z(:)', 0.02, 0.02);
upper_dv_coil=fiesta_coil('dv', f);
lower_dv_coil=reflect(upper_dv_coil);

    %put the upper and lower bv coils into separate circuits so they can be used for Z control
upper_dv_circuit=fiesta_circuit('upper_dv', 1, upper_dv_coil);
lower_dv_circuit=fiesta_circuit('lower_dv', 1, lower_dv_coil);
   
%PF Coils 2
    r=linspace(0.4, 0.5, 5);
z=linspace(0.6, 0.7, 5);
    [r, z]=meshgrid(r, z);
f=fiesta_filament(r(:)', z(:)', 0.02, 0.02);
upper_dv_coil2=fiesta_coil('dv2', f);
lower_dv_coil2=reflect(upper_dv_coil2);

    %put the upper and lower bv coils into separate circuits so they can be used for Z control
upper_dv_circuit2=fiesta_circuit('upper_dv2', 1, upper_dv_coil2);
lower_dv_circuit2=fiesta_circuit('lower_dv2', 1, lower_dv_coil2);
   
%PF Coils 3
    r=linspace(0.4, 0.5, 5);
z=linspace(0.2, 0.3, 5);
    [r, z]=meshgrid(r, z);
f=fiesta_filament(r(:)', z(:)', 0.02, 0.02);
upper_dv_coil3=fiesta_coil('dv3', f);
lower_dv_coil3=reflect(upper_dv_coil3);

    %put the upper and lower bv coils into separate circuits so they can be used for Z control
upper_dv_circuit3=fiesta_circuit('upper_dv3', 1, upper_dv_coil3);
lower_dv_circuit3=fiesta_circuit('lower_dv3', 1, lower_dv_coil3);
   
%PF Coils 4
    r=linspace(0.4, 0.5, 5);
z=linspace(0.35, 0.45, 5);
    [r, z]=meshgrid(r, z);
f=fiesta_filament(r(:)', z(:)', 0.02, 0.02);
upper_dv_coil4=fiesta_coil('dv4', f);
lower_dv_coil4=reflect(upper_dv_coil4);

    %put the upper and lower bv coils into separate circuits so they can be used for Z control
upper_dv_circuit4=fiesta_circuit('upper_dv4', 1, upper_dv_coil4);
lower_dv_circuit4=fiesta_circuit('lower_dv4', 1, lower_dv_coil4);


%Divertor Coils
r=linspace(0.6, 0.7, 5);
z=linspace(0.75, 0.85, 5);
[r, z]=meshgrid(r, z);
f=fiesta_filament(r(:)', z(:)', 0.02, 0.02);
upper_divertor_coil=fiesta_coil('divertor', f);
lower_divertor_coil=reflect(upper_divertor_coil);
upper_divertor_circuit=fiesta_circuit('upper_divertor_circuit', 1, upper_divertor_coil);
    lower_divertor_circuit=fiesta_circuit('lower_divertor_circuit', 1, lower_divertor_coil);

%coilset=fiesta_coilset('Tokamak', [solenoid_circuit, upper_bv_circuit, lower_bv_circuit, upper_bv_circuit2, lower_bv_circuit2, upper_bv_circuit3, lower_bv_circuit3, upper_bv_circuit4, lower_bv_circuit4, divertor_circuit], 0, 0.046, 0);
coilset=fiesta_coilset('Tokamak', [solenoid_circuit, upper_bv_circuit, lower_bv_circuit, upper_bv_circuit2, lower_bv_circuit2, upper_bv_circuit3, lower_bv_circuit3, upper_bv_circuit4, lower_bv_circuit4, upper_cx_circuit, lower_cx_circuit, upper_Dx_circuit, lower_Dx_circuit, upper_divertor_circuit, lower_divertor_circuit, upper_dv_circuit, lower_dv_circuit, upper_dv_circuit2, lower_dv_circuit2, upper_dv_circuit3, lower_dv_circuit3, upper_dv_circuit4, lower_dv_circuit4], 0, plasma_ini(1), plasma_ini(2));
%% Vessel

    %[x,y]=shape_fun(200,0,0,[1,1,0,-0.5]);
   figure  
   %x=[x(1,1:50) x(1,151:200)];
   %y=[y(1,1:50) y(1,151:200)];
   %x=x+0.0623;
   f=fiesta_filament([1.006 1.169 0.843 0.68 0.517],0.75*[1 1 1 1 1],0.1571,0.05);
   passive=fiesta_passive('CAM1',f); %Barrera Superior
   f1=fiesta_filament(0.5*[1 1 1 1 1],[0.732 0.569 0.406 0.243 0.08],0.05,0.1571);
   passive1=fiesta_passive('CORE_UP',f1); %Lateral Inferior Izquierdo
   f2=fiesta_filament(0.5*[1 1 1 1 1],-[0.732 0.569 0.406 0.243 0.08],0.05,0.1571);
   passive2=fiesta_passive('CORE_DOWN',f2); %Laterial Superior Izquierdo
   f3=fiesta_filament([1.006 1.169 0.843 0.68 0.517],0.75*[-1 -1 -1 -1 -1],0.1571,0.05);
   passive3=fiesta_passive('CAM2',f3); %Barrera Inferior
   f4=fiesta_filament(1.2*[1 1 1 1 1],[0.732 0.569 0.406 0.243 0.08],0.05,0.1571);
   passive4=fiesta_passive('CORE_UP_2',f4); %Lateral Superior Derecho
   f5=fiesta_filament(1.2*[1 1 1 1 1],-[0.732 0.569 0.406 0.243 0.08],0.05,0.1571);
   passive5=fiesta_passive('CORE_DOWN_2',f5); %Lateral Inferior Derecho
   nmodes=5;
      passive=set(passive, 'nmodes', nmodes);
      passive1=set(passive1, 'nmodes', 1);
      passive2=set(passive2, 'nmodes', 1);
      passive3=set(passive3, 'nmodes', 1);
      passive4=set(passive4, 'nmodes', 1);
      passive5=set(passive5, 'nmodes', 1);
   vessel=fiesta_vessel('E_Tokamak',[passive passive1 passive2 passive3 passive4 passive5]);

   plot(vessel)
   %x=x-0.0623;
   %plot(x',y','o')
   %x=x+0.0623;
%% Config

sim_ini=0.7;
% Rgrid=get(grid, 'r');
% Zgrid=get(grid, 'z');
% badcircuit=fiesta_circuit('Bad', 1, fiesta_coil('Bad', fiesta_filament(Rgrid(5)+1e-3, Zgrid(5), 0.01, 0.01)))
% coilset=add(coilset, badcircuit);
coilset=fiesta_loadassembly(coilset, vessel);
config=fiesta_configuration('E_Tokamak', grid, coilset, fiesta_point('plasma', 0.7, 0));
% Put in an off-midplane plasma to illustrate instability
% config=fiesta_configuration('Demo', grid, coilset, fiesta_point('plasma', 1.4, 0.001));
%% Fiesta control

%jprofile_a=1e5;
%jprofile_b=1;
%Ip=1e6;
%gam=[1 1];
%jprofile=fiesta_jprofile_lao('generic', jprofile_a, jprofile_b, gam,Ip);
%control=fiesta_control('boundary_method', 2, 'maxiter', 1000);
% In Fiesta the TF is specifed using the total current in the TF system
irod=50e6;
jprofile=fiesta_jprofile_lao('Demo', 1.2e6);
control=fiesta_control;
%% PF Coils Currents
% make an zero icoil object icoil=fiesta_icoil(config, jprofile);

icoil=fiesta_icoil(coilset);
% put some current in the bv circuits
    icoil.solenoid=12942468;

    icoil.upper_Dx=-58995;
    icoil.lower_Dx=-54643;
    
    icoil.upper_cx=49840;
    icoil.lower_cx=45807;
    
    icoil.upper_bv=18358;
    icoil.lower_bv=17598;

    icoil.upper_bv2=-6816;
    icoil.lower_bv2=-6600;

    icoil.upper_bv3=53;
    icoil.lower_bv3=55;

    icoil.upper_bv4=27;
    icoil.lower_bv4=23;

     icoil.upper_dv=-42501;
    icoil.lower_dv=-41888;

    icoil.upper_dv2=20800;
    icoil.lower_dv2=20725;

    icoil.upper_dv3=374;
    icoil.lower_dv3=375;

    icoil.upper_dv4=875;
    icoil.lower_dv4=872;


    %icoil.divertor=8496.24;
    icoil.upper_divertor_circuit=11252.6;
    icoil.lower_divertor_circuit=11600.98;
%% Fiesta Feedback
% for a circular plasma we dont need a feedback object

feedback=fiesta_feedback3(coilset,sim_ini,0);
equil=fiesta_equilibrium('E_Tokamak', config, irod, jprofile, control, feedback, icoil);
ncontour=50;
figure(config)
plot(equil,'psi',ncontour,'color','blue')
%axes(coilset)
plot(coilset)
s=plot(vessel);
set(s, 'EdgeColor', 'k', 'FaceColor', 'none')
plot(equil,'psi',ncontour,'color','blue')
plot(equil,'boundary','color','red','linewidth',2)

if ~converged(equil), return, end

parametersshow(equil)
section(equil);
%% Control Z
% demonstrate use of Z control
Rctrl=0.875;
actrl=0.3;
Zctrl=0;
kappactrl=2.0;
deltactrl=-1;
deltactrl2=0;


%feedback=shape_controller(config, {'upper_bv', 'lower_bv','upper_bv2', 'lower_bv2','upper_bv4', 'lower_bv4','upper_bv3', 'lower_bv3', 'divertor'}, Rctrl, Zctrl, actrl, kappactrl, deltactrl, deltactrl2);
feedback=shape_controller(config, {'solenoid','upper_divertor_circuit', 'lower_divertor_circuit', 'upper_bv', 'lower_bv','upper_bv2', 'lower_bv2','upper_bv4', 'lower_bv4','upper_bv3', 'lower_bv3', 'upper_cx', 'lower_cx', 'upper_Dx', 'lower_Dx', 'upper_dv', 'lower_dv','upper_dv2', 'lower_dv2','upper_dv4', 'lower_dv4','upper_dv3', 'lower_dv3'}, Rctrl, Zctrl, actrl, kappactrl, deltactrl, deltactrl2);
equil3=set(equil, config, 'feedback', feedback);

if converged(equil3)
   figure(config)
   %s=plot(vessel);
   
   plot(coilset)
   %s=plot(vessel);
   %set(s, 'EdgeColor', 'k', 'FaceColor', [0.8 0.8 0.8])
   
   plot(equil3,'psi',ncontour,'color','blue','linewidth',0.5)
   plot(equil3,'boundary','color','red','linewidth',2)
   
   %plot(equil3)
   
   section(equil3);
   parametersshow(equil3)
   parameters(equil3)
   a=max(get(grid,'r'));
   b=min(get(grid,'z'))/3;
   text(a*1.05,-b*3-0.02,'Outputs from Zcontrol','Color','red')
   b=max(get(grid,'z'))-0.07;
   a=-0.4;
   
   %text(a*1.05,b+0.05,'Inputs for Zcontrol','Color','blue')
   %text(a*1.05,b-0.05,['R_0 = ',num2str(Rctrl),' m'])
   %text(a*1.05,b-0.12,['Z_0 = ',num2str(Zctrl),' m'])
   %text(a*1.05,b-0.19,['a_0 = ',num2str(actrl),' m'])
   %text(a*1.05,b-0.26,['\kappa = ',num2str(kappactrl)])
   %text(a*1.05,b-0.33,['\delta = ',num2str(deltactrl)])
   %{
   text(a*1.05,b-0.45,'Other Inputs','color','blue')
   text(a*1.05,b-0.55,['Inicio de sim = ',num2str(sim_ini)])
   text(a*1.05,b-0.62,['a_j_p_r_o_f_i_l_e = ',num2str(jprofile_a)])
   text(a*1.05,b-0.69,['b_j_p_r_o_f_i_l_e = ',num2str(jprofile_b)])
   text(a*1.05,b-0.76,['G_j_p_r_o_f_i_l_e = [',num2str(gam),']'])
   text(a*1.05,b-0.83,['Plasma inicial = [',num2str(plasma_ini(1)),'   ',num2str(plasma_ini(2)),']'])
   
   text(a*1.5,b-1.41,'Bobinas                  r                 z','color','blue')
   text(a*1.5,b-1.50,['upper\_bv     (',num2str(min(get(upper_bv_circuit, 'r'))),' ,  ',num2str(max(get(upper_bv_circuit, 'r'))),')  (',num2str(min(get(upper_bv_circuit, 'z'))),' ,  ',num2str(max(get(upper_bv_circuit, 'z'))),')'])
   text(a*1.5,b-1.59,['upper\_bv2   (',num2str(min(get(upper_bv_circuit2, 'r'))),' ,  ',num2str(max(get(upper_bv_circuit2, 'r'))),')  (',num2str(min(get(upper_bv_circuit2, 'z'))),' ,  ',num2str(max(get(upper_bv_circuit2, 'z'))),')'])
   text(a*1.5,b-1.68,['upper\_bv3   (',num2str(min(get(upper_bv_circuit3, 'r'))),' ,  ',num2str(max(get(upper_bv_circuit3, 'r'))),')  (',num2str(min(get(upper_bv_circuit3, 'z'))),' ,  ',num2str(max(get(upper_bv_circuit3, 'z'))),')'])
   text(a*1.5,b-1.77,['divertor        (',num2str(min(get(upper_divertor_circuit, 'r'))),' ,  ',num2str(max(get(upper_divertor_circuit, 'r'))),')  (',num2str(min(get(upper_divertor_coil, 'z'))),' ,  ',num2str(max(get(upper_divertor_circuit, 'z'))),')'])
   
%Se describe que se quiere hacer en esta prueba
   text(a*1.5,b-1.92,[date,'     Run 2'],'color','red')
   text(a*1.5,b-2,'Se prueba con la \delta_2=-0.15.','color','blue')
   %}
   %plot(coilset)
else
   disp('failed to converge')
   return
end

%save tokamak config equil equil3
%% RZIP

sensors=newsensors_hf_ulart;
plot(sensors);

rzip_config=fiesta_rzip_configuration('HF_ULART_RZIP', config,[]);%, {sensors});

[A, B, C, D, curlyM, curlyR, gamma, plasma_parameters] = response(rzip_config, equil3);