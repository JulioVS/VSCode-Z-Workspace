# IBM Z XPLORE FULL BACKUP
# Zowe CLI commands to download files from z/OS

# CLEANUP
rm -r mvs
rm -r uss

# TSO/MVS LIBRARIES (PDS)
zowe files download am "Z45864.CBL"       -e ".cbl" --po  
zowe files download am "Z45864.COPYLIB"   -e ".cpy" --po
zowe files download am "Z45864.DCLGEN"    -e ".txt" --po
zowe files download am "Z45864.IMS.JCL"   -e ".jcl" --po
zowe files download am "Z45864.INPUT"     -e ".txt" --po
zowe files download am "Z45864.JCL"       -e ".jcl" --po
zowe files download am "Z45864.MAPS"      -e ".asm" --po
zowe files download am "Z45864.OUTPUT"    -e ".txt" --po
zowe files download am "Z45864.PROCLIB"   -e ".jcl" --po
zowe files download am "Z45864.SOURCE"    -e ".txt" --po
zowe files download am "Z45864.SQL.IN"    -e ".sql" --po

# TSO/MVS SEQUENTIAL FILES (PS)
zowe files download ds "Z45864.COMPLETE"  -e ".txt" --po 
zowe files download ds "Z45864.DB2OUT"    -e ".txt" --po
zowe files download ds "Z45864.JCL3OUT"   -e ".txt" --po
zowe files download ds "Z45864.SPUFI.IN"  -e ".sql" --po
zowe files download ds "Z45864.SPUFI.OUT" -e ".txt" --po

# RENAME
mv Z45864 mvs

# USS FULL DIRECTORY
zowe files download uss-directory /z/z45864 --directory uss

# CLEANUP
rm -r uss/mq-dev-patterns/JMS    
rm    uss/mq-dev-patterns/LICENSE
rm -r uss/zosmf/workflows 

# RESULTING FILES AND DIRECTORIES INCLUDED IN MY 'VSCODE Z WORKSPACE'
# THEN COMMITED AND UPLOADED TO GITHUB

# FULL BACKUP DATE => 08-08-2025.-

# RUN THIS AS: ./zowescript.sh
