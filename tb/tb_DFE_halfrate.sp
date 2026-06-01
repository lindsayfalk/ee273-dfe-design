* ============================================================
* DFE with half-rate clock 
* ============================================================

.TITLE  tb_DFE_halfrate

.OPTIONS POST=1 ACCURATE=1

.INCLUDE "../sys_params.spi"
.lib "../lib/opConditions.lib" TTTT
.INCLUDE "../channel/channel_section.lib"
.INCLUDE "../channel/channel_12x.lib"
.INCLUDE "../channel/channel_18x.lib"
.INCLUDE "../ctle/ctle_low_power.lib"
.INCLUDE "../latch/latch.lib"
.INCLUDE "../latch/sum_latch.lib"
.INCLUDE "../latch/summer.lib"

* ── Supply ────────────────────────────────────────────────
VVDD  VDD  0  DC 1.0

* ── Sources ───────────────────────────────────────────────
* For TRANSIENT: use PWLFILE lines (default)
* For AC SWEEP:  comment out PWLFILE lines, uncomment DC/AC lines
*
* -- Transient (PRBS) --
VS_P  SRC_P  0  PWLFILE='../prbs/prbs7_p.pwl'
VS_M  SRC_M  0  PWLFILE='../prbs/prbs7_m.pwl'

* -- AC sweep (single-ended; HSPICE does not support negative AC values) --
*VS_P  CHAN_IN_P  0  DC 0.5  AC 1
*VS_M  CHAN_IN_M  0  DC 0.5

* -- Terminations 
RS_P  SRC_P  CHAN_IN_P  50
RS_M  SRC_M  CHAN_IN_M  50
RTERM_RX CTLE_INP CTLEINM 100

* ── Channel ───────────────────────────────────────────────
* Cascading two 12x channel sections to make channel worse!
XCHAN_P  CHAN_IN_P  MID_P  0  CHANNEL_12X
XCHAN_P2 MID_P CTLE_INP 0 CHANNEL_12X
XCHAN_M  CHAN_IN_M  MID_M  0  CHANNEL_12X
XCHAN_M2 MID_M CTLE_INM 0 CHANNEL_12X

* ── Two cascaded low-power CTLE stages ────────────────────
* Only one CTLE stage in this assignment!
XCTLE1  CTLE_INP  CTLE_INM  VOUTP  VOUTM  VDD  0  CTLE_LOW_POWER

* -- Clock ------------------------------------------------
.PARAM Tdelay = 0 * STUDENT TODO
VCLK CLK GND PULSE(0 1 Tdelay Trise Trise '(Tclock/2)-Trise' Tclock)
VCLKBAR CLKBAR GND PULSE(1 0 Tdelay Trise Trise '(Tclock/2)-Trise' Tclock)

* -- Helps the simulation
RX1 X1 0 1Meg
RY1 Y1 0 1Meg
RX2 X2 0 1Meg
RY2 Y2 0 1Meg
RX3 X3 0 1Meg
RY3 Y3 0 1Meg
RX4 X4 0 1Meg
RY4 Y4 0 1Meg 

* -- Instantiate the subcircuits here! ---------------------
* Student TODO
* Hmm what should go here...?
* All necesarry subcircuits can be found in ../latch



* ----------------------------------------------------------

* ── Analysis ──────────────────────────────────────────────
* For TRANSIENT: use .TRAN + .PROBE TRAN (default)
* For AC SWEEP:  comment out .TRAN/.PROBE TRAN, uncomment .AC/.PROBE AC
*
EDIFF VOUT_CTLE_DIFF 0 VOUTP VOUTM 1
EDIFF2 VOUT_DFE_DIFF 0 B1 A1 1
E2 VCTLEIN_DIFF 0 CTLE_INP CTLE_INM 1
.OP
.TRAN 2e-12  9.142e-09
.PROBE TRAN V(VOUTP) V(VOUTM) V(CTLE_INP) V(CTLE_INM) V(MID_P) V(MID_M)


*.AC DEC 100 100MEG 100G
*.PROBE AC V(VOUTP) V(CTLE_INP)

.END
