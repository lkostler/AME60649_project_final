#!/bin/csh
#$ -N beta04_NR_0016_NL_0031
#$ -pe smp 2
#$ -q long

module load  lammps
mpiexec -n $NSLOTS lmp_mpi  < system.in
