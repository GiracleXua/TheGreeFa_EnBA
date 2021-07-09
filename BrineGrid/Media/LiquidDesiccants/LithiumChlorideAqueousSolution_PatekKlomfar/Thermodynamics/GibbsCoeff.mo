within BrineGrid.Media.LiquidDesiccants.LithiumChlorideAqueousSolution_PatekKlomfar.Thermodynamics;
record GibbsCoeff
  "Coefficients for the calculation of the molar gibbs energy of lithium chloride aqueous solution"
  extends Modelica.Icons.Record;
  // Lithium chloride aqueous solution
  final constant Real[23] nD={0,1,2,3,0,1,2,0,1,2,0,2,3,2,0,0,2,2,1,2,0,1,2};
  final constant Real[23] mD={0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1};
  final constant Real[23] kD={0,0,0,0,0,0,0,1,2,3,4,4,6,7,10,11,11,12,1,1,2,2,2};
  final constant Real[23] aD={1.20915e1,-7.05750,1.87439,-1.73372e-1,-5.77828e-1,
      6.52315e-1,-1.45691e-1,-1.01324e1,2.86194e1,-3.16725e1,-3.78901e1,
      5.29680e1,3.37911,-9.89664e1,6.01495e2,-6.71921e2,3.42347e2,-2.90822e2,-1.34713e-1,
      8.68565e-2,1.08902,-8.20282e-1,1.26456e-1};
  // Liquid Water
  final constant Real[13] aWL={0,5.88137e1,-9.18938,-8.33307e1,1.84228e2,-1.70534e2,
      1.05457e2,-2.94856e1,1.96926e-1,-8.68008e-1,2.25497,-2.60177,1.17349};
  final constant Real[13] nWL={0,0,1,0,-1,-2,-3,-4,1,0,-1,-2,-3};
  final constant Real[13] mWL={0,0,0,0,0,0,0,0,1,1,1,1,1};
  // Gaseous Water
  final constant Real[9] aWG={1.0,3.98432,6.68909,-8.78439,-5.18911e-2,-6.25248e-1,
      5.07144e-1,-1.24364e-1,-4.49013e-1};
  final constant Real[9] nWG={0,0,1,0,-3,6,7,8,15};
  final constant Real[9] mWG={0,0,0,0,0,1,1,1,3};
end GibbsCoeff;
