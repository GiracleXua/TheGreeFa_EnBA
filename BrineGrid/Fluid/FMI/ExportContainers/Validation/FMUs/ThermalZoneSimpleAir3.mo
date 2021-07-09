within BrineGrid.Fluid.FMI.ExportContainers.Validation.FMUs;
block ThermalZoneSimpleAir3 "Validation of simple thermal zone"
  extends BrineGrid.Fluid.FMI.ExportContainers.Validation.FMUs.ThermalZoneAir1(
    redeclare package Medium = Modelica.Media.Air.SimpleAir(extraPropertiesNames={"CO2", "VOC", "CH2O"}));
  annotation (Documentation(info="<html>
<p>
This example validates that
<a href=\"modelica://BrineGrid.Fluid.FMI.ExportContainers.ThermalZone\">
BrineGrid.Fluid.FMI.ExportContainers.ThermalZone
</a>
exports correctly as an FMU.
</p>
</html>", revisions="<html>
<ul>
<li>
May 03, 2016, by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://BrineGrid/Resources/Scripts/Dymola/Fluid/FMI/ExportContainers/Validation/FMUs/ThermalZoneSimpleAir3.mos"
        "Export FMU"));
end ThermalZoneSimpleAir3;
