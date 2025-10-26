# IBM Z XPLORE FULL BACKUP
# Zowe CLI commands to download files from z/OS

# CLEANUP
rm -r mvs
rm -r uss

# TSO/MVS LIBRARIES (PDS)
zowe files download am "Z45864.CBL"         -e ".cbl"  --po  
zowe files download am "Z45864.CICS.SYSIN"  -e ".txt"  --po
zowe files download am "Z45864.COPYLIB"     -e ".cpy"  --po
zowe files download am "Z45864.DCLGEN"      -e ".txt"  --po
zowe files download am "Z45864.IMS.DBDSRC"  -e ".dbd"  --po
zowe files download am "Z45864.IMS.DLIIN"   -e ".cntl" --po
zowe files download am "Z45864.IMS.DLIOUT"  -e ".txt"  --po
zowe files download am "Z45864.IMS.JCL"     -e ".jcl"  --po
zowe files download am "Z45864.IMS.MFSSRC"  -e ".mfs"  --po
zowe files download am "Z45864.IMS.PGMSRC"  -e ".cbl"  --po
zowe files download am "Z45864.IMS.PROCLIB" -e ".jcl"  --po
zowe files download am "Z45864.IMS.PSBSRC"  -e ".pcb"  --po
zowe files download am "Z45864.INPUT"       -e ".txt"  --po
zowe files download am "Z45864.JCL"         -e ".jcl"  --po
zowe files download am "Z45864.LAB.DEMO"    -e ".txt"  --po
zowe files download am "Z45864.MAPS"        -e ".asm"  --po
zowe files download am "Z45864.OUTPUT"      -e ".txt"  --po
zowe files download am "Z45864.PROCLIB"     -e ".jcl"  --po
zowe files download am "Z45864.SOURCE"      -e ".txt"  --po
zowe files download am "Z45864.SQL"         -e ".sql"  --po

# TSO/MVS SEQUENTIAL FILES (PS)
zowe files download ds "Z45864.COMPLETE"    -e ".txt"  --po 
zowe files download ds "Z45864.DB2OUT"      -e ".txt"  --po
zowe files download ds "Z45864.JCL3OUT"     -e ".txt"  --po
zowe files download ds "Z45864.SPUFI.IN"    -e ".sql"  --po
zowe files download ds "Z45864.SPUFI.OUT"   -e ".txt"  --po

# RENAME
mv Z45864 mvs

# USS FULL DIRECTORY
zowe files download uss-directory /z/z45864 --directory uss

# CLEANUP
rm -r uss/mq-dev-patterns/JMS    
rm    uss/mq-dev-patterns/LICENSE
rm -r uss/zosmf/workflows 

# RUN THIS AS: ./zowescript.sh
