* ============================================================
* FILE: tb_gain_check.sp
* DESC: Verify one CML gate has small-signal gain ~2 at the
*       operating point found in the gm/Id test
*       (EE273 PS8, Problem 3, second half).
*
* Run from tb/ :  hspice tb_gain_check.sp
* Open tb_gain_check.ac0 in WaveView; read the low-freq value.
* ============================================================

.TITLE tb_gain_check

.OPTIONS POST=1 ACCURATE=1

.INCLUDE "../sys_params.spi"
.lib "../lib/opConditions.lib" TTTT

* -- Operating point you found -----------------------------
.PARAM Itail_gate = 232u                  $ tail current for gm/Id = 10
.PARAM Vswing     = 0.4                    $ target single-ended swing
.PARAM RDgate     = 'Vswing / Itail_gate'  $ = 1.72k

* -- Supply ------------------------------------------------
VVDD VDD 0 DC 1.0

* -- Load resistors (these replace the 0 V sense sources) --
RD1 VDD D1 RDgate
RD2 VDD D2 RDgate

* -- Gates: balanced DC bias, 1 V of AC on one side --------
VG1 G1 0 DC 1.0 AC 1
VG2 G2 0 DC 1.0

* -- The differential pair (same devices as before) --------
M1 D1 G1 S 0 nmos L=L W=1u
M2 D2 G2 S 0 nmos L=L W=1u

* -- Tail current fixed at the value you found -------------
IT S 0 DC Itail_gate

* -- Differential output node ------------------------------
EDIFF VOD 0 D1 D2 1                        $ V(VOD) = V(D1) - V(D2)

* -- Small-signal analysis ---------------------------------
.OP
.AC DEC 50 1e6 100e9
.PROBE AC V(VOD) V(D1) V(D2)
.MEAS AC gain_lf FIND V(VOD) AT=1e6        $ low-freq gain = gm*RD

.END
