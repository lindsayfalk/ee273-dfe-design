* ============================================================
* Channel Only 
* ============================================================

.TITLE  Channel Only — Closed Eye Baselin

.INCLUDE "../channel/channel_section.lib"
.INCLUDE "../channel/channel_12x.lib"

* ── Supply ────────────────────────────────────────────────
VVDD  VDD  0  DC 1.0

* ── Sources ───────────────────────────────────────────────
* For TRANSIENT: use PWLFILE lines (default)
* For AC SWEEP:  comment out PWLFILE lines, uncomment DC/AC lines
*
* -- Transient (PRBS) --
*VS_P  SRC_P  0  PWLFILE='../prbs/prbs7_p.pwl'
*VS_M  SRC_M  0  PWLFILE='../prbs/prbs7_m.pwl'
*
* -- AC sweep (single-ended; HSPICE does not support negative AC values) --
VS_P  SRC_P  0  DC 0.5  AC 1
VS_M  SRC_M  0  DC 0.5

RS_P  SRC_P  CHAN_IN_P  50
RS_M  SRC_M  CHAN_IN_M  50
RTERM_RX CTLE_INP CTLE_INM 100

* ── Channel ───────────────────────────────────────────────
XCHAN_P1  CHAN_IN_P  MID_P  0  CHANNEL_12X
XCHAN_P2  MID_P CTLE_INP    0  CHANNEL_12X
XCHAN_M1  CHAN_IN_M  MID_M  0  CHANNEL_12X
XCHAN_M2  MID_M CTLE_INM    0  CHANNEL_12X

* ── Analysis ──────────────────────────────────────────────
* For TRANSIENT: use .TRAN + .PROBE TRAN (default)
* For AC SWEEP:  comment out .TRAN/.PROBE TRAN, uncomment .AC/.PROBE AC
*
EDIFF VOUT_DIFF 0 CTLE_INP CTLE_INM 1
*.TRAN 1.786e-12  1.829e-08
*.PROBE TRAN V(CTLE_INP) V(CTLE_INM)

.AC DEC 100 100MEG 100G
.PROBE AC V(CTLE_INP)

.END
