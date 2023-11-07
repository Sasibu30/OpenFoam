#
# Add the cylinder mesh
mergeMeshes . ../cylinder -overwrite
#
## Make it a bit smaller to keep it laminar
#transformPoints -scale '(0.0016 0.0016 0.001)'

# Use cellZones to write zoneID
rm -rf 0 && cp -r 0.orig 0
setFields
