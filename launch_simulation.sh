#!/bin.bash
#$ -cwd                 # workingDirectory
#$ -j y
#$ -N Train4
#$ -S /bin/bash
#$ -q all.q                 # queueName
#$ -pe mpi 32        # cpuNumber
#$ -l h_rt=10:00:00

module use /software/spack/spack/share/spack/modules/linux-rocky8-sandybridge/
module load openfoam

# #!/bin/bash
localDir='/global-scratch/abrunelli/foamSimulation2'
#Train case OpenFOAM
mkdir -p logs
cp -r 0.orig 0
# Build Background mesh
surfaceFeatureExtract > logs/01_surfaceFeature.log 2>&1
blockMesh > logs/02_blockMesh.log 2>&1
decomposePar > logs/03_decompose.log 2>&1
mpirun --hostfile machinefile.$JOB_ID -np 32 snappyHexMesh -parallel -overwrite > logs/04_snappyHexMesh.log 2>&1
topoSet > logs/05_topoSet.log 2>&1
createPatch -overwrite > logs/06_createPatch.log 2>&1
reconstructParMesh -constant > logs/07_reconstruct.log 2>&1
rm -rf processor*
checkMesh > logs/08_checkMesh.log 2>&1

# run the simulation rm -r 0
rm -rf processor*
rm -r 0
cp -r 0.orig 0
renumberMesh -overwrite > logs/09_renumberMesh.log 2>&1
decomposePar > logs/10_decomposePar_secondaIterazione.log 2>&1
mpirun --hostfile machinefile.$JOB_ID -np 32 potentialFoam -parallel > logs/11_potentialFoam.log 2>&1
mpirun --hostfile machinefile.$JOB_ID -np 32 simpleFoam -parallel > logs/12_simpleFoam.log 2>&1
reconstructParMesh -constant > logs/13_reconstructParMesh.log 2>&1
reconstructPar -latestTime > logs/14_reconstructPar.log 2>&1

touch train.foam

