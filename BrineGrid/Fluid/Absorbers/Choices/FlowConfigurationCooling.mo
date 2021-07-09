within BrineGrid.Fluid.Absorbers.Choices;
type FlowConfigurationCooling = enumeration(
    DirectCurrent "Direct flow configuration",
    CounterCurrent "Counter flow configuration")
  "Enumeration to define the flow configuration" annotation (Documentation(
      revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p><br><span style=\"color: #ff0000;\">This model is currently under development.</span></p>
</html>"));
