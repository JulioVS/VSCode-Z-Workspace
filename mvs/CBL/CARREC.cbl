       IDENTIFICATION DIVISION.
       PROGRAM-ID. CARREC.
      ******************************************************************
      *   BUILD 3270 OUPUT STREAM THE HARD WAY.-
      *   (PLURALSIGHT CICS COURSE MODULE 4 LESSON 5)
      ******************************************************************
       DATA DIVISION.
       WORKING-STORAGE SECTION.

       01 DATA-STREAM.
          05 FILLER    PIC X     VALUE X'11'.
          05 FILLER    PIC X(02) VALUE X'40D6'.
          05 FILLER    PIC X     VALUE X'1D'.
          05 FILLER    PIC X     VALUE X'F8'.
          05 FILLER    PIC X(10) VALUE 'Car Record'.
      *
          05 FILLER    PIC X     VALUE X'11'.
          05 FILLER    PIC X(02) VALUE X'C260'.
          05 FILLER    PIC X     VALUE X'1D'.
          05 FILLER    PIC X     VALUE X'F0'.
          05 FILLER    PIC X(12) VALUE 'Employee No:'.
      *
          05 FILLER    PIC X     VALUE X'29'.
          05 FILLER    PIC X     VALUE X'02'.
          05 FILLER    PIC X     VALUE X'41'.
          05 FILLER    PIC X     VALUE X'F4'.
          05 FILLER    PIC X     VALUE X'C0'.
          05 FILLER    PIC X     VALUE X'50'.
          05 FILLER    PIC X     VALUE X'13'.
      *
          05 FILLER    PIC X     VALUE X'11'.
          05 FILLER    PIC X(02) VALUE X'C2F4'.
          05 FILLER    PIC X     VALUE X'1D'.
          05 FILLER    PIC X     VALUE X'F0'.
          05 FILLER    PIC X(9)  VALUE '  Tag No:'.
      *
          05 FILLER    PIC X     VALUE X'29'.
          05 FILLER    PIC X     VALUE X'02'.
          05 FILLER    PIC X     VALUE X'41'.
          05 FILLER    PIC X     VALUE X'F4'.
          05 FILLER    PIC X     VALUE X'C0'.
          05 FILLER    PIC X     VALUE X'40'.
      *
          05 FILLER    PIC X     VALUE X'11'.
          05 FILLER    PIC X(02) VALUE X'C3C7'.
          05 FILLER    PIC X     VALUE X'1D'.
          05 FILLER    PIC X     VALUE X'F0'.
          05 FILLER    PIC X(8)  VALUE '  State:'.
      *
          05 FILLER    PIC X     VALUE X'29'.
          05 FILLER    PIC X     VALUE X'02'.
          05 FILLER    PIC X     VALUE X'41'.
          05 FILLER    PIC X     VALUE X'F4'.
          05 FILLER    PIC X     VALUE X'C0'.
          05 FILLER    PIC X     VALUE X'40'.
          05 FILLER    PIC X(02) VALUE X'0000'.
      *
          05 FILLER    PIC X     VALUE X'1D'.
          05 FILLER    PIC X     VALUE X'F0'.

       PROCEDURE DIVISION.
           EXEC CICS SEND
                FROM (DATA-STREAM)
                LENGTH (LENGTH OF DATA-STREAM)
                ERASE
                END-EXEC.

           EXEC CICS RETURN
                END-EXEC.
