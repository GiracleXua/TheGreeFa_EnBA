within BrineGrid.Media.LiquidDesiccants.MagnesiumChlorideAqueousSolution.Ancillary;
model test_functions
  extends Modelica.Icons.Function;
  parameter Modelica.SIunits.Temperature T_wa = 293.15;

  Modelica.SIunits.Pressure P_wa;

equation

  P_wa =  saturationPressure_water(Tsat = T_wa);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(
          preserveAspectRatio=false)));
end test_functions;
