within BrineGrid.BoundaryConditions.WeatherData.BaseClasses.Examples;
model CheckRadiation "Test model for CheckRadiation"
  extends
    BrineGrid.BoundaryConditions.WeatherData.BaseClasses.Examples.ConvertRadiation;
  BrineGrid.BoundaryConditions.WeatherData.BaseClasses.CheckRadiation cheGloRad
    "Check global horizontal radiation"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  BrineGrid.BoundaryConditions.WeatherData.BaseClasses.CheckRadiation cheDifRad
    "Check diffuse horizontal radiation"
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));
equation

  connect(conGloRad.HOut, cheGloRad.HIn) annotation (Line(
      points={{41,30},{58,30}},
      color={0,0,127}));
  connect(conDifRad.HOut, cheDifRad.HIn) annotation (Line(
      points={{41,-10},{58,-10}},
      color={0,0,127}));
  annotation (
  Documentation(info="<html>
<p>
This example tests the model that constrains the radiation.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 14, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
experiment(StopTime=8640000),
__Dymola_Commands(file=
          "modelica://BrineGrid/Resources/Scripts/Dymola/BoundaryConditions/WeatherData/BaseClasses/Examples/CheckRadiation.mos"
        "Simulate and plot"));
end CheckRadiation;
