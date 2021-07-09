within BrineGrid.Fluid.Absorbers.Choices;
type FlowConfiguration = enumeration(
    DirectCurrent "Direct flow configuration",
    CounterCurrent "Counter flow configuration",
    CrossCurrent "Cross flow configuration")
  "Enumeration to define the flow configuration" annotation (Documentation(
      revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>This enumerations allow the specification of directcurrent, countercurrent and
crosscurrent flow configurations.</p>
</html>"));
