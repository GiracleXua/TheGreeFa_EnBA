within BrineGrid.BoundaryConditions.WeatherData.BaseClasses.Examples;
model CheckCeilingHeight "Test model for ceiling height check"
  extends Modelica.Icons.Example;
  BrineGrid.Utilities.Time.ModelTime modTim
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  BrineGrid.BoundaryConditions.WeatherData.BaseClasses.CheckCeilingHeight
    cheCeiHei "Block that constrains the ceiling height"
     annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  BrineGrid.BoundaryConditions.WeatherData.BaseClasses.ConvertTime conTim
    "Block that converts time"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
protected
  Modelica.Blocks.Tables.CombiTable1Ds datRea(
    tableOnFile=true,
    tableName="tab1",
    fileName=Modelica.Utilities.Files.loadResource(
       "modelica://BrineGrid/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"),
    columns=2:30,
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative)
    "Data reader"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
equation
  connect(datRea.y[20], cheCeiHei.ceiHeiIn) annotation (Line(
      points={{21,-9.65517},{30,-9.65517},{30,-10},{38,-10}},
      color={0,0,127}));
  connect(modTim.y, conTim.modTim) annotation (Line(
      points={{-59,-10},{-42,-10}},
      color={0,0,127}));
  connect(conTim.calTim, datRea.u) annotation (Line(
      points={{-19,-10},{-2,-10}},
      color={0,0,127}));
  annotation (
Documentation(info="<html>
<p>
This example tests the model that constrains the ceiling height.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 21, 2016, by Michael Wetter:<br/>
Replaced <code>ModelicaServices.ExternalReferences.loadResource</code> with
<code>Modelica.Utilities.Files.loadResource</code>.
</li>
<li>
July 14, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
  experiment(StopTime=8640000),
__Dymola_Commands(file="modelica://BrineGrid/Resources/Scripts/Dymola/BoundaryConditions/WeatherData/BaseClasses/Examples/CheckCeilingHeight.mos"
        "Simulate and plot"));
end CheckCeilingHeight;
