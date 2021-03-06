#!/bin/bash
#===============================================================================
#
#  Main settings for GFS-LETKF scripts.
#
#===============================================================================

DIR="$( cd "$( pwd )/.." && pwd )"                   # root directory of the GFS-LETKF
OUTDIR="/OUTDIR"                                     # Directory for GFS-LETKF output
SYSNAME="exp1"        # A unique name in the machine (used to identify multiple GFS-LETKFs running in the same time)

PBS_O_HOST=$(hostname)
USER=$(whoami)

#===============================================================================
# Temporary directories to store runtime files

LTMP1="/tmp"          # Local temporary directory on nodes - level 1
LTMP2="/tmp"          # Local temporary directory on nodes - level 2
TMP1="/tmp"           # Temporary directory on the server machine
TMPMPI="$DIR/run/tmp" # Temporary directory on the server machine with shared access from nodes

SHAREDISK=1           # Location of runtime temporary files:
                      #  0: use local disks on nodes ($LTMP1, $LTMP2) to store runtime files
                      #  1: use shared disk ($OUTDIR/tmp) to store runtime files

#===============================================================================
# Location of model/data files

EXECGLOBAL="/homes/metogra/gylien/work/gfs-letkf/branches/gylien-20140429/gfs/exec"   # directory of GFS executable files 
FIXGLOBAL="/data/letkf04/gylien/data/GFS_fix_selected"                # directory of GFS fix files 
FIXGSI="/data/letkf04/gylien/data/GSI_fix_selected"                   # directory of GSI fix files 
FIXCRTM="/data/letkf04/gylien/data/CRTM_Coefficients-2.0.5_selected"  # directory of CRTM fix files 

ANLGFS="/data/letkf04/gylien/model/CFSR_t62"         # directory of reference model files [sigma/surface formats]
ANLGRD="/data/letkf04/gylien/model/CFSR_t62_grd"     # directory of reference model files [sigma-level grid format]
ANLGRDP="/data/letkf04/gylien/model/CFSR_t62_grdp"   # directory of reference model files [pressure-level grid format]
ANLGRDP2="/data/letkf04/gylien/model/EC_interim_t62_grdp" # directory of reference model files [pressure-level grid format]

INITGFS="/data/letkf04/gylien/model/GDAS_IC_t62"     # directory of arbitrary initial condition files [sigma/surface formats]

OBS="/data/letkf04/gylien/obs/UCAR_obs"              # directory of observation data in LETKF obs format
OBSNCEP="/data/letkf04/gylien/obs/NCEP_bufr"         # directory of observation data in NCEP BUFR format

OBSPP="/data/letkf04/gylien/obs/TMPA_obs_T62_accu"   # directory of precipitation observation data in LETKF obs format
PPCDFM="/data/letkf04/gylien/data/PPCDF/cdfm.t62"    # directory of model precipitation CDF
PPCDFO="/data/letkf04/gylien/data/PPCDF/cdfo.t62"    # directory of observation precipitation CDF
PPCORR="/data/letkf04/gylien/data/PPCDF/corr.t62"    # directory of precipitation correlation files

#===============================================================================
# Parallelization settings

MEMBER=32          # ensemble size

                   # (This limit is usually due to available memory per node/core)
MIN_NP_GFS=1       # Minimum number of cores required to run GFS
MIN_NP_GSI=2       # Minimum number of cores required to run GSI

                   # (This limit is usually due to parallelization efficiency)
MAX_NP_GFS=8       # Maximum number of cores suggested to run GFS
MAX_NP_GSI=8       # Maximum number of cores suggested to run GSI

#===============================================================================
# LETKF settings

WINDOW_S=3         # GFS forecast time when assimilation window starts (hour)
WINDOW_E=9         # GFS forecast time when assimilation window ends (hour)
LCYCLE=6           # Length of a GFS-LETKF cycle (hour)
LTIMESLOT=1        # Timeslot interval for 4D-LETKF (hour)
LTIMESLOTMEAN=3    # Timeslot interval to compute ensemble mean for GSI QC and thinning (hour)

FHMAX=$WINDOW_E    # GFS forecast length in a cycle (hour)
FHOUT=$LTIMESLOT   # GFS forecast output interval (hour)

OBSOPE_OPT=1       # Observation operator options:
                   #  1: use LETKF built-in obsope
                   #  2: use GSI

THIN_OPT=2         # Superobing/thinning options:
                   # -- Options below (1-2) is for OBSOPE_OPT=1
                   #  1: No superobing/thinning
                   #  2: Use superobed/thinned observations
                   #     Superobed/thinned observations store in $OUTDIR/obs/superob
                   # -- Options below (3-4) are for OBSOPE_OPT=2
                   #  3: use thinned observations for satellite radiance observations only
                   #  4: use thinned observations for both conventional and satellite radiance observations

