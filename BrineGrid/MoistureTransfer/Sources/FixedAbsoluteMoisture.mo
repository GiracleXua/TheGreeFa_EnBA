within BrineGrid.MoistureTransfer.Sources;
model FixedAbsoluteMoisture "Fixed absolute moisture boundary condition"
  parameter Boolean use_X_in=false
    "Get the absolute moisture from the input connector" annotation(Evaluate=true, HideResult=true);
  parameter Modelica.SIunits.MassFraction X=0.5
    "Fixed absolute moisture at moisturePort" annotation(Dialog(enable=not use_Xi_in));

  Modelica.Blocks.Interfaces.RealInput X_in(
    final quantity="MassFraction",
    final unit="kg/kg",
    displayUnit="kg/kg",
    min = 0) if use_X_in "Absolute moisture" annotation (Placement(transformation(extent={{-140,
            -20},{-100,20}}), iconTransformation(extent={{-140,-20},{-100,20}})));
  MoistureTransfer.Interfaces.MoisturePort_b moisturePort annotation (Placement(transformation(extent={{90,-10},{110,10}}, rotation=0)));
protected
  Modelica.Blocks.Interfaces.RealInput X_in_internal
    "Needed to connect to conditional connector";
equation
  connect(X_in, X_in_internal);
  if not use_X_in then
    X_in_internal = X;
  end if;
  moisturePort.X = X_in_internal;
  annotation (defaultComponentName="bou",
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={159,159,223},
          fillPattern=FillPattern.Backward),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          lineColor={0,0,255}),
        Line(
          points={{-52,0},{56,0}},
          color={0,128,255},
          thickness=0.5),
        Polygon(
          points={{50,-20},{50,20},{90,0},{50,-20}},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,128,255}),
        Text(
          extent={{90,-18},{-90,-118}},
          lineColor={0,0,0},
          textString="KG/KG"),
        Text(
          extent={{-150,-110},{150,-150}},
          lineColor={0,0,0},
          textString=if use_X_in then "X=%X_in" else "X=%X")}),
        Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}})),
    Documentation(info="<html>
<p>
This model defines a fixed concentration X at its port,
i.e. it defines a fixed concentration as a boundary condition.
</p>
</html>",
        revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>"));
end FixedAbsoluteMoisture;
