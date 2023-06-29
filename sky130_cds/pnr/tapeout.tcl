# Output GDSII
streamOut final.gds -mapFile streamOut.map -stripes 1 -units 1000 -mode ALL
saveNetlist -excludeLeafCell final.v

# Run DRC and Connection checks
verifyGeometry
verifyConnectivity -type all -noAntenna
