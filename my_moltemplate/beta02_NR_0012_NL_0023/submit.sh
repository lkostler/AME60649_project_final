#!/bin/csh
#$ -N beta02_NR_0012_NL_0023
#$ -pe smp 2
#$ -q long

module load  lammps
mpiexec -n $NSLOTS lmp_mpi  < system.in
