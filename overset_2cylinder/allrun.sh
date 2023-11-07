# sed -i -e 's/\r$//' 스크립트파일명  => 실행 필요
rm -rf cylinder1/constant/polyMesh
rm -rf cylinder2/constant/polyMesh
rm -rf background/constant/polyMesh

cd ./solution
rm -rf 0.[0-9]* [1-9]* postPro* process*
rm -rf 0
#
#background
cd ../background
blockMesh -dict ./system/blockMeshDict
topoSet -dict ./system/topoSetDict_Level1
refineMesh -overwrite
topoSet -dict ./system/topoSetDict_Level2
refineMesh -overwrite
rm -rf ./0
rm ./constant/polyMesh/*Zones
topoSet
rm -rf ./constant/polyMesh/sets

#cylinder1
cd ../cylinder1
#
blockMesh
#
topoSet
#
# Add the cylinder mesh on background mesh
#
cd ../background
mergeMeshes . ../cylinder1 -overwrite
rm -rf ../solution/constant/polyMesh
cp -r ./constant/polyMesh ../solution/constant/polyMesh

#cylinder2
cd ../cylinder2
#
blockMesh
#
topoSet

Add the cylinder mesh on background mesh

cd ../background
mergeMeshes . ../cylinder2 -overwrite
rm -rf ../solution/constant/polyMesh
cp -r ./constant/polyMesh ../solution/constant/polyMesh

# Call solver
cd ../solution
rm -rf 0.[0-9] [1-9]* postPro* process*
cp -r 0.orig 0
setFields
foamDictionary system/controlDict -entry endTime -set 1000
foamDictionary system/controlDict -entry deltaT -set 1
foamDictionary system/controlDict -entry writeInterval -set 100
foamDictionary system/fvSchemes -entry ddtSchemes.default -set 'steadyState'
foamDictionary system/fvSolution -entry relaxationFactors.fields.p -set 0.3
foamDictionary system/fvSolution -entry relaxationFactors.equations.U -set 0.3
overSimpleFoam

rm -rf 0
mv 1000/ 0
rm -rf 0/uniform/
rm -rf 0.[0-9] [1-9]* postPro* process*
foamDictionary system/controlDict -entry endTime -set 10
foamDictionary system/controlDict -entry deltaT -set 1e-5
foamDictionary system/controlDict -entry writeInterval -set 0.05
foamDictionary system/fvSchemes -entry ddtSchemes.default -set 'backward'
foamDictionary system/fvSolution -entry relaxationFactors.fields.p -set 1
foamDictionary system/fvSolution -entry relaxationFactors.equations.U -set 1

#- single core running
overPimpleDyMFoam
