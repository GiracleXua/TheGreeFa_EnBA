within BrineGrid.Media.LiquidDesiccants.Functions;
function diffusivityWaterVaporAir "Bolz and Tuve 1976"
  extends Modelica.Icons.Function;
  input Modelica.SIunits.Temperature T "Temperature";
  output Modelica.SIunits.DiffusionCoefficient D
    "Diffusion coefficient of water vapour in air";
algorithm
  D := -2.775e-6 + 4.479e-8*T + 1.656e-10*T^2;
  //805/p/9.80665/3600*T^1.8/273.15 "in m^2/h; p in kp/m^2";

end diffusivityWaterVaporAir;
