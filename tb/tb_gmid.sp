* ============================================================
* FILE: tb_gmid.sp
* DESC: Find the tail current that gives gm/Id = 10 for a
*       W = 1um, L = 45n NMOS, using the differential-pair
*       method (EE273 PS8, Problem 3).
*
* Run from the tb/ folder:  hspice tb_gmid.sp
* Then open tb_gmid.sw0 in WaveView.
* ============================================================

.TITLE tb_gmid

.OPTIONS POST=1 ACCURATE=1

* -- Models + global params (brings in L = 45n, UI, etc.) --
.INCLUDE "../sys_params.spi"
.lib "../lib/opConditions.lib" TTTT

* -- Size of the small differential test input -------------
.PARAM dvin = 0.020          $ 20 mV difference between the two gates

* -- Supply rail -------------------------------------------
VVDD  VDD  0  DC 1.0

* -- Drain bias + current sense ----------------------------
* 0 V sources hold each drain at VDD and act as ammeters.
VD1  VDD  D1  DC 0            $ I(VD1) = drain current of M1
VD2  VDD  D2  DC 0            $ I(VD2) = drain current of M2

* -- Gate voltages, 20 mV apart ----------------------------
VG1  G1  0  DC 1.0            $ gate 1 at VDD
VG2  G2  0  DC '1.0 - dvin'   $ gate 2, 20 mV lower

* -- The differential pair (shared source node S) ----------
M1  D1  G1  S  0  nmos  L=L  W=1u
M2  D2  G2  S  0  nmos  L=L  W=1u

* -- Tail current sink (this is what we sweep) -------------
IT  S  0  DC 100u

* -- Sweep the tail current from 10uA to 600uA -------------
.DC IT 10u 600u 1u

* -- Save the two drain currents for plotting --------------
.PROBE DC I(VD1) I(VD2)

* -- Bonus: let HSPICE find the crossing automatically -----
.MEAS DC it_at_gmid10 WHEN PAR('100*(I(VD1)-I(VD2))/(I(VD1)+I(VD2))') = 10

.END
