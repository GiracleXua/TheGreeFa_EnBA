within BrineGrid.Fluid.HeatPumps.Validation;
model Carnot_y_etaCar
  "Test model for heat pump based on Carnot efficiency with etaCar as parameter"
  extends BrineGrid.Fluid.HeatPumps.Examples.Carnot_y(
    heaPum(use_eta_Carnot_nominal=true,
           etaCarnot_nominal=0.494805));

  annotation (experiment(StopTime=3600),
__Dymola_Commands(file="modelica://BrineGrid/Resources/Scripts/Dymola/Fluid/HeatPumps/Validation/Carnot_y_etaCar.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This example extends from
<a href=\"modelica://BrineGrid.Fluid.HeatPumps.Examples.Carnot_y\">
BrineGrid.Fluid.HeatPumps.Examples.Carnot_y</a>
but uses the parameter <code>etaCar</code> instead of <code>COP_nominal</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
February 5, 2016, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Carnot_y_etaCar;
