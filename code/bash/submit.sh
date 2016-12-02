#!/bin/csh
#$ -m abe
#$ -N cntq0
#$ -pe smp 2
#$ -q long

module load  lammps
mpiexec -n $NSLOTS lmp_mpi  < in.prod
