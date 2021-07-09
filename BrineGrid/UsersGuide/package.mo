within BrineGrid;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;





  annotation (preferredView="info",
  Documentation(info="<html>
<p>The Modelica <code>BrineGrid</code> library is a free open-source library providing models for the simulation of liquid desiccant distribution networks. It it based on the Modelica <a href=\"https://github.com/iea-annex60/modelica-annex60\">Annex60</a> library version 1.0 and adds models for </p>
<ul>
<li><a href=modelica://BrineGrid.Media.LiquidDesiccants>aqueous solution media</a> (LiBr and LiCl),</li>
<li>convective <a href=modelica://BrineGrid.HeatTransfer>heat</a> and <a href=modelica://BrineGrid.MoistureTransfer>moisture transfer</a>,</li>
<li>adiabatic (validated) and internally cooled <a href=modelica://BrineGrid.Fluid.MassExchangers.Absorbers>absorbers</a> (in development) used in air dehumidification processes and</li>
<li>a Python package to generate psychrometric charts. It is used for post-processing purposes and greatly improves the evaluation of simulation results.</li>
</ul>
</html>"));
end UsersGuide;
