#------------------------------------------------------------------------------
#                  GEOS-Chem Global Chemical Transport Model                  !
#------------------------------------------------------------------------------
#BOP
#
# !MODULE: gchp.ifort17_mvapich2_odyssey.bashrc
#
# !DESCRIPTION: Source this bash file to compile and run GCHP with the Intel 
#  Fortran Compiler v17 and MPI implementation MVAPICH2 on the 
#  Harvard University Odyssey cluster.
#\\
#\\
# !CALLING SEQUENCE:
#  source gchp.ifort17_mvapich2_odyssey.bashrc
#
# !REMARKS
#
# !REVISION HISTORY:
#  26 Oct 2016 - S. Eastham - Initial version
#  03 Feb 2017 - S. Eastham - Updated for GCHP v1
#  See git commit history for subsequent revisions
#EOP
#------------------------------------------------------------------------------
#BOC

if [[ $- = *i* ]] ; then
  echo "Loading modules for GCHP on Odyssey, please wait ..."
fi

#==============================================================================
# Aliases (edit/add/remove based on your preferences)
#==============================================================================

# Clean run directory before a new run
# WARNING: will delete gchp.log and contents of OutputDir
alias mco="make cleanup_output"       

# Recompile GC but not MAPL, ESMF, dycore
alias mcs="make compile_standard"     

# Submit a run as a batch job
alias gchprun="sbatch gchp.run"

# Follow log output on screen
alias tfl="tail --follow gchp.log -n 100"   

# Show current code git info
alias checkgit="make printbuildinfo"        

# Show build code git info
alias checkbuild="cat lastbuild"   

#==============================================================================
# Modules (specific to compute cluster)
#==============================================================================

module purge
module load git

# Modules for CentOS7
module load intel/17.0.4-fasrc01
module load mvapich2/2.3b-fasrc02
module load netcdf/4.3.2-fasrc05
module load netcdf-fortran/4.4.0-fasrc03

#==============================================================================
# Environment variables
#==============================================================================

# Specify compilers
export CC=gcc
export OMPI_CC=$CC

export CXX=g++
export OMPI_CXX=$CXX

export FC=ifort
export F77=$FC
export F90=$FC
export OMPI_FC=$FC
export COMPILER=$FC
export ESMF_COMPILER=intel

# MPI Communication
export ESMF_COMM=mvapich2
export MPI_ROOT=$MPI_HOME
export MVAPICH2=$MPI_HOME

# Suppress MVAPICH2 warning message for if OpenMP is used
export MV2_USE_THREAD_WARNING=0

# Turn off core bindings in MVAPICH2 (use SLURM instead)
export MV2_ENABLE_AFFINITY=0

# Turn off shared mem pool for bound cores (use SLURM plane in srun instead)
export MV2_USE_SHARED_MEM=0

# Base paths
export GC_BIN="$NETCDF_HOME/bin"
export GC_INCLUDE="$NETCDF_HOME/include"
export GC_LIB="$NETCDF_HOME/lib"

# Add to primary path
export PATH=${NETCDF_HOME}/bin:$PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${NETCDF_HOME}/lib

# If using NetCDF after the C/Fortran split (4.3+), then you will need to
# specify the following additional environment variables
export GC_F_BIN="$NETCDF_FORTRAN_HOME/bin"
export GC_F_INCLUDE="$NETCDF_FORTRAN_HOME/include"
export GC_F_LIB="$NETCDF_FORTRAN_HOME/lib"
export PATH=${NETCDF_FORTRAN_HOME}/bin:$PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${NETCDF_FORTRAN_HOME}/lib

# Set ESMF optimization (g=debugging, O=optimized (capital o))
export ESMF_BOPT=O

#==============================================================================
# Raise memory limits
#==============================================================================

ulimit -c unlimited              # coredumpsize
ulimit -l unlimited              # memorylocked
#ulimit -u unlimited              # maxproc
ulimit -v unlimited              # vmemoryuse

#==============================================================================
# Print information for clarity
#==============================================================================

echo "Modules loaded:"
module list
echo ""
echo "Environment variables set:"
echo ""
echo "LD_LIBRARY_PATH: ${LD_LIBRARY_PATH}"
echo ""
echo "ESMF_COMM: ${ESMF_COMM}"
echo "ESMP_BOPT: ${ESMF_BOPT}"
echo "MPI_ROOT: ${MPI_ROOT}"
echo "MVAPICH2: ${MVAPICH2}"
echo "MV2_USE_THREAD_WARNING: ${MV2_USE_THREAD_WARNING}"
echo "MV2_ENABLE_AFFINITY: ${MV2_ENABLE_AFFINITY}"
echo "MV2_USE_SHARED_MEM: ${MV2_USE_SHARED_MEM}"
echo ""
echo "CC: ${CC}"
echo "OMPI_CC: ${OMPI_CC}"
echo ""
echo "CXX: ${CXX}"
echo "OMPI_CXX: ${OMPI_CXX}"
echo ""
echo "FC: ${FC}"
echo "F77: ${F77}"
echo "F90: ${F90}"
echo "OMPI_FC: ${OMPI_FC}"
echo "COMPILER: ${COMPILER}"
echo "ESMF_COMPILER: ${ESMF_COMPILER}"
echo ""
echo "GC_BIN: ${GC_BIN}"
echo "GC_INCLUDE: ${GC_INCLUDE}"
echo "GC_LIB: ${GC_LIB}"
echo ""
echo "GC_F_BIN: ${GC_F_BIN}"
echo "GC_F_INCLUDE: ${GC_F_INCLUDE}"
echo "GC_F_LIB: ${GC_F_LIB}"
echo ""
echo "Done sourcing ${BASH_SOURCE[0]}"