ADAPTINFL=1        # Adaptive inflation
                   #  0: OFF
                   #  1: ON, using inflation parameter 1 cycle  ago as prior
                   #  2: ON, using inflation parameter 2 cycles ago as prior

#===============================================================================
# EFSO settings

EFSOT=24           # EFSO validation time interval (from the analysis time) (hour)

OBSOUT_DIAG=0      # Store obsgues/obsanal (for EFSO) during the GFS-LETKF cycling run
                   #  0: No
                   #  1: Yes

#===============================================================================
# Forecast settings

FCSTLEN=120        # GFS forecast length in the forecast mode (hour)
FCSTOUT=$LCYCLE    # GFS forecast output interval in the forecast mode (hour)

EFSOFLEN=$EFSOT    # GFS forecast length in the EFSO (ensemble) forecast mode (hour)
EFSOFOUT=$LCYCLE   # GFS forecast output interval in the EFSO (ensemble) forecast mode (hour)

#===============================================================================
# Diagnostic output settings

              #      anal     analg         analgp   gues     guesg         guesgp
              #      mean mem mean/sprd mem mean mem mean mem mean/sprd mem mean mem
OUT_OPT=1     # 1:   o    o   o         o   o    o   o    o   o         o   o    o
              # 2:   o    o   o         o   o        o    o   o         o   o
              # 3:   o    o   o             o        o    o   o             o
              # 4:   o    o   o             o        o        o             o
              # 5:   o    .   o             o        o        o             o
              # 6:   o    .   o             o

              #      fcst fcstg/fcstv fcstgp/fcstvp
FOUT_OPT=1    # 1:   o    o           o
              # 2:        o           o
              # 3:        o

OBSOUT_OPT=1  # OBSOPE_OPT=1  superob          obs2 obsdep(omb/oma) obsdiag(obsgues/obsanal)
              # OBSOPE_OPT=2  obsinput gsidiag obs2 obsdep(omb/oma) obsdiag(obsgues/obsanal)
              # 1:            o        o       o    o               ($OBSOUT_DIAG)
              # 2:            o                o    o               ($OBSOUT_DIAG)
              # 3:            o                     o               ($OBSOUT_DIAG)
              # 4:                                  o               ($OBSOUT_DIAG)
              # 5:            (none)

              #      gfs    superob       gsimean    gsi    readdiag letkf | gfsfcst
              #      stdout stdout detail stdout fit stdout stdout   outp0 | stdout
LOG_OPT=1     # 1:   o      o      o      o      o   o      o        o       o
              # 2:   o      o             o          o      o        o       o
              # 3:          o             o                          o
              # 4:   (none)

#===============================================================================
# Environmental settings

RSH="rsh"
RCP="rcp -q"

FILE_TRANSFER=2    # Method to transfer files into/out from computing nodes
                   # 1: use "rcp"
                   # 2: use "cp", network shared disks are required
if [ "$FILE_TRANSFER" -eq '1' ]; then
  CPCOMM="$RCP"
  HOSTPREFIX="$PBS_O_HOST:"
elif [ "$FILE_TRANSFER" -eq '2' ]; then
  CPCOMM='cp'
  HOSTPREFIX=''
fi

MPIBIN=/usr/local/mpich-3.0.4-pgi-12.9/bin
MPIEXEC="$MPIBIN/mpiexec"

BUFRBIN=/homes/metogra/gylien/pkg/BUFRLIB/bin

#===============================================================================
# Self test (for security)

if [ ! -d "$DIR" ]; then
  echo "[Error] In 'configure.sh': Directory '\$DIR' does not exist." 1>&2
  exit 1
fi
if [ ! -d "$OUTDIR" ]; then
  echo "[Error] In 'configure.sh': Directory '\$OUTDIR' does not exist." 1>&2
  exit 1
fi
if [ -z "$SYSNAME" ]; then
  echo "[Error] In 'configure.sh': '\$SYSNAME' is empty." 1>&2
  exit 1
fi
if [ ! -d "$LTMP1" ]; then
  echo "[Error] In 'configure.sh': Directory '\$LTMP1' does not exist." 1>&2
  exit 1
fi
if [ ! -d "$LTMP2" ]; then
  echo "[Error] In 'configure.sh': Directory '\$LTMP2' does not exist." 1>&2
  exit 1
fi
if [ ! -d "$TMP1" ]; then
  echo "[Error] In 'configure.sh': Directory '\$TMP1' does not exist." 1>&2
  exit 1
fi

#===============================================================================
