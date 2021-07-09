within BrineGrid.Media.LiquidDesiccants.LithiumChlorideAqueousSolution_PatekKlomfar.Thermodynamics;
function h "Calculate specific enthalpy h from gibbs energy"
  extends Modelica.Icons.Function;
  input GibbsDerivs g;
  output SpecificEnthalpy h;
algorithm
  h := (g.g - g.T*g.g_T)/g.MM;
end h;
