* ============================================================
* Latch setup and hold time
* ============================================================

.TITLE  tb_setup_and_hold

.OPTIONS POST=1 ACCURATE=1

.INCLUDE "../sys_params.spi"
.lib "../lib/opConditions.lib" TTTT
.INCLUDE "../channel/channel_section.lib"
.INCLUDE "../channel/channel_12x.lib"
.INCLUDE "../channel/channel_18x.lib"
.INCLUDE "../ctle/ctle_low_power.lib"
.INCLUDE "../latch/latch.lib"

* ── Supply ────────────────────────────────────────────────
VVDD  VDD  0  DC 1.0

* ── Sources ───────────────────────────────────────────────
*
* -- Transient (Data transitions close to clk freq) --
VS_P  A  0  PULSE(0.1 0.9 Tdelay Trise Trise '((Tclock+2p)/2)-Trise' ' Tclock+2p')
VS_M  B  0  PULSE(0.9 0.1 Tdelay Trise Trise '((Tclock+2p)/2)-Trise' ' Tclock+2p')

* -- Clock ------------------------------------------------
.PARAM Tdelay = 0
VCLK CLK GND PULSE(0 1 Tdelay Trise Trise '(Tclock/2)-Trise' Tclock)
VCLKBAR CLKBAR GND PULSE(1 0 Tdelay Trise Trise '(Tclock/2)-Trise' Tclock)

* -- Latch ------------------------------------------------
XLATCH1  A  B CLK CLKBAR X1 Y1 VDD 0  LATCH
XLATCH2  X1     Y1    CLKBAR CLK X2 Y2 VDD 0  LATCH

* ── Analysis ──────────────────────────────────────────────
.OP
.TRAN 8.929e-13  '35*Tclock'
.PROBE TRAN V(VOUTP) V(VOUTM) V(CTLE_INP) V(CTLE_INM) V(MID_P) V(MID_M)
.PROBE TRAN I(XLATCH1.M1) I(XLATCH1.M2) I(XLATCH1.M3) I(XLATCH1.M4)

.END

