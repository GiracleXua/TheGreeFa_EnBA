within BrineGrid.Media.LiquidDesiccants;
package Types "Types to be used in fluid models"
  extends Modelica.Media.Interfaces.Types;

  type Molality = Real (final quantity="Molality", final unit="mol/kg", min=0.0)
  "Type for molality: moles of solute per mass of solvent"
    annotation (Documentation(revisions="<html>
<ul>
<li>
January 09, 2018, by Christian Fleßner:<br/>
First implementation.
</li>
</ul>
</html>"));

annotation (Documentation(info="<html>
<p>
This package provides predefined types, that are used in media models based on thermodynamic equations of state, e.g.
</p>
<pre>   <b>type</b> MolarGibbsEnergy = Real (<b>final</b> unit=\"J/mol\");
   <b>type</b> DerGibbsByPressure = Real (<b>final</b> unit=\"J/(mol.Pa)\");

</pre>
</html>"));
end Types;
