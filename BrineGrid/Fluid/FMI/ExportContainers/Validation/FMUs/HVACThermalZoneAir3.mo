within BrineGrid.Fluid.FMI.ExportContainers.Validation.FMUs;
block HVACThermalZoneAir3 "Validation model for the convective HVAC system"
  extends
    BrineGrid.Fluid.FMI.ExportContainers.Validation.FMUs.HVACThermalZoneAir1(
    redeclare package Medium = BrineGrid.Media.Air(extraPropertiesNames={"CO2", "VOC", "CH2O"}));
annotation (
    Documentation(info="<html>
<p>
This example validates that
<a href=\"modelica://BrineGrid.Fluid.FMI.ExportContainers.HVACZone\">
BrineGrid.Fluid.FMI.ExportContainers.HVACZone</a>
exports correctly as an FMU.
</p>
</html>", revisions="<html>
<ul>
<li>
April 14, 2016 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://BrineGrid/Resources/Scripts/Dymola/Fluid/FMI/ExportContainers/Validation/FMUs/HVACThermalZoneAir3.mos"
        "Export FMU"));
end HVACThermalZoneAir3;