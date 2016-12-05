#!/bin/csh
#$ -N beta05_NR_0020_NL_0038
#$ -pe smp 2
#$ -q long

module load  lammps
mpiexec -n $NSLOTS lmp_mpi  < system.in
