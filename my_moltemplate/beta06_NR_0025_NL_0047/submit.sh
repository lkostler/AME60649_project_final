#!/bin/csh
#$ -N beta06_NR_0025_NL_0047
#$ -pe smp 2
#$ -q long

module load  lammps
mpiexec -n $NSLOTS lmp_mpi  < system.in
