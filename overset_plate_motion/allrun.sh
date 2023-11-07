# sed -i -e 's/\r$//' 스크립트파일명  => 실행 필요
rm -rf plate/constant/polyMesh
rm -rf background/constant/polyMesh
#
#background
#
cd background
blockMesh -dict ./system/blockMeshDict
topoSet -dict ./system/topoSetDict_Level1
refineMesh -overwrite
topoSet -dict ./system/topoSetDict_Level2
refineMesh -overwrite
rm -rf ./0
rm ./constant/polyMesh/*Zones
topoSet
rm -rf ./constant/polyMesh/sets

#plate1
cd ../plate1
blockMesh
topoSet

#plate2
cd ../plate2
blockMesh
topoSet

# Add the cylinder mesh on background mesh
#
cd ../background
mergeMeshes . ../plate1 -overwrite
mergeMeshes . ../plate2 -overwrite
rm -rf ../overPimpleDyMFoam/constant/polyMesh
cp -r ./constant/polyMesh ../overPimpleDyMFoam/constant/polyMesh

#Call solver
cd ../overPimpleDyMFoam
rm -rf 0.[0-9]* [1-9]* postPro* process*
rm -rf 0 && cp -r 0.orig 0
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
rm -rf 0.[0-9]* [1-9]* postPro* process*
foamDictionary system/controlDict -entry endTime -set 10
foamDictionary system/controlDict -entry deltaT -set 1e-5
foamDictionary system/controlDict -entry writeInterval -set 0.02
foamDictionary system/fvSchemes -entry ddtSchemes.default -set 'backward'
foamDictionary system/fvSolution -entry relaxationFactors.fields.p -set 1
foamDictionary system/fvSolution -entry relaxationFactors.equations.U -set 1

#- single core running
overPimpleDyMFoam
