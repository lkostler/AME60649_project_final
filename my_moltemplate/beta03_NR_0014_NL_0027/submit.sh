#!/bin/csh
#$ -N beta03_NR_0014_NL_0027
#$ -pe smp 2
#$ -q long

module load  lammps
mpiexec -n $NSLOTS lmp_mpi  < system.in
