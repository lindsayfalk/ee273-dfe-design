* ============================================================
* FILE: tb_gmid_input.sp
* DESC: Find the device width (and hence Jinput) that gives
*       gm/Id = 5 for the summer's INPUT pair, at the tail
*       current found in Problem 3.  (EE273 PS8, Problem 4.)
*
* Same circuit as tb_gmid.sp, but the FIXED and SWEPT roles
* are swapped: tail current is fixed, width W is swept.
*
* Run from tb/ :  hspice tb_gmid_input.sp  ->  open .sw0
* ============================================================

.TITLE tb_gmid_input

.OPTIONS POST=1 ACCURATE=1

.INCLUDE "../sys_params.spi"
.lib "../lib/opConditions.lib" TTTT

* -- Test input + the operating point from Problem 3 -------
.PARAM dvin     = 0.020      $ 20 mV gate-gate difference
.PARAM Itail_in = 232u       $ summer input-pair tail (= IS1 ~ Itail from P3)
.PARAM WIN      = 0.5u       $ device width -- this is what we sweep

* -- Supply ------------------------------------------------
VVDD  VDD  0  DC 1.0

* -- Drain bias + current sense (0 V sources = ammeters) ---
VD1  VDD  D1  DC 0           $ I(VD1) = drain current of M1
VD2  VDD  D2  DC 0           $ I(VD2) = drain current of M2

* -- Gates, 20 mV apart ------------------------------------
VG1  G1  0  DC 1.0
VG2  G2  0  DC '1.0 - dvin'

* -- The pair -- width is now the swept parameter WIN ------
M1  D1  G1  S  0  nmos  L=L  W=WIN
M2  D2  G2  S  0  nmos  L=L  W=WIN

* -- Tail current FIXED at the Problem-3 value -------------
IT  S  0  DC Itail_in

* -- Sweep the WIDTH (not the current this time) -----------
.DC WIN 0.1u 1u 0.01u

* -- Outputs -----------------------------------------------
.PROBE DC I(VD1) I(VD2)
.MEAS DC w_at_gmid5 WHEN PAR('100*(I(VD1)-I(VD2))/(I(VD1)+I(VD2))') = 5

.END
