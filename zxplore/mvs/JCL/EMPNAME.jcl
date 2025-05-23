//EMPNAMEJ JOB 1,NOTIFY=&SYSUID
//*
//*   VSAM <KSDS> ALTERNATE INDEX AND PATH NAME FOR EMPLOYEE FILE
//*                                             (BY PRIMARY NAME)
// EXPORT SYMLIST=(*)
// SET ENTITY='EMPMAST'
// SET ALTIND='EMPNAME'
//*
//DEFINE  EXEC PGM=IDCAMS
//SYSPRINT  DD SYSOUT=*
//SYSIN     DD *,SYMBOLS=CNVTSYS
  DELETE &SYSUID..PSIN.&ALTIND. -
         ALTERNATEINDEX
  SET    MAXCC=0
  DEFINE ALTERNATEINDEX ( -
            NAME ( &SYSUID..PSIN.&ALTIND. ) -
            RELATE ( &SYSUID..PSVS.&ENTITY. ) -
            KEYS(38,87) -
            RECORDSIZE(51,51) -
            UNIQUEKEY -
            UPGRADE -
            VOLUME(VPWRKB) -
            TRACKS(1,1) -
            CONTROLINTERVALSIZE(4096) )
  DEFINE PATH ( -
            NAME ( &SYSUID..PSPT.&ALTIND. ) -
            PATHENTRY ( &SYSUID..PSIN.&ALTIND. ) )
  BLDINDEX  INDATASET ( &SYSUID..PSVS.&ENTITY. ) -
            OUTDATASET ( &SYSUID..PSIN.&ALTIND. )
/*
