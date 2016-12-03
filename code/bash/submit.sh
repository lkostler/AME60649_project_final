#!/bin/csh
#$ -N test02
#$ -pe smp 2
#$ -q long

module load  lammps
mpiexec -n $NSLOTS lmp_mpi  < in.prod
