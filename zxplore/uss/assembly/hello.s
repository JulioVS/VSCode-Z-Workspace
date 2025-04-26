         START ,
         YREGS ,                 register equates, syslib SYS1.MACLIB
HELLOWOR CSECT ,                 start of the code
HELLOWOR AMODE 31                set addressing mode to 31 bit
HELLOWOR RMODE ANY
*---------------------------------------------------------------------
* Linkage and allocate memory
*---------------------------------------------------------------------
         BAKR  R14,0             use linkage stack convention
         LR    R12,R15           z/OS puts start addr in R15
         USING HELLOWOR,R12      CSECT base register
         STORAGE OBTAIN,LENGTH=WALEN1        DSECT dynamic storage
         LR    R10,R1            load address of Storage DSECT in R10
         USING WAREA1,R10        DSECT base register
         MVC   SAVEA1+4(4),=C'F1SA'       linkage stack convention
         LAE   R13,SAVEA1        load address of our SAVEA(rea) in R13
*---------------------------------------------------------------------
* Application logic
*---------------------------------------------------------------------
         MVC   WACALL(LDCALL),DCALL          init BPX1WRT
         MVI   HELLOW,C' '       init first byte of HELLOW to blank
         MVC   HELLOW+1(L'HELLOW-1),HELLOW   copy first byte to rest
         MVC   HELLOW(12),=C'Hello World!'   load string in HELLOW
         MVI   HELLOW+12,X'15'   add new line character at end
         LA    R6,HELLOW         load address of result in R6
         ST    R6,BUFFADDR       address of result in BUFFADR
         CALL  BPX1WRT,(FILEDESC,                                      x
               BUFFADDR,                                               x
               ALET,                                                   x
               WRITECNT,                                               x
               WARETVAL,                                               x
               WARC,                                                   x
               WARSN),MF=(E,WACALL)
*---------------------------------------------------------------------
* Linkage and free storage. Set RC into Register 15
*---------------------------------------------------------------------
         STORAGE RELEASE,ADDR=(R10),LENGTH=WALEN1
         LA    R15,0             the return code, 0 if all went OK
         PR    ,                 return to caller
*---------------------------------------------------------------------
* Constants and literal pool
*---------------------------------------------------------------------
DCALL    CALL  ,(0,0,0,0,0,0,0),MF=L 
LDCALL   EQU   *-DCALL
FILEDESC DC    F'1'              stdout
ALET     DC    F'0'
WRITECNT DC    F'13'             print phrase + new line (13 chars)
         LTORG ,                 create literal pool
WAREA1   DSECT ,                 convention
SAVEA1   DS    18F               describes allocated mem convention 
HELLOW   DS    CL15              creates symbol for 15 bytes to hold 
         DS    0D                creates an alignment on a full addr
WACALL   DS    CL(LDCALL)
BUFFADDR DS    F
WARETVAL DS    F
WARC     DS    F
WARSN    DS    F
WALEN1   EQU   *-SAVEA1          * = current location counter offset
         END   HELLOWOR
