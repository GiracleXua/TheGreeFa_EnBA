within BrineGrid.Fluid.Absorbers.Examples;
package test_LDAC
  "temporary test file for LDAC system e.g. regenerator, LD networj..."
  extends Modelica.Icons.ExamplesPackage;
  model regenerator_v1
    "test model for regenerator version 1.0 (17. Nov)"
    extends Modelica.Icons.Example;

    extends BaseClasses.Regenerator_basemodel(
      redeclare final package Medium_b =
          Media.LiquidDesiccants.LithiumChlorideAqueousSolution_PatekKlomfar,
      T_air=273.15 + 25,
      T_abs=273.15 + 50,
      x_a=0.005,
      X_s=0.15,
      m_flow_air=1.85,
      m_flow_abs=2.61,
      mNodes = 3,
      nNodes = 3,
      abs(
        redeclare Data.Chen_2016                                          data,
        flowConf=BrineGrid.Fluid.Absorbers.Choices.FlowConfiguration.CounterCurrent,
        redeclare model ThermalAir =
            HeatTransfer.Convection.Absorption.ConstantNusseltNumber_Absorption
            (                                                                    Nu0=Nu),
        redeclare model MoistureAir =
            MoistureTransfer.Convection.Absorption.ConstantSherwoodNumber (Sh0=Sh)));

    parameter Real simulation_id = 5;
    parameter Modelica.SIunits.NusseltNumber Nu = 3.86;
    parameter Modelica.SIunits.NusseltNumberOfMassTransfer Sh = 3.026;

  end regenerator_v1;

  package BaseClasses
    extends Modelica.Icons.ExamplesPackage;
    partial model Regenerator_basemodel
      "basic partial model for test of a regenerator"
      extends Modelica.Icons.Example;

      //------------ Medium definition--------//
        replaceable package Medium_a =
        Media.LiquidDesiccants.Air "Medium model for moist air";
      replaceable package Medium_b =
        Media.LiquidDesiccants.LithiumChlorideAqueousSolution_PatekKlomfar
        "Medium model for absorbent";
      //Media.LiquidDesiccants.MagnesiumChlorideAqueousSolution
      //Media.LiquidDesiccants.LithiumChlorideAqueousSolution_PatekKlomfar
      replaceable package Medium_c =
        Media.LiquidDesiccants.MagnesiumChlorideAqueousSolution
        "Medium model for alternative absorbent";

      parameter Modelica.SIunits.Temperature T_air=273.15 + 25.6
        "Air inlet temperature";
      parameter Modelica.SIunits.Temperature T_abs=273.15 + 14.9
        "Aqueous solution inlet temperature";
      parameter Modelica.SIunits.MassFraction x_a=0.0162
        "Water load of inlet air (humidity ratio), kg water/kg dry air";
      parameter Modelica.SIunits.MassFraction X_w=
        Media.LiquidDesiccants.Functions.totalHumidityToMassFraction(x=x_a)
        "Mass fraction of water in inlet air, kg/kg moist air";
      final parameter Modelica.SIunits.MassFraction[Medium_a.nX] X_air={X_w, 1 - X_w}
        "Composition of moist air";
      parameter Modelica.SIunits.MassFraction X_s=0.23
        "Mass fraction of desiccant";
      final parameter Modelica.SIunits.MassFraction[Medium_b.nX] X_abs={1 - X_s, X_s}
        "Composition of aqueous solution";
      parameter Modelica.SIunits.MassFlowRate m_flow_air=1.85
        "Mass flow rate of inlet air";
      parameter Modelica.SIunits.MassFlowRate m_flow_abs=2.61
        "Mass flow rate of aqueous solutio at inlet";
      parameter Modelica.SIunits.MassFlowRate m_flow_nominal_air=m_flow_air
        "Nominal mass flow rate of moist air";
      parameter Modelica.SIunits.AbsolutePressure dp_nominal_air=50
        "Nominal pressure drop on the air side";
      parameter Modelica.SIunits.MassFlowRate m_flow_nominal_abs=m_flow_abs
        "Nominal mass flow rate of aqueous solution";
      parameter Modelica.SIunits.AbsolutePressure dp_nominal_abs=50
        "Nominal pressure drop on the desiccant side";
      parameter Integer nNodes=2
        "Discretization of the desiccant flow";
      parameter Integer mNodes=2
        "Discretization of the air flow";

      parameter String dessicant_type="MgCl2";

      //------------- boundary conditions----------//
      BrineGrid.Fluid.Sources.FixedBoundary sin_air(
        redeclare final package Medium = Medium_a,
        final nPorts=1)
        annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
      BrineGrid.Fluid.Sources.FixedBoundary sin_abs(
        final nPorts=1,
        redeclare final package Medium = Medium_b)
        annotation (Placement(transformation(extent={{60,-60},{40,-40}})));
      BrineGrid.Fluid.Sources.MassFlowSource_T sou_air(
        redeclare final package Medium = Medium_a,
        final m_flow=m_flow_air,
        final T=T_air,
        final X=X_air,
        final nPorts=1)
        annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
      BrineGrid.Fluid.Sources.MassFlowSource_T sou_abs(
        final m_flow=m_flow_abs,
        final T=T_abs,
        final X=X_abs,
        final nPorts=1,
        redeclare final package Medium = Medium_b)
        annotation (Placement(transformation(extent={{60,40},{40,60}})));
      //------------absorber model--------------//
      BrineGrid.Fluid.Absorbers.Adiabatic.AdiabaticAbsorber abs(
        massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
        final m_flow_nominal_abs=m_flow_nominal_abs,
        final m_flow_nominal_air=m_flow_nominal_air,
        final dp_nominal_abs=dp_nominal_abs,
        final dp_nominal_air=dp_nominal_air,
        final T_start_abs=T_abs,
        final T_start_air=T_air,
        final X_start_abs=X_abs,
        final X_start_air=X_air,
        final m_flow_start_abs=m_flow_abs,
        final m_flow_start_air=m_flow_air,
        final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
        final nSeg=nNodes,
        final show_T=true,
        final mSeg=mNodes,
        redeclare final package Medium_a = Medium_a,
        redeclare final package Medium_b = Medium_b)
        annotation (Placement(transformation(extent={{-30,-30},{30,30}})));
    equation
      connect(abs.port_b_in, sou_abs.ports[1]) annotation (Line(points={{15,
              24.5455},{15,24.5455},{15,42},{15,50},{40,50}},
                                            color={0,127,255}));
      connect(abs.port_b_out, sin_abs.ports[1]) annotation (Line(points={{15,
              -15.8182},{15,-15.8182},{15,-42},{15,-50},{40,-50}},
                                                color={0,127,255}));
      connect(sin_air.ports[1], abs.port_a_out) annotation (Line(points={{-40,-50},
              {-15,-50},{-15,-16.3636}},
                                   color={0,127,255}));
      connect(sou_air.ports[1], abs.port_a_in)
        annotation (Line(points={{-40,50},{-15,50},{-15,24.5455}},
                                                              color={0,127,255}));
    end Regenerator_basemodel;
  end BaseClasses;
end test_LDAC;
