       IDENTIFICATION DIVISION.
       PROGRAM-ID. PREPARE-DUMMY-DATA.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT USER-ACCOUNT-FILE ASSIGN TO "USER-ACCOUNT.DAT"
               ORGANIZATION IS SEQUENTIAL.
           SELECT INPUT-FILE ASSIGN TO "InCollege-Input.txt"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD USER-ACCOUNT-FILE.
       01 USER-ACCOUNT-REC.
           05 USER-NAME     PIC X(100).
           05 USER-PASSWORD PIC X(12).

       FD INPUT-FILE.
       01 INPUT-RECORD PIC X(100).

       WORKING-STORAGE SECTION.
       01 DUMMY-USERS.
           05 DUMMY-ENTRY OCCURS 5 TIMES.
              10 D-USER-NAME     PIC X(100).
              10 D-USER-PASSWORD PIC X(12).

       01 I PIC 9 VALUE 1.

       PROCEDURE DIVISION.
       MAIN-PARA.
           PERFORM INIT-DATA.
           PERFORM CREATE-USER-ACCOUNT-FILE.
           PERFORM CREATE-INPUT-FILE.
           STOP RUN.

       INIT-DATA.
           MOVE "testuser1"  TO D-USER-NAME(1).
           MOVE "Password@1" TO D-USER-PASSWORD(1).

           MOVE "seconduser" TO D-USER-NAME(2).
           MOVE "P@ssword2!" TO D-USER-PASSWORD(2).

           MOVE "thirduser"  TO D-USER-NAME(3).
           MOVE "Hello@123"  TO D-USER-PASSWORD(3).

           MOVE "fourthuser" TO D-USER-NAME(4).
           MOVE "World@456"  TO D-USER-PASSWORD(4).

           MOVE "fifthuser"  TO D-USER-NAME(5).
           MOVE "Final@789"  TO D-USER-PASSWORD(5).

       CREATE-USER-ACCOUNT-FILE.
           OPEN OUTPUT USER-ACCOUNT-FILE
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > 5
               MOVE D-USER-NAME(I) TO USER-NAME
               MOVE D-USER-PASSWORD(I) TO USER-PASSWORD
               WRITE USER-ACCOUNT-REC
           END-PERFORM
           CLOSE USER-ACCOUNT-FILE.

       CREATE-INPUT-FILE.
           OPEN OUTPUT INPUT-FILE

           *> Menu choice: 1 = login
           MOVE "1" TO INPUT-RECORD
           WRITE INPUT-RECORD

           *> Username for login
           MOVE "testuser1" TO INPUT-RECORD
           WRITE INPUT-RECORD

           *> Password for login
           MOVE "Password@1" TO INPUT-RECORD
           WRITE INPUT-RECORD

           *> Menu choice: 3 = exit
           MOVE "3" TO INPUT-RECORD
           WRITE INPUT-RECORD

           CLOSE INPUT-FILE.
