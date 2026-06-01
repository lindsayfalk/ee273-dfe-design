* ============================================================
* Single bit response TB
* ============================================================

.TITLE  tb_pulse_response

.OPTIONS POST=1 ACCURATE=1

.INCLUDE "../sys_params.spi"
.lib "../lib/opConditions.lib" TTTT
.INCLUDE "../channel/channel_section.lib"
.INCLUDE "../channel/channel_12x.lib"
.INCLUDE "../channel/channel_18x.lib"
.INCLUDE "../channel/channel_24x.lib"
.INCLUDE "../ctle/ctle_low_power.lib"
.INCLUDE "../latch/latch.lib"

* ── Supply ────────────────────────────────────────────────
VVDD  VDD  0  DC 1.0

* -- Transient (SBR) --
VS_P  SRC_P  0  PULSE(0.1 0.9 10p trise trise 'UI-trise' 1n)
VS_M  SRC_M  0  PULSE(0.9 0.1 10p trise trise 'UI-trise' 1n)
*
* -- AC sweep (single-ended; HSPICE does not support negative AC values) --
*VS_P  SRC_P  0  DC 0.5  AC 1
*VS_M  SRC_M  0  DC 0.5

RS_P  SRC_P  CHAN_IN_P  50
RS_M  SRC_M  CHAN_IN_M  50
RTERM_RX CTLE_INP CTLE_INM 100

* ── Channel ───────────────────────────────────────────────
XCHAN_P  CHAN_IN_P  MID_P  0  CHANNEL_12X
XCHAN_P2 MID_P CTLE_INP 0 CHANNEL_12X
XCHAN_M  CHAN_IN_M  MID_M  0  CHANNEL_12X
XCHAN_M2 MID_M CTLE_INM 0 CHANNEL_12X

* ── Two cascaded low-power CTLE stages ────────────────────
XCTLE1  CTLE_INP  CTLE_INM  VOUTP  VOUTM  VDD  0  CTLE_LOW_POWER

*
EDIFF VOUT_CTLE_DIFF 0 VOUTP VOUTM 1
E2 VCTLEIN_DIFF 0 CTLE_INP CTLE_INM 1
.OP
.TRAN 8.929e-13  500e-12
.PROBE TRAN V(VOUTP) V(VOUTM) V(CTLE_INP) V(CTLE_INM) V(MID_P) V(MID_M)

*.AC DEC 100 100MEG 100G
*.PROBE AC V(VOUTP) V(CTLE_INP)

.END
