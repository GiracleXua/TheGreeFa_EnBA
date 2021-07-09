within BrineGrid.Media.LiquidDesiccants.Choices;
type IndependentVariables = enumeration(
    phX "(p,h,X) as inputs",
    pTX "(p,T,X) as inputs",
    psX "(p,s,X) as inputs") annotation (Documentation(revisions="<html>
<ul>
<li>
January 04, 2017, by Yannick Fuerst:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>Enumeration to select the independent thermodynamic variables.</p>
</html>"));
