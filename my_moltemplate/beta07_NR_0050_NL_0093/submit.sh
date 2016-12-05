#!/bin/csh
#$ -N beta01_NR_0050_NL_0093
#$ -pe smp 2
#$ -q long

module load  lammps
mpiexec -n $NSLOTS lmp_mpi  < system.in
