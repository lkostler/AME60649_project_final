#!/bin/csh
#$ -N beta01_NR_0010_NL_0020
#$ -pe smp 2
#$ -q long

module load  lammps
mpiexec -n $NSLOTS lmp_mpi  < system.in
