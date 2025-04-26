         START ,
         YREGS ,                 register equates, syslib SYS1.MACLIB
FIBONACI CSECT ,                 start of the code
FIBONACI AMODE 31                set addressing mode to 31 bit
FIBONACI RMODE ANY
*---------------------------------------------------------------------
* Linkage and allocate memory
*---------------------------------------------------------------------
         BAKR  R14,0             use linkage stack convention
         LR    R12,R15           z/OS puts start addr in R15
         USING FIBONACI,R12      CSECT base register
         STORAGE OBTAIN,LENGTH=WALEN1        DSECT dynamic storage
         LR    R10,R1            load address of Storage DSECT in R10
         USING WAREA1,R10        DSECT base register
         MVC   SAVEA1+4(4),=C'F1SA'       linkage stack convention
         LAE   R13,SAVEA1        load address of our SAVEA(rea) in R13
*---------------------------------------------------------------------
* Application logic
*---------------------------------------------------------------------
         MVC   WACALL(LDCALL),DCALL          init BPX1WRT
         MVI   RESULT,C' '       init first byte of RESULT to blank
         MVC   RESULT+1(L'RESULT-1),RESULT   copy first byte to rest
         LA    R6,RESULT         load address of result in R6
         ST    R6,BUFFADDR       address of result in BUFFADR
         LA    R2,0              set the first sequence number in R2
         CVD   R2,PACKED         convert to decimal, store in PACKED
         BAS   R7,TOSTDOUT       jump to subroutine and save address
         LA    R3,1              set the second sequence number in R3
         CVD   R3,PACKED         convert to decimal, store in PACKED
         BAS   R7,TOSTDOUT       jump to subroutine and save address
         LA    R5,38             counter to print another 38 numbers
LOOP     DS    0H                start of loop
         LR    R4,R3             save last fibonacci number in R4
         AR    R2,R3             add current 'last two' into R2
         CVD   R2,PACKED         convert to decimal, store in PACKED
         BAS   R7,TOSTDOUT       jump to subroutine and save address
         LR    R3,R2             save new 'last number' in R3
         LR    R2,R4             save new 'second to last' in R3
         BCT   R5,LOOP           decrease counter and loop back
*---------------------------------------------------------------------
* Linkage and free storage. Set RC into Register 15
*---------------------------------------------------------------------
         STORAGE RELEASE,ADDR=(R10),LENGTH=WALEN1
         LA    R15,0             the return code, 0 if all went OK
         PR    ,                 return to caller
*---------------------------------------------------------------------
* Subroutine
*---------------------------------------------------------------------
TOSTDOUT DS    0H
         OI    PACKED+7,X'0F'    logical OR to make last digit 'F'
         UNPK  ZONED,PACKED      unpack to a format of 'FnFn...Fn'
         MVC   RESULT(L'ZONED),ZONED   all chars from Zoned to Result
         MVI   RESULT+L'ZONED,X'15'    add a Unix new line char
         CALL  BPX1WRT,(FILEDESC,                                      x
               BUFFADDR,                                               x
               ALET,                                                   x
               WRITECNT,                                               x
               WARETVAL,                                               x
               WARC,                                                   x
               WARSN),MF=(E,WACALL)
         BR    R7
*---------------------------------------------------------------------
* Constants and literal pool
*---------------------------------------------------------------------
DCALL    CALL  ,(0,0,0,0,0,0,0),MF=L 
LDCALL   EQU   *-DCALL
FILEDESC DC    F'1'              stdout
ALET     DC    F'0'
WRITECNT DC    F'9'              8 digit number + new line (9 chars)
         LTORG ,                 create literal pool
WAREA1   DSECT ,                 convention
SAVEA1   DS    18F               describes allocated mem convention 
PACKED   DS    CL8               to store the packed decimal, needs 8B
ZONED    DS    CL8               to store the zoned decimal, needs 8B
RESULT   DS    CL32              creates symbol for 32 bytes to hold 
         DS    0D                creates an alignment on a full addr
WACALL   DS    CL(LDCALL)
BUFFADDR DS    F
WARETVAL DS    F
WARC     DS    F
WARSN    DS    F
WALEN1   EQU   *-SAVEA1          * = current location counter offset
         END   FIBONACI
