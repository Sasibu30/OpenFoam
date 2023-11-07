#
rm -rf constant/polyMesh
#
blockMesh
#
topoSet -dict system/topoSetDict_Level1
refineMesh -overwrite
#
topoSet -dict system/topoSetDict_Level2
refineMesh -overwrite
#
#topoSet -dict system/topoSetDict_Level3
#refineMesh -overwrite
#
rm -rf 0
rm constant/polyMesh/*Zones
#
topoSet
rm -rf constant/polyMesh/sets
