#!/bin.bash
#$ -cwd                 # workingDirectory
#$ -j y
#$ -N Treno
#$ -S /bin/bash
#$ -q all.q                  # queueName
#$ -pe mpi 32           # cpuNumber
#$ -l h_rt=10:00:00


# #!/bin/bash
localDir='/home/meccanica/abrunelli/Train'
#Train case OpenFOAM
mkdir -p logs
cp -r 0.orig 0
# Build Background mesh
surfaceFeatureExtract > logs/01_surfaceFeature.log 2>&1
blockMesh > logs/02_blockMesh.log 2>&1
decomposePar > logs/03_decompose.log 2>&1
mpirun --hostfile machinefile.$JOB_ID -np 40 snappyHexMesh -parallel -overwrite > logs/04_snappyHexMesh.log 2>&1
topoSet > logs/05_topoSet.log 2>&1
createPatch > logs/06_createPatch.log 2>&1
reconstructParMesh -constant > logs/07_reconstruct.log 2>&1
rm -rf processor*
checkMesh > logs/08_checkMesh.log 2>&1

# run the simulation rm -r 0
rm -rf processor*
rm -r 0
cp -r 0.orig 0
# renumberMesh > logs/005_renumberMesh.log 2>&1
decomposePar > logs/09_decomposePar_secondaIterazione.log 2>&1
mpirun --hostfile machinefile.$JOB_ID -np 40 potentialFoam -parallel > logs/10_potentialFoam.log 2>&1
mpirun --hostfile machinefile.$JOB_ID -np 40 simpleFoam -parallel > logs/11_simpleFoam.log 2>&1
reconstructPar > logs/10_reconstructPar.log 2>&1

touch train.foam
