#!/bin/csh
#$ -N test04
#$ -pe smp 2
#$ -q long

module load  lammps
mpiexec -n $NSLOTS lmp_mpi  < system.in
