within BrineGrid.Media.LiquidDesiccants.LithiumChlorideAqueousSolution_PatekKlomfar.Ancillary;
record Coefficients "Coefficients for ancillary equations"
  extends Modelica.Icons.Record;
  constant Real[10] reducedSaturationPressure={0.28,4.30,0.60,0.21,5.10,0.49,
      0.362,-4.75,-0.40,0.03}
    "Coefficients for the calculation of the reduced water vapor pressure of the solution";
  constant Real[6] saturationPressure={-7.858230,1.839910,-11.781100,22.670500,
      -15.939300,1.775160}
    "Coefficients for the calculation of water vapor pressure";
  constant Real[4] adjustedDynamicViscosity={0.090481,1.390262,0.675875,-0.583517};
  constant Real[4] dynamicViscosityWaterTerm1={1.000,0.978197,0.579829,-0.202354};
  constant Real[6, 7] dynamicViscosityWaterTerm2={{0.5132047,0.2151778,-0.2818107,
      0.1778064,-0.0417661,0.0,0.0},{0.3205656,0.7317883,-1.070786,0.4605040,
      0.0,-0.01578386,0.0},{0.0,1.241044,-1.263184,0.2340379,0.0,0.0,0.0},{0.0,
      1.476783,0.0,-0.4924179,0.1600435,0.0,-0.003629481},{-0.7782567,0.0,0.0,
      0.0,0.0,0.0,0.0},{0.1885447,0.0,0.0,0.0,0.0,0.0,0.0}};
  constant Real[6] dynamicViscosity={1.0261862,12481.702,-19510.923,7065.286,-395.561,
      143922.996};
  constant Real[6] densityWater={1.9937718430,1.0985211604,-0.5094492996,-1.7619124270,
      -44.9005480267,-723692.2618632};
  //constant Real[2] thermalConductivity={10.8958e-3, -11.7882e-3};
end Coefficients;
