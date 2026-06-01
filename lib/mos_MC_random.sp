* mos_MC_random.sp
*model augmentation to include process variation for MOS transistors

.subckt mos_MC do di go gi s dvth=0 dbeta=0
vsense do di 0
vthOffset go gi dvth
fcccs do s vsense dbeta
.ends

