within BrineGrid.Media.LiquidDesiccants.LithiumBromideAqueousSolution_PatekKlomfar.Thermodynamics;
record Coefficients
  "Coefficients for the calculation of state variables of lithium chloride aqueous solution"
  extends Modelica.Icons.Record;
  // Lithium bromide aqueous solution
  // Density
  final constant Real[2] a_d={1.746,4.709};
  final constant Real[2] m_d={1,1};
  final constant Real[2] t_d={0,6};
  // Specific enthalpy
  final constant Real[30] a_h={2.27431,-7.99511,3.85239e2,-1.63940e4,-4.22562e2,
      1.13314e-1,-8.33474,-1.73833e4,6.49763,3.24552e3,-1.34643e4,3.99322e4,-2.58877e5,
      -1.93046e-3,2.80616,-4.04479e1,1.45342e2,-2.74873,-4.49743e2,-1.21794e1,-5.83739e-3,
      2.33910e-1,3.41888e-1,8.85259,-1.78731e1,7.35179e-2,-1.79430e-4,
      1.84261e-3,-6.24282e-3,6.84765e-3};
  final constant Real[30] m_h={1,1,2,3,6,1,3,5,4,5,5,6,6,1,2,2,2,5,6,7,1,1,2,2,
      2,3,1,1,1,1};
  final constant Real[30] n_h={0,1,6,6,2,0,0,4,0,4,5,5,6,0,3,5,7,0,3,1,0,4,2,6,
      7,0,0,1,2,3};
  final constant Real[30] t_h={0,0,0,0,0,1,1,1,2,2,2,2,2,3,3,3,3,3,3,3,4,4,4,4,
      4,4,5,5,5,5};
  // Specific entropy
  final constant Real[29] a_s={1.53091,-4.52564,6.98302e2,-2.16664e4,-1.47533e3,
      8.47012e-2,-6.59523,-2.95331e4,9.56314e-3,-1.88679e-1,9.31752,5.78104,
      1.38931e4,-1.71762e4,4.15108e2,-5.55647e4,-4.23409e-3,3.05242e1,-1.67620,
      1.48283e1,3.03055e-3,-4.01810e-2,1.49252e-1,2.59240,-1.77421e-1,-6.99650e-5,
      6.05007e-4,-1.65228e-3,1.22966e-3};
  final constant Real[29] m_s={1,1,2,3,6,1,3,5,1,2,2,4,5,5,6,6,1,3,5,7,1,1,1,2,
      3,1,1,1,1};
  final constant Real[29] n_s={0,1,6,6,2,0,0,4,0,0,4,0,4,5,2,5,0,4,0,1,0,2,4,7,
      1,0,1,2,3};
  final constant Real[29] t_s={0,0,0,0,0,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,4,4,4,4,
      4,5,5,5,5};
  // Specific heat capacity
  final constant Real[8] a_cp={-1.42094e1,4.04943e1,1.11135e2,2.29980e2,
      1.34526e3,-1.41010e-2,1.24977e-2,-6.83209e-4};
  final constant Real[8] m_cp={2,3,3,3,3,2,1,1};
  final constant Real[8] n_cp={0,0,1,2,3,0,3,2};
  final constant Real[8] t_cp={0,0,0,0,0,2,3,4};
  // Saturation pressure
  final constant Real[8] a_p={-2.41303e2,1.91750e7,-1.75521e8,3.25430e7,
      3.92571e2,-2.12626e3,1.85127e8,1.91216e3};
  final constant Real[8] m_p={3,4,4,8,1,1,4,6};
  final constant Real[8] n_p={0,5,6,3,0,2,6,0};
  final constant Real[8] t_p={0,0,0,0,1,1,1,1};
  // Liquid water IF95
  // Density
  final constant Real[6] b_d={1.99274064,1.09965342,-0.510839303,-1.75493479,-45.5170352,
      -6.7469445e5};
  final constant Real[6] c_d={1/3,2/3,5/3,16/3,43/3,110/3};
  // Specific enthalpy
  final constant Real[4] b_h={-4.37196e-1,3.03440e-1,-1.29582,-1.76410e-1};
  final constant Real[4] c_h={1/3,2/3,5/6,21/6};
  // Specific entropy
  final constant Real[4] b_s={-3.34112e-1,-8.47987e-1,-9.11980e-1,-1.64046};
  final constant Real[4] c_s={1/3,1,8/3,8};
  // Specific heat capacity
  final constant Real[5] b_cp={1.38801,-2.95318,3.18721,-0.645473,9.18946e5};
  final constant Real[5] c_cp={0,2,3,6,34};
  final constant Real[5] d_cp={0,2,3,5,0};
  // Saturation pressure
  final constant Real[6] b_p={-7.85951783,1.84408259,-11.7866497,22.6807411,-15.9618719,
      1.80122502};
  final constant Real[6] c_p={1.0,1.5,3.0,3.5,4.0,7.5};
end Coefficients;
