within BrineGrid.BoundaryConditions.SolarIrradiation.Examples;
model DiffusePerez
  "Test model for diffuse solar irradiation on a tilted surface using the Perez model"
  extends Modelica.Icons.Example;
  parameter Modelica.SIunits.Angle lat=37/180*Modelica.Constants.pi "Latitude";
  parameter Modelica.SIunits.Angle azi=0.3 "Azi angle";
  parameter Modelica.SIunits.Angle til=0.5 "Tilted angle";
  BrineGrid.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        "modelica://BrineGrid/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  BrineGrid.BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
        transformation(extent={{1,-1},{21,21}}), iconTransformation(extent={{20,
            20},{21,21}})));
  BrineGrid.BoundaryConditions.SolarIrradiation.DiffusePerez HDifRoo(
    til=BrineGrid.Types.Tilt.Ceiling,
    lat=0.6457718232379,
    azi=0.78539816339745) "Diffuse irradiation on roof"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  BrineGrid.BoundaryConditions.SolarIrradiation.DiffusePerez HDifFlo(
    til=BrineGrid.Types.Tilt.Floor,
    lat=0.6457718232379,
    azi=0.78539816339745) "Diffuse irradiation on floor"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
  BrineGrid.BoundaryConditions.SolarIrradiation.DiffusePerez HDifWal(
    til=BrineGrid.Types.Tilt.Wall,
    lat=0.6457718232379,
    azi=0.78539816339745) "Diffuse irradiation on wall"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
equation
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-20,10},{11,10}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaBus,HDifRoo. weaBus) annotation (Line(
      points={{11,10},{40,10}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));

  connect(weaBus, HDifFlo.weaBus) annotation (Line(
      points={{11,10},{30,10},{30,-70},{40,-70}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus, HDifWal.weaBus) annotation (Line(
      points={{11,10},{30,10},{30,-30},{40,-30}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  annotation (
experiment(StartTime=1.82304e+07, StopTime=1.83168e+07),
__Dymola_Commands(file="modelica://BrineGrid/Resources/Scripts/Dymola/BoundaryConditions/SolarIrradiation/Examples/DiffusePerez.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model tests the implementation of Perez' model for diffuse solar radiation.
The three instances of Perez' model compute the diffuse solar
irradiation on a roof, a wall and a floor.
Since the floor only sees the ground but not the radiative heat flow that is
scattered in the atmosphere, it receives the lowest amount of
diffuse solar irradiation.
</p>
</html>",
revisions="<html>
<ul>
<li>
May 24, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end DiffusePerez;
