within ;
package BrineGrid



























  annotation (uses(Modelica(version="3.2.3"), Buildings(version="7.0.0")),
                                               Documentation(info="<html>
<p>The Modelica <span style=\"font-family: Courier New;\">BrineGrid</span> library is a free open-source library providing models for the simulation of liquid desiccant distribution networks. It it based on the Modelica <a href=\"https://github.com/iea-annex60/modelica-annex60\">Annex60</a> library version 1.0 and adds models for </p>
<ul>
<li><a href=\"modelica://BrineGrid.Media.LiquidDesiccants\">aqueous solution media</a> (LiBr and LiCl by Yannick F&uuml;rst, MgCl2 added by Guangxu Wang and Christian Fle&szlig;ner),</li>
<li>convective <a href=\"modelica://BrineGrid.HeatTransfer\">heat</a> and <a href=\"modelica://BrineGrid.MoistureTransfer\">moisture transfer</a>,</li>
<li>adiabatic (validated) and internally cooled <a href=\"modelica://BrineGrid.Fluid.MassExchangers.Absorbers\">absorbers</a> (in development) used in air dehumidification processes and</li>
</ul>
<p><br>The model has also been expended to system level model by connecting the absorber/desorber component to predefined component in building library.</p><p><br>Furthermore, a Python package to generate psychrometric charts. It is used for post-processing purposes and visualize the simulation results.</p>
</html>"),
  version="2",
  conversion(noneFromVersion="", noneFromVersion="1"));
end BrineGrid;
