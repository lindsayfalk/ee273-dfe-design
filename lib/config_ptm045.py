#!/usr/bin/env pbfpy
"""
CONFIG  config_ptm045.py

The configuration file that defines the process parameters to characterize
a model library.

Revisions:
    $Id$
    $Author$
    $DateTime$
"""

##----------------------------------------------------------------------
## import modules 
##----------------------------------------------------------------------

from pbf_config.pbf_global import * # global config
import pysim                        # pysim


##----------------------------------------------------------------------
## cscript parameters
##----------------------------------------------------------------------

# default simulator and simulation deck
#-----------------------------------------------------------------------

sim_dir = '.'                       # default simulation directory
out_dir = './results'                       # output file directory
simulator = 'hspice'                # default simulator
sim_cmd['hspice'] = 'spice_ncd -v Y-2006.09'
sim_deck = 'sim_deck.empy'          # default empy simulation deck


# data structure to store value ranges
#-----------------------------------------------------------------------

class sw_range (object):
    def __init__(self, **kargs):
        self.__dict__.update(kargs) 
    def tolist(self):
        """ return [nom, min, max] array """
        return [self.nom, self.min, self.max]
    def step(self, N=20):
        """ return step size for N equally-spaced points """
        return (self.max-self.min)/(N+0.0)


# process parameters
#-----------------------------------------------------------------------

tech = "ptm045"
model_lib = "model_ptm045.lib"
Lmin = 0.045
scale = "1u"
device_list = dict(nmos="N", pmos="P")
proc_range = sw_range(nom="TT", min="SS", max="FF")
vdd_range = sw_range(nom=1.0, min=0.9, max=1.1)
temp_range = sw_range(nom=27, min=0, max=110)

depend_files = [ "/proj/ssd/staff/jaehak/ptm045/" + model_file
                for model_file in [ "model_ptm045.lib", "45nm_NMOS_bulk_tt.pm", "45nm_NMOS_bulk_ff.pm", "45nm_NMOS_bulk_ss.pm", "45nm_PMOS_bulk_tt.pm", "45nm_PMOS_bulk_ff.pm", "45nm_PMOS_bulk_ss.pm" ] ]
depend_files.append("config_ptm045.py")


# device parameters
#-----------------------------------------------------------------------

L = {}          # device length
W = {}          # device width
P = {}          # device parameters
Vbs = {}        # bulk-to-source voltage

L["nmos"] = sw_range(nom=Lmin, min=Lmin, max=3*Lmin)
W["nmos"] = sw_range(nom=40*Lmin, min=2*Lmin, max=80*Lmin)
P["nmos"] = ""
Vbs["nmos"] = 0.0

L["pmos"] = sw_range(nom=Lmin, min=Lmin, max=3*Lmin)
W["pmos"] = sw_range(nom=40*Lmin, min=2*Lmin, max=80*Lmin)
P["pmos"] = ""
Vbs["pmos"] = 0.0


# sweep parameters
#-----------------------------------------------------------------------

corners = pysim.sweep()
no_label = dict(label=False)
corners.new_vars(['device', 'corner', 'proc', 'temp', 'dev_type'],
                 ['sd', 'sd', 'sd', 'sd', 'sd'],
                 [None, None, no_label, no_label, no_label])
for device in device_list.keys():
    corners.append(device=device, corner="typ,%.1fC" % temp_range.nom,
        proc=proc_range.nom, temp=temp_range.nom, dev_type=device_list[device])
    corners.append(device=device, corner="fast,%.1fC" % temp_range.min,
        proc=proc_range.max, temp=temp_range.min, dev_type=device_list[device])
    corners.append(device=device, corner="slow,%.1fC" % temp_range.max,
        proc=proc_range.min, temp=temp_range.max, dev_type=device_list[device])

sweep_gen = corners 


# model library declaration statements
#-----------------------------------------------------------------------

sim_model['hspice'] = """
.protect
.lib '@model_lib' @proc
.temp @temp
.unprotect
"""


# simulator option statements
#-----------------------------------------------------------------------

sim_option['hspice'] = """ 
.option accurate measdgt=8 scale=@scale
.option post post_version=9605
"""

