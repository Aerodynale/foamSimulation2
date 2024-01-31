#!/bin.bash
#$ -cwd                 # workingDirectory
#$ -j y
#$ -N Treno
#$ -S /bin/bash
#$ -q all.q                 # queueName
#$ -pe mpi 32        # cpuNumber
#$ -l h_rt=03:00:00

module use /software/spack/spack/share/spack/modules/linux-rocky8-sandybridge/
module load openfoam

chmod +x Allrun_cluster
time ./Allrun_cluster > /home/meccanica/abrunelli/Train_2/output.txt