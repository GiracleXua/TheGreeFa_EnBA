within BrineGrid.Fluid.MixingVolumes.Validation;
model MixingVolumeTraceSubstanceReverseFlowPrescribedHeatFlowRate
  "Validation model for mixing volume with trace substance input and flow reversal, and prescribed heat flow rate"
  extends MixingVolumeTraceSubstanceReverseFlow(
    prescribedHeatFlowRate=true);
  annotation (Documentation(
info="<html>
<p>
This model is identical to
<a href=\"modelica://BrineGrid.Fluid.MixingVolumes.Validation.MixingVolumeTraceSubstanceReverseFlow\">
BrineGrid.Fluid.MixingVolumes.Validation.MixingVolumeTraceSubstanceReverseFlow</a>,
except that the steady state volume <code>volSte</code>
is configured to have a prescribed heat flow rate,
which is in this case zero as the heat port is not connected.
This configures <code>volSte</code> to use the two port
steady state heat and mass balance model
<a href=\"modelica://BrineGrid.Fluid.Interfaces.StaticTwoPortConservationEquation\">
BrineGrid.Fluid.Interfaces.StaticTwoPortConservationEquation</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 9, 2016, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
 __Dymola_Commands(file="modelica://BrineGrid/Resources/Scripts/Dymola/Fluid/MixingVolumes/Validation/MixingVolumeTraceSubstanceReverseFlowPrescribedHeatFlowRate.mos"
        "Simulate and plot"),
    experiment(StopTime=10));
end MixingVolumeTraceSubstanceReverseFlowPrescribedHeatFlowRate;
