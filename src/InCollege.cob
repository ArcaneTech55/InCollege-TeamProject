      >>SOURCE FORMAT FREE
       IDENTIFICATION DIVISION.
       PROGRAM-ID. INCOLLEGE.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT INPUT-FILE ASSIGN TO "InCollege-Input.txt"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT OUTPUT-FILE ASSIGN TO "InCollege-Output.txt"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT USER-ACCOUNT-FILE ASSIGN TO "data/USER-ACCOUNT.DAT"
               ORGANIZATION IS SEQUENTIAL
               FILE STATUS IS WS-USER-FILE-STATUS.
           SELECT USER-PROFILE-FILE ASSIGN TO "data/USER-PROFILE.DAT"
               ORGANIZATION IS SEQUENTIAL
               FILE STATUS IS WS-PROFILE-FILE-STATUS.
           SELECT TEMP-PROFILE-FILE ASSIGN TO "data/TEMP-PROFILE.DAT"
               ORGANIZATION IS SEQUENTIAL
               FILE STATUS IS WS-TEMP-PROFILE-FILE-STATUS.
           SELECT OPTIONAL CONNECTIONS-FILE ASSIGN TO "data/CONNECTIONS.DAT"
               ORGANIZATION IS SEQUENTIAL
               FILE STATUS IS WS-CONNECTIONS-FILE-STATUS.
           SELECT OPTIONAL ESTABLISHED-CONNECTIONS-FILE ASSIGN TO "data/ESTABLISHED-CONNECTIONS.DAT"
               ORGANIZATION IS SEQUENTIAL
               FILE STATUS IS WS-EST-CONN-FILE-STATUS.

       DATA DIVISION.
       FILE SECTION.
       FD INPUT-FILE.
       01 INPUT-RECORD PIC X(500).

       FD OUTPUT-FILE.
       01 OUTPUT-RECORD PIC X(300).

       FD USER-ACCOUNT-FILE.
       01 USER-ACCOUNT-REC.
           05 USER-NAME     PIC X(100).
           05 USER-PASSWORD PIC X(100).

       FD USER-PROFILE-FILE.
       01 USER-PROFILE-REC.
           05 UP-USER-NAME   PIC X(100).
           05 UP-FIRST-NAME  PIC X(30).
           05 UP-LAST-NAME   PIC X(30).
           05 UP-UNIVERSITY  PIC X(40).
           05 UP-MAJOR       PIC X(40).
           05 UP-GRAD-YEAR   PIC 9(4).
           05 UP-ABOUT-ME    PIC X(200).
           05 UP-NUM-EXP     PIC 9.
           05 UP-EXPERIENCE-TABLE.
               10 UP-EXPERIENCE-ENTRY OCCURS 3 TIMES.
                   15 UP-EXP-TITLE     PIC X(100).
                   15 UP-EXP-COMPANY   PIC X(100).
                   15 UP-EXP-DATE      PIC X(50).
                   15 UP-EXP-DESC      PIC X(100).
           05 UP-NUM-EDU     PIC 9.
           05 UP-EDUCATION-TABLE.
               10 UP-EDUCATION-ENTRY OCCURS 3 TIMES.
                   15 UP-EDU-DEGREE    PIC X(100).
                   15 UP-EDU-UNI       PIC X(100).
                   15 UP-EDU-YEARS     PIC X(50).

       FD TEMP-PROFILE-FILE.
       01 TEMP-PROFILE-REC       PIC X(6000).

       FD CONNECTIONS-FILE.
       01 CONNECTION-REC.
           05 CONN-FROM-USER     PIC X(100).
           05 CONN-TO-USER       PIC X(100).
           05 CONN-STATUS        PIC X(10).

       FD ESTABLISHED-CONNECTIONS-FILE.
       01 ESTABLISHED-CONNECTION-REC.
           05 EST-CONN-USER1     PIC X(100).
           05 EST-CONN-USER2     PIC X(100).

       WORKING-STORAGE SECTION.
       01 WS-FLAGS.
           05 WS-END-OF-FILE PIC X VALUE 'N'.
              88 WS-EOF-FLAG      VALUE 'Y'.
              88 WS-NOT-EOF-FLAG  VALUE 'N'.
           05 WS-LOGIN-FLAG PIC X.
              88 WS-LOGIN-SUCCESSFUL VALUE 'Y'.
              88 WS-LOGIN-FAILED     VALUE 'N'.
           05 WS-VALIDATION-FLAG PIC X.
              88 WS-PASSWORD-IS-VALID   VALUE 'Y'.
              88 WS-PASSWORD-IS-INVALID VALUE 'N'.
           05 WS-ACCOUNT-CREATED-FLAG PIC X.
              88 WS-ACCOUNT-CREATED     VALUE 'Y'.
              88 WS-ACCOUNT-NOT-CREATED VALUE 'N'.
           05 WS-EXIT-STATUS PIC X VALUE 'N'.
              88 WS-USER-WANT-TO-EXIT VALUE 'Y'.
           05 WS-SKIP-MENU-DRAW PIC X VALUE 'N'.
              88 WS-SKIP-MENU-TRUE  VALUE 'Y'.
              88 WS-SKIP-MENU-FALSE VALUE 'N'.
           05 WS-USER-FILE-STATUS    PIC XX VALUE "00".
           05 WS-CUR-CHAR            PIC X.
           05 WS-PROFILE-FILE-STATUS PIC XX VALUE "00".
           05 WS-TEMP-PROFILE-FILE-STATUS PIC XX VALUE "00".
           05 WS-CONNECTIONS-FILE-STATUS PIC XX VALUE "00".
           05 WS-EST-CONN-FILE-STATUS PIC XX VALUE "00".
           05 WS-FOUND-PROFILE            PIC X VALUE 'N'.
              88 WS-PROFILE-FOUND      VALUE 'Y'.
              88 WS-PROFILE-NOT-FOUND  VALUE 'N'.
           05 WS-INPUT-FIELD               PIC X.
              88 WS-VALID-FIELD           VALUE 'Y'.
              88 WS-INVALID-FIELD         VALUE 'N'.

       01 WS-COUNTERS.
           05 WS-USER-ACCOUNT-COUNT PIC 99 VALUE 0.
           05 I                     PIC 99.
           05 J                     PIC 99.

       01 WS-USER-ACCOUNT-TABLE.
           05 WS-USER OCCURS 5 TIMES INDEXED BY IDX.
               10 WS-USER-NAME     PIC X(100).
               10 WS-USER-PASSWORD PIC X(100).

       01 WS-INPUT-VARIABLES.
           05 WS-INPUT-CHOICE   PIC X(1).
           05 WS-INPUT-USERNAME PIC X(100).
           05 WS-INPUT-PASSWORD PIC X(100).

       01 WS-PROFILE-WORK.
           05 WS-FIRST-NAME         PIC X(30).
           05 WS-LAST-NAME          PIC X(30).
           05 WS-UNIVERSITY         PIC X(40).
           05 WS-MAJOR              PIC X(40).
           05 WS-GRAD-YEAR          PIC 9(4).
           05 WS-ABOUT-ME           PIC X(200).
           05 WS-NUM-EXP            PIC 9.
           05 WS-EXPERIENCE-TABLE.
              10 WS-EXPERIENCE-ENTRY OCCURS 3 TIMES.
                 15 WS-EXP-TITLE       PIC X(100).
                 15 WS-EXP-COMPANY     PIC X(100).
                 15 WS-EXP-DATES       PIC X(50).
                 15 WS-EXP-DESCRIPTION PIC X(100).
           05 WS-NUM-EDU            PIC 9.
           05 WS-EDUCATION-TABLE.
              10 WS-EDUCATION-ENTRY OCCURS 3 TIMES.
                 15 WS-EDU-DEGREE      PIC X(100).
                 15 WS-EDU-UNIVERSITY  PIC X(100).
                 15 WS-EDU-YEARS       PIC X(50).

       01 WS-USER-PROFILE-REC.
           05 UP-PROFILE-USERNAME   PIC X(100).
           05 UP-FIRST-NAME         PIC X(30).
           05 UP-LAST-NAME          PIC X(30).
           05 UP-UNIVERSITY         PIC X(40).
           05 UP-MAJOR              PIC X(40).
           05 UP-GRAD-YEAR          PIC 9(4).
           05 UP-ABOUT-ME           PIC X(200).
           05 UP-NUM-EXP            PIC 9.
           05 UP-EXPERIENCE-TABLE.
              10 UP-EXPERIENCE-ENTRY OCCURS 3 TIMES.
                 15 UP-EXP-TITLE       PIC X(100).
                 15 UP-EXP-COMPANY     PIC X(100).
                 15 UP-EXP-DATES       PIC X(50).
                 15 UP-EXP-DESCRIPTION PIC X(100).
           05 UP-NUM-EDU            PIC 9.
           05 UP-EDUCATION-TABLE.
              10 UP-EDUCATION-ENTRY OCCURS 3 TIMES.
                 15 UP-EDU-DEGREE      PIC X(100).
                 15 UP-EDU-UNIVERSITY  PIC X(100).
                 15 UP-EDU-YEARS       PIC X(50).

       01 WS-SEARCH-CRITERIA.
           05 WS-SEARCH-FIRST-NAME         PIC X(100) VALUE SPACES.
           05 WS-SEARCH-LAST-NAME          PIC X(100) VALUE SPACES.

       01 WS-GENERIC-INPUT          PIC X(100).
       01 WS-CURRENT-USER           PIC X(100) VALUE SPACES.

       01 WS-VALIDATION-FIELDS.
           05 WS-PASSWORD-LENGTH PIC 999.
           05 WS-HAS-CAPITAL     PIC X.
           05 WS-HAS-DIGIT       PIC X.
           05 WS-HAS-SPECIAL     PIC X.
           05 WS-SPECIAL-CHARS   PIC X(10) VALUE "!@#$%^&*()".

       01 DISPLAY-MSG              PIC X(300) VALUE SPACES.
       01 WS-WELCOME-MSG           PIC X(25)  VALUE 'Welcome to InCollege!'.
       01 WS-PROMPT-LOGIN          PIC X(28)  VALUE '1. Log In'.
       01 WS-PROMPT-REGISTER       PIC X(28)  VALUE '2. Create New Account'.
       01 WS-PROMPT-EXIT           PIC X(28)  VALUE '3. Exit'.
       01 WS-PROMPT-CHOICE         PIC X(20)  VALUE 'Enter your choice:'.
       01 WS-PROMPT-USERNAME       PIC X(28)  VALUE 'Please enter your username:'.
       01 WS-PROMPT-PASSWORD       PIC X(28)  VALUE 'Please enter your password:'.
       01 WS-SUCCESSFUL-LOGIN-MSG  PIC X(50)  VALUE 'You have successfully logged in.'.
       01 WS-PROFILE-MENU-VIEW     PIC X(30)  VALUE '1. View My Profile'.
       01 WS-FIND-SOMEONE-MSG      PIC X(28)  VALUE '2. Search for User'.
       01 WS-LEARN-SKILL-MSG       PIC X(28)  VALUE '3. Learn a New Skill'.
       01 WS-VIEW-CONN-REQ-MSG     PIC X(50)  VALUE '4. View My Pending Connection Requests'.
       01 WS-VIEW-NETWORK-MSG      PIC X(30)  VALUE '5. View My Network'.
       01 WS-PROFILE-MENU-EDIT     PIC X(30)  VALUE '6. Create/Edit My Profile'.
       01 WS-SEARCH-JOB-MSG        PIC X(28)  VALUE '3. Search for a job'.
       01 WS-LOG-OUT-MSG           PIC X(28)  VALUE '7. Log Out'.
       01 WS-UC-JOB-MSG            PIC X(60)  VALUE 'Job search/internship is under construction.'.
       01 WS-UC-FIND-MSG           PIC X(60)  VALUE 'Find someone you know is under construction.'.
       01 WS-LEARN-SKILL-HEADER    PIC X(22)  VALUE 'Learn a New Skill:'.
       01 WS-SKILL-1               PIC X(10)  VALUE 'Skill 1'.
       01 WS-SKILL-2               PIC X(10)  VALUE 'Skill 2'.
       01 WS-SKILL-3               PIC X(10)  VALUE 'Skill 3'.
       01 WS-SKILL-4               PIC X(10)  VALUE 'Skill 4'.
       01 WS-SKILL-5               PIC X(10)  VALUE 'Skill 5'.
       01 WS-GO-BACK               PIC X(10)  VALUE 'Go Back'.
       01 WS-SKILL-UC-MSG          PIC X(60)  VALUE 'This skill is under construction.'.
       01 WS-INVALID-LOGIN-MSG     PIC X(50)  VALUE 'Incorrect username/password, please try again'.
       01 WS-MAX-ACCOUNTS-MSG      PIC X(100) VALUE 'All permitted accounts have been created, please come back later'.
       01 WS-PASSWORD-TOO-SHORT    PIC X(60)  VALUE 'Password must be at least 8 characters long.'.
       01 WS-PASSWORD-TOO-LONG     PIC X(60)  VALUE 'Password must be at most 12 characters long.'.
       01 WS-PASSWORD-NO-CAPITAL   PIC X(60)  VALUE 'Password must contain at least one capital letter.'.
       01 WS-PASSWORD-NO-DIGIT     PIC X(60)  VALUE 'Password must contain at least one digit.'.
       01 WS-PASSWORD-NO-SPECIAL   PIC X(60)  VALUE 'Password must contain at least one special character.'.
       01 WS-INVALID-CHOICE        PIC X(60)  VALUE 'Invalid choice. Please try again.'.
       01 WS-DUPLICATE-USERNAME-MSG PIC X(100) VALUE 'This username already exists. Please try another.'.

       *> PROFILE/INPUT PROMPTS
       01 WS-BLANK-INPUT-MSG       PIC X(60) VALUE 'Input cannot be blank. Please enter a value.'.
       01 WS-PROFILE-NOTFOUND-MSG  PIC X(60) VALUE 'No profile found. Use "Create/Edit My Profile" first.'.
       01 WS-PROFILE-SAVED-MSG     PIC X(60) VALUE 'Profile saved successfully.'.
       01 WS-NAME-INVALID-MSG      PIC X(60) VALUE 'Names must be letters only (A-Z).'.
       01 WS-GRAD-YEAR-INVALID     PIC X(60) VALUE 'Graduation year must be 1900-2100.'.
       01 WS-CREATE-EDIT-PROMPT    PIC X(100) VALUE '--- Create/Edit Profile ---'.
       01 WS-ENTER-FIRST           PIC X(40) VALUE 'Enter First Name:'.
       01 WS-ENTER-LAST            PIC X(40) VALUE 'Enter Last Name:'.
       01 WS-ENTER-UNIV            PIC X(40) VALUE 'Enter University:'.
       01 WS-ENTER-MAJOR           PIC X(40) VALUE 'Enter Major:'.
       01 WS-ENTER-GY              PIC X(40) VALUE 'Enter Grad Year (YYYY):'.
       01 WS-ENTER-ABOUT-ME        PIC X(200) VALUE 'Enter About Me (optional, max 200 chars, enter blank line to skip): '.
       01 WS-ENTER-EXP             PIC X(200) VALUE 'Add Experience (optional, max 3 entries. Enter DONE to finish): '.
       01 WS-ENTER-EDU             PIC X(200) VALUE 'Add Education (optional, max 3 entries. Enter DONE to finish): '.
       01 WS-SUCCESSFUL-PROFILE-SAVE  PIC X(100)  VALUE 'Profile saved successfully!'.

       01 WS-SEARCH-USER-MSG          PIC X(100) VALUE 'Enter the full name of the person you are looking for'.
       01 WS-TEMP-FIELD            PIC X(100).
       01 WS-TEMP-ABOUT-ME-BUFFER  PIC X(500).
       01 WS-TEMP-CONNECTION-REC   PIC X(210).
       01 WS-VALIDATED-YEAR        PIC 9(4).

       *> CONNECTION REQUEST MESSAGES AND VARIABLES
       01 WS-CONN-HEADER              PIC X(50) VALUE '--- Pending Connection Requests ---'.
       01 WS-CONN-FOOTER              PIC X(50) VALUE '-----------------------------------'.
       01 WS-NO-CONN-MSG              PIC X(60) VALUE 'You have no pending connection requests at this time.'.
       01 WS-CONN-SENT-MSG            PIC X(60) VALUE 'Connection request sent to '.
       01 WS-ALREADY-CONNECTED-MSG    PIC X(60) VALUE 'You are already connected with this user.'.
       01 WS-PENDING-FROM-THEM-MSG    PIC X(80) VALUE 'This user has already sent you a connection request.'.
       01 WS-SEND-CONN-REQ-MSG        PIC X(30) VALUE '1. Send Connection Request'.
       01 WS-BACK-TO-MENU-MSG         PIC X(30) VALUE '2. Back to Main Menu'.
       01 WS-ACCEPT-CONN-MSG          PIC X(20) VALUE '1. Accept'.
       01 WS-REJECT-CONN-MSG          PIC X(20) VALUE '2. Reject'.
       01 WS-CONN-ACCEPTED-MSG        PIC X(50) VALUE 'Connection request accepted!'.
       01 WS-CONN-REJECTED-MSG        PIC X(50) VALUE 'Connection request rejected.'.
       01 WS-NETWORK-HEADER           PIC X(20) VALUE '--- Your Network ---'.
       01 WS-NETWORK-FOOTER           PIC X(20) VALUE '--------------------'.
       01 WS-NO-NETWORK-MSG           PIC X(50) VALUE 'You have no connections at this time.'.
       01 WS-CONNECTED-WITH-MSG       PIC X(20) VALUE 'Connected with: '.
       01 WS-FOUND-PROFILE-HEADER     PIC X(30) VALUE '--- Found User Profile ---'.
       01 WS-FOUND-PROFILE-FOOTER     PIC X(30) VALUE '-------------------------'.
       01 WS-TARGET-USER-NAME         PIC X(100).
       01 WS-CONNECTION-EXISTS        PIC X VALUE 'N'.
          88 WS-CONN-EXISTS           VALUE 'Y'.
          88 WS-CONN-NOT-EXISTS       VALUE 'N'.

       *> NEW flags for experience input
       01 WS-DONE-FLAG                PIC X VALUE 'N'.
          88 WS-USER-TYPED-DONE       VALUE 'Y'.
          88 WS-USER-NOT-DONE         VALUE 'N'.
       01 WS-DONE-LITERAL             PIC X(4) VALUE 'DONE'.
       01 WS-EXP-PROMPT-TITLE         PIC X(80) VALUE ' - Title (or type DONE to finish):'.
       01 WS-EXP-PROMPT-COMPANY       PIC X(80) VALUE ' - Company/Organization (or DONE to finish):'.
       01 WS-EXP-PROMPT-DATES         PIC X(80) VALUE ' - Dates (e.g., Summer 2024) (or DONE to finish):'.
       01 WS-EXP-PROMPT-DESC          PIC X(80) VALUE ' - Description (or DONE to finish):'.
       01 WS-FIELD-BLANK-MSG          PIC X(80) VALUE 'Input cannot be blank. Enter a value or type DONE to stop.'.

       PROCEDURE DIVISION.

       0000-MAIN-LOGIC.
           PERFORM 1000-INITIALIZE-PROGRAM
           PERFORM 2000-SHOW-MENU UNTIL WS-USER-WANT-TO-EXIT
           PERFORM 9000-TERMINATE-PROGRAM
           STOP RUN.

       1000-INITIALIZE-PROGRAM.
           OPEN INPUT  INPUT-FILE
           OPEN OUTPUT OUTPUT-FILE

           OPEN INPUT USER-ACCOUNT-FILE
           IF WS-USER-FILE-STATUS = "00"
               PERFORM 1100-LOAD-USER-ACCOUNT-TABLE
           ELSE
               CLOSE USER-ACCOUNT-FILE
               OPEN OUTPUT USER-ACCOUNT-FILE
               CLOSE USER-ACCOUNT-FILE
               OPEN I-O USER-ACCOUNT-FILE
           END-IF

           OPEN INPUT USER-PROFILE-FILE
           IF WS-PROFILE-FILE-STATUS NOT = "00"
               CLOSE USER-PROFILE-FILE
               OPEN OUTPUT USER-PROFILE-FILE
               CLOSE USER-PROFILE-FILE
               OPEN I-O USER-PROFILE-FILE
           ELSE
               CLOSE USER-PROFILE-FILE
               OPEN I-O USER-PROFILE-FILE
           END-IF.

       1100-LOAD-USER-ACCOUNT-TABLE.
           MOVE 0 TO WS-USER-ACCOUNT-COUNT
           SET WS-NOT-EOF-FLAG TO TRUE
           PERFORM UNTIL WS-EOF-FLAG
               READ USER-ACCOUNT-FILE
                   AT END
                       SET WS-EOF-FLAG TO TRUE
                   NOT AT END
                       ADD 1 TO WS-USER-ACCOUNT-COUNT
                       MOVE USER-ACCOUNT-REC TO WS-USER(WS-USER-ACCOUNT-COUNT)
               END-READ
           END-PERFORM.

           *> Ensure connections file is recreated fresh each run
           OPEN OUTPUT CONNECTIONS-FILE
           CLOSE CONNECTIONS-FILE
           
           *> Ensure established connections file is recreated fresh each run
           OPEN OUTPUT ESTABLISHED-CONNECTIONS-FILE
           CLOSE ESTABLISHED-CONNECTIONS-FILE.

       2000-SHOW-MENU.
           IF WS-SKIP-MENU-FALSE
               MOVE WS-WELCOME-MSG TO DISPLAY-MSG
               PERFORM 8000-DISPLAY-ROUTINE
               MOVE WS-PROMPT-LOGIN TO DISPLAY-MSG
               PERFORM 8000-DISPLAY-ROUTINE
               MOVE WS-PROMPT-REGISTER TO DISPLAY-MSG
               PERFORM 8000-DISPLAY-ROUTINE
               MOVE WS-PROMPT-EXIT TO DISPLAY-MSG
               PERFORM 8000-DISPLAY-ROUTINE
               MOVE WS-PROMPT-CHOICE TO DISPLAY-MSG
               PERFORM 8000-DISPLAY-ROUTINE
           ELSE
               SET WS-SKIP-MENU-FALSE TO TRUE
           END-IF
           READ INPUT-FILE INTO WS-INPUT-CHOICE
               AT END SET WS-USER-WANT-TO-EXIT TO TRUE
           END-READ

           IF NOT WS-USER-WANT-TO-EXIT
               EVALUATE WS-INPUT-CHOICE
                   WHEN "1"
                       PERFORM 3000-LOGIN-ROUTINE
                   WHEN "2"
                       PERFORM 4000-CREATE-ACCOUNT-ROUTINE
                   WHEN "3"
                       SET WS-USER-WANT-TO-EXIT TO TRUE
                   WHEN OTHER
                       MOVE WS-INVALID-CHOICE TO DISPLAY-MSG
                       PERFORM 8000-DISPLAY-ROUTINE
               END-EVALUATE
           END-IF.

       3000-LOGIN-ROUTINE.
           SET WS-LOGIN-FAILED TO TRUE
           PERFORM UNTIL WS-LOGIN-SUCCESSFUL
               MOVE WS-PROMPT-USERNAME TO DISPLAY-MSG
               PERFORM 8000-DISPLAY-ROUTINE
               READ INPUT-FILE INTO WS-INPUT-USERNAME
                   AT END SET WS-USER-WANT-TO-EXIT TO TRUE
                        EXIT PERFORM
               END-READ

               MOVE WS-INPUT-USERNAME TO WS-TEMP-FIELD
               PERFORM 1200-ENSURE-NOT-BLANK
               IF DISPLAY-MSG NOT = SPACES
                  PERFORM 8000-DISPLAY-ROUTINE
                  EXIT PERFORM
               END-IF

               MOVE WS-PROMPT-PASSWORD TO DISPLAY-MSG
               PERFORM 8000-DISPLAY-ROUTINE
               READ INPUT-FILE INTO WS-INPUT-PASSWORD
                   AT END SET WS-USER-WANT-TO-EXIT TO TRUE
                        EXIT PERFORM
               END-READ

               MOVE WS-INPUT-PASSWORD TO WS-TEMP-FIELD
               PERFORM 1200-ENSURE-NOT-BLANK
               IF DISPLAY-MSG NOT = SPACES
                  PERFORM 8000-DISPLAY-ROUTINE
                  EXIT PERFORM
               END-IF

               PERFORM VARYING IDX FROM 1 BY 1 UNTIL IDX > WS-USER-ACCOUNT-COUNT
                   IF FUNCTION TRIM(WS-USER-NAME(IDX)) = FUNCTION TRIM(WS-INPUT-USERNAME)
                   AND FUNCTION TRIM(WS-USER-PASSWORD(IDX)) = FUNCTION TRIM(WS-INPUT-PASSWORD)
                       SET WS-LOGIN-SUCCESSFUL TO TRUE
                       EXIT PERFORM
                   END-IF
               END-PERFORM

               IF WS-LOGIN-SUCCESSFUL
                   MOVE WS-SUCCESSFUL-LOGIN-MSG TO DISPLAY-MSG
                   PERFORM 8000-DISPLAY-ROUTINE

                   STRING "Welcome, " FUNCTION TRIM(WS-INPUT-USERNAME)
                          DELIMITED BY SIZE INTO DISPLAY-MSG
                   PERFORM 8000-DISPLAY-ROUTINE

                   MOVE WS-INPUT-USERNAME TO WS-CURRENT-USER

                   PERFORM 5000-POST-LOGIN-MENU
                   SET WS-USER-WANT-TO-EXIT TO TRUE
               ELSE
                   MOVE WS-INVALID-LOGIN-MSG TO DISPLAY-MSG
                   PERFORM 8000-DISPLAY-ROUTINE
                   EXIT PERFORM
               END-IF
           END-PERFORM.

       4000-CREATE-ACCOUNT-ROUTINE.
           IF WS-USER-ACCOUNT-COUNT >= 5
               MOVE WS-MAX-ACCOUNTS-MSG TO DISPLAY-MSG
               PERFORM 8000-DISPLAY-ROUTINE
               EXIT PARAGRAPH
           END-IF

           SET WS-ACCOUNT-NOT-CREATED TO TRUE

           MOVE WS-PROMPT-USERNAME TO DISPLAY-MSG
           PERFORM 8000-DISPLAY-ROUTINE
           READ INPUT-FILE INTO WS-INPUT-USERNAME
               AT END SET WS-USER-WANT-TO-EXIT TO TRUE
                    EXIT PARAGRAPH
           END-READ

           MOVE WS-INPUT-USERNAME TO WS-TEMP-FIELD
           PERFORM 1200-ENSURE-NOT-BLANK
           IF DISPLAY-MSG NOT = SPACES
              PERFORM 8000-DISPLAY-ROUTINE
              EXIT PARAGRAPH
           END-IF

           PERFORM VARYING IDX FROM 1 BY 1 UNTIL IDX > WS-USER-ACCOUNT-COUNT
               IF FUNCTION TRIM(WS-USER-NAME(IDX)) = FUNCTION TRIM(WS-INPUT-USERNAME)
                   MOVE WS-DUPLICATE-USERNAME-MSG TO DISPLAY-MSG
                   PERFORM 8000-DISPLAY-ROUTINE
                   EXIT PARAGRAPH
               END-IF
           END-PERFORM

           MOVE WS-PROMPT-PASSWORD TO DISPLAY-MSG
           PERFORM 8000-DISPLAY-ROUTINE
           READ INPUT-FILE INTO WS-INPUT-PASSWORD
               AT END SET WS-USER-WANT-TO-EXIT TO TRUE
                    EXIT PARAGRAPH
           END-READ

           MOVE WS-INPUT-PASSWORD TO WS-TEMP-FIELD
           PERFORM 1200-ENSURE-NOT-BLANK
           IF DISPLAY-MSG NOT = SPACES
              PERFORM 8000-DISPLAY-ROUTINE
              EXIT PARAGRAPH
           END-IF

           PERFORM 4100-VALIDATE-PASSWORD

           IF WS-PASSWORD-IS-VALID
               ADD 1 TO WS-USER-ACCOUNT-COUNT
               MOVE WS-INPUT-USERNAME TO WS-USER-NAME(WS-USER-ACCOUNT-COUNT)
               MOVE WS-INPUT-PASSWORD TO WS-USER-PASSWORD(WS-USER-ACCOUNT-COUNT)

               CLOSE USER-ACCOUNT-FILE
               OPEN EXTEND USER-ACCOUNT-FILE

               IF WS-USER-FILE-STATUS = "00" OR WS-USER-FILE-STATUS = "05"
                   MOVE WS-USER(WS-USER-ACCOUNT-COUNT) TO USER-ACCOUNT-REC
                   WRITE USER-ACCOUNT-REC
               ELSE
                   DISPLAY "SOMETHING WRONG WITH WRITING RECORDS " WS-USER-FILE-STATUS
                   STOP RUN
               END-IF

               CLOSE USER-ACCOUNT-FILE
               OPEN I-O USER-ACCOUNT-FILE

               MOVE "Account created successfully!" TO DISPLAY-MSG
               PERFORM 8000-DISPLAY-ROUTINE
               SET WS-ACCOUNT-CREATED TO TRUE
               *> Immediately show the main menu again after creation
               SET WS-SKIP-MENU-FALSE TO TRUE
               PERFORM 2000-SHOW-MENU
           ELSE
               MOVE "Account creation failed, please try again." TO DISPLAY-MSG
               PERFORM 8000-DISPLAY-ROUTINE
           END-IF.

       4100-VALIDATE-PASSWORD.
           SET WS-PASSWORD-IS-VALID TO TRUE
           COMPUTE WS-PASSWORD-LENGTH = FUNCTION LENGTH(FUNCTION TRIM(WS-INPUT-PASSWORD))

           IF WS-PASSWORD-LENGTH < 8
               MOVE WS-PASSWORD-TOO-SHORT TO DISPLAY-MSG
               PERFORM 8000-DISPLAY-ROUTINE
               SET WS-PASSWORD-IS-INVALID TO TRUE
               EXIT PARAGRAPH
           END-IF

           IF WS-PASSWORD-LENGTH > 12
               MOVE WS-PASSWORD-TOO-LONG TO DISPLAY-MSG
               PERFORM 8000-DISPLAY-ROUTINE
               SET WS-PASSWORD-IS-INVALID TO TRUE
               EXIT PARAGRAPH
           END-IF

           MOVE 'N' TO WS-HAS-CAPITAL WS-HAS-DIGIT WS-HAS-SPECIAL

           PERFORM VARYING IDX FROM 1 BY 1 UNTIL IDX > WS-PASSWORD-LENGTH
               MOVE WS-INPUT-PASSWORD(IDX:1) TO WS-CUR-CHAR

               IF WS-CUR-CHAR >= 'A' AND WS-CUR-CHAR <= 'Z'
                   MOVE 'Y' TO WS-HAS-CAPITAL
               END-IF

               IF WS-CUR-CHAR >= '0' AND WS-CUR-CHAR <= '9'
                   MOVE 'Y' TO WS-HAS-DIGIT
               END-IF

               IF WS-CUR-CHAR = "!" OR WS-CUR-CHAR = "@" OR WS-CUR-CHAR = "#" OR WS-CUR-CHAR = "$" OR WS-CUR-CHAR = "%" OR WS-CUR-CHAR = "^" OR WS-CUR-CHAR = "&" OR WS-CUR-CHAR = "*" OR WS-CUR-CHAR = "(" OR WS-CUR-CHAR = ")"
                   MOVE "Y" TO WS-HAS-SPECIAL
               END-IF
           END-PERFORM

           IF WS-HAS-CAPITAL = 'N'
               MOVE WS-PASSWORD-NO-CAPITAL TO DISPLAY-MSG
               PERFORM 8000-DISPLAY-ROUTINE
               SET WS-PASSWORD-IS-INVALID TO TRUE
           END-IF
           IF WS-HAS-DIGIT = 'N'
               MOVE WS-PASSWORD-NO-DIGIT TO DISPLAY-MSG
               PERFORM 8000-DISPLAY-ROUTINE
               SET WS-PASSWORD-IS-INVALID TO TRUE
           END-IF
           IF WS-HAS-SPECIAL = 'N'
               MOVE WS-PASSWORD-NO-SPECIAL TO DISPLAY-MSG
               PERFORM 8000-DISPLAY-ROUTINE
               SET WS-PASSWORD-IS-INVALID TO TRUE
           END-IF.

       5000-POST-LOGIN-MENU.
           PERFORM UNTIL WS-USER-WANT-TO-EXIT
               MOVE WS-PROFILE-MENU-VIEW TO DISPLAY-MSG
               PERFORM 8000-DISPLAY-ROUTINE
               MOVE WS-FIND-SOMEONE-MSG TO DISPLAY-MSG
               PERFORM 8000-DISPLAY-ROUTINE
               MOVE WS-LEARN-SKILL-MSG TO DISPLAY-MSG
               PERFORM 8000-DISPLAY-ROUTINE
               MOVE WS-VIEW-CONN-REQ-MSG TO DISPLAY-MSG
               PERFORM 8000-DISPLAY-ROUTINE
               MOVE WS-VIEW-NETWORK-MSG TO DISPLAY-MSG
               PERFORM 8000-DISPLAY-ROUTINE
               MOVE WS-PROFILE-MENU-EDIT TO DISPLAY-MSG
               PERFORM 8000-DISPLAY-ROUTINE
               MOVE WS-LOG-OUT-MSG TO DISPLAY-MSG
               PERFORM 8000-DISPLAY-ROUTINE
               MOVE WS-PROMPT-CHOICE TO DISPLAY-MSG
               PERFORM 8000-DISPLAY-ROUTINE

               READ INPUT-FILE INTO WS-INPUT-CHOICE
                   AT END SET WS-USER-WANT-TO-EXIT TO TRUE
                        EXIT PERFORM
               END-READ

               EVALUATE WS-INPUT-CHOICE
                   WHEN "1"
                       PERFORM 6000-VIEW-MY-PROFILE
                   WHEN "2"
                       PERFORM 6300-VIEW-PROFILE-BY-SEARCH
                   WHEN "3"
                       PERFORM 5100-LEARN-SKILL-SUBMENU
                   WHEN "4"
                       PERFORM 7000-VIEW-PENDING-CONNECTIONS
                   WHEN "5"
                       PERFORM 7500-VIEW-NETWORK
                   WHEN "6"
                       PERFORM 6100-CREATE-EDIT-PROFILE
                   WHEN "7"
                       PERFORM 2000-SHOW-MENU
                   WHEN OTHER
                       MOVE WS-INVALID-CHOICE TO DISPLAY-MSG
                       PERFORM 8000-DISPLAY-ROUTINE
               END-EVALUATE
           END-PERFORM.

       5100-LEARN-SKILL-SUBMENU.
           PERFORM WITH TEST AFTER UNTIL WS-USER-WANT-TO-EXIT
               MOVE WS-LEARN-SKILL-HEADER TO DISPLAY-MSG
               PERFORM 8000-DISPLAY-ROUTINE
               MOVE WS-SKILL-1 TO DISPLAY-MSG
               PERFORM 8000-DISPLAY-ROUTINE
               MOVE WS-SKILL-2 TO DISPLAY-MSG
               PERFORM 8000-DISPLAY-ROUTINE
               MOVE WS-SKILL-3 TO DISPLAY-MSG
               PERFORM 8000-DISPLAY-ROUTINE
               MOVE WS-SKILL-4 TO DISPLAY-MSG
               PERFORM 8000-DISPLAY-ROUTINE
               MOVE WS-SKILL-5 TO DISPLAY-MSG
               PERFORM 8000-DISPLAY-ROUTINE
               MOVE WS-GO-BACK TO DISPLAY-MSG
               PERFORM 8000-DISPLAY-ROUTINE
               MOVE WS-PROMPT-CHOICE TO DISPLAY-MSG
               PERFORM 8000-DISPLAY-ROUTINE

               READ INPUT-FILE INTO WS-INPUT-CHOICE
                   AT END SET WS-USER-WANT-TO-EXIT TO TRUE
                        EXIT PARAGRAPH
               END-READ

               EVALUATE WS-INPUT-CHOICE
                   WHEN "1" THRU "5"
                       MOVE WS-SKILL-UC-MSG TO DISPLAY-MSG
                       PERFORM 8000-DISPLAY-ROUTINE
                   WHEN "6"
                       EXIT PARAGRAPH
                   WHEN OTHER
                       MOVE WS-INVALID-CHOICE TO DISPLAY-MSG
                       PERFORM 8000-DISPLAY-ROUTINE
               END-EVALUATE
           END-PERFORM.

       1200-ENSURE-NOT-BLANK.
           IF FUNCTION LENGTH(FUNCTION TRIM(WS-TEMP-FIELD)) = 0
               MOVE WS-BLANK-INPUT-MSG TO DISPLAY-MSG
           ELSE
               MOVE SPACES TO DISPLAY-MSG
           END-IF.

       6000-VIEW-MY-PROFILE.
           INITIALIZE USER-PROFILE-REC
           SET WS-PROFILE-NOT-FOUND TO TRUE
           CLOSE USER-PROFILE-FILE
           OPEN INPUT USER-PROFILE-FILE

           SET WS-NOT-EOF-FLAG TO TRUE
           PERFORM UNTIL WS-EOF-FLAG
               READ USER-PROFILE-FILE
                   AT END
                       SET WS-EOF-FLAG TO TRUE
                   NOT AT END
                       IF FUNCTION TRIM(UP-USER-NAME) = FUNCTION TRIM(WS-CURRENT-USER)
                           SET WS-PROFILE-FOUND TO TRUE
                           EXIT PERFORM
                       END-IF
               END-READ
           END-PERFORM

           CLOSE USER-PROFILE-FILE
           OPEN I-O USER-PROFILE-FILE

           IF WS-PROFILE-FOUND
               MOVE "--- Your Profile ---" TO DISPLAY-MSG
               PERFORM 8000-DISPLAY-ROUTINE

               STRING "Name: " FUNCTION TRIM(UP-FIRST-NAME OF USER-PROFILE-REC) " " FUNCTION TRIM(UP-LAST-NAME OF USER-PROFILE-REC)
                      DELIMITED BY SIZE INTO DISPLAY-MSG
               PERFORM 8000-DISPLAY-ROUTINE

               STRING "University: " FUNCTION TRIM(UP-UNIVERSITY OF USER-PROFILE-REC) DELIMITED BY SIZE INTO DISPLAY-MSG
               PERFORM 8000-DISPLAY-ROUTINE

               STRING "Major: " FUNCTION TRIM(UP-MAJOR OF USER-PROFILE-REC) DELIMITED BY SIZE INTO DISPLAY-MSG
               PERFORM 8000-DISPLAY-ROUTINE

               STRING "Graduation Year: " UP-GRAD-YEAR OF USER-PROFILE-REC DELIMITED BY SIZE INTO DISPLAY-MSG
               PERFORM 8000-DISPLAY-ROUTINE

               STRING "About Me: " FUNCTION TRIM(UP-ABOUT-ME OF USER-PROFILE-REC) DELIMITED BY SIZE INTO DISPLAY-MSG
               PERFORM 8000-DISPLAY-ROUTINE

               IF UP-NUM-EXP OF USER-PROFILE-REC > 0
                   MOVE "Experience:" TO DISPLAY-MSG
                   PERFORM 8000-DISPLAY-ROUTINE
                   PERFORM VARYING I FROM 1 BY 1 UNTIL I > UP-NUM-EXP OF USER-PROFILE-REC
                       STRING "  Title: " FUNCTION TRIM(UP-EXP-TITLE OF USER-PROFILE-REC (I)) DELIMITED BY SIZE INTO DISPLAY-MSG
                       PERFORM 8000-DISPLAY-ROUTINE

                       STRING "  Company: " FUNCTION TRIM(UP-EXP-COMPANY OF USER-PROFILE-REC (I)) DELIMITED BY SIZE INTO DISPLAY-MSG
                       PERFORM 8000-DISPLAY-ROUTINE

                       STRING "  Dates: " FUNCTION TRIM(UP-EXP-DATE OF USER-PROFILE-REC (I)) DELIMITED BY SIZE INTO DISPLAY-MSG
                       PERFORM 8000-DISPLAY-ROUTINE

                       STRING "  Description: " FUNCTION TRIM(UP-EXP-DESC OF USER-PROFILE-REC (I)) DELIMITED BY SIZE INTO DISPLAY-MSG
                       PERFORM 8000-DISPLAY-ROUTINE
                   END-PERFORM
               END-IF

               IF UP-NUM-EDU OF USER-PROFILE-REC > 0
                   MOVE "Education:" TO DISPLAY-MSG
                   PERFORM 8000-DISPLAY-ROUTINE
                   PERFORM VARYING I FROM 1 BY 1 UNTIL I > UP-NUM-EDU OF USER-PROFILE-REC
                       STRING "  Degree: " FUNCTION TRIM(UP-EDU-DEGREE OF USER-PROFILE-REC (I)) DELIMITED BY SIZE INTO DISPLAY-MSG
                       PERFORM 8000-DISPLAY-ROUTINE

                       STRING "  University: " FUNCTION TRIM(UP-EDU-UNI OF USER-PROFILE-REC (I)) DELIMITED BY SIZE INTO DISPLAY-MSG
                       PERFORM 8000-DISPLAY-ROUTINE

                       STRING "  Years: " FUNCTION TRIM(UP-EDU-YEARS OF USER-PROFILE-REC (I)) DELIMITED BY SIZE INTO DISPLAY-MSG
                       PERFORM 8000-DISPLAY-ROUTINE
                   END-PERFORM
               END-IF
           ELSE
               MOVE WS-PROFILE-NOTFOUND-MSG TO DISPLAY-MSG
               PERFORM 8000-DISPLAY-ROUTINE
           END-IF.

       6100-CREATE-EDIT-PROFILE.
           MOVE WS-CREATE-EDIT-PROMPT TO DISPLAY-MSG
           PERFORM 8000-DISPLAY-ROUTINE

           PERFORM 6105-GET-REQUIRED-FIELDS
           IF WS-USER-WANT-TO-EXIT
               EXIT PARAGRAPH
           END-IF

           PERFORM 6200-VALIDATE-PROFILE-FIELDS

           PERFORM 6106-GET-ABOUT-ME
           IF WS-USER-WANT-TO-EXIT
               EXIT PARAGRAPH
           END-IF

           PERFORM 6110-GET-OPTIONAL-EXP
           IF WS-USER-WANT-TO-EXIT
               EXIT PARAGRAPH
           END-IF

           PERFORM 6111-GET-OPTIONAL-EDU
           IF WS-USER-WANT-TO-EXIT
               EXIT PARAGRAPH
           END-IF

           PERFORM 6140-TRANSFER-DATA-TO-RECORD
           PERFORM 6150-SAVE-OR-UPDATE-PROFILE.

       6105-GET-REQUIRED-FIELDS.
           MOVE WS-ENTER-FIRST TO DISPLAY-MSG
           PERFORM 6205-GET-VALID-REQUIRED-FIELDS
           IF WS-USER-WANT-TO-EXIT EXIT PARAGRAPH END-IF
           MOVE WS-TEMP-FIELD TO WS-FIRST-NAME

           MOVE WS-ENTER-LAST TO DISPLAY-MSG
           PERFORM 6205-GET-VALID-REQUIRED-FIELDS
           IF WS-USER-WANT-TO-EXIT EXIT PARAGRAPH END-IF
           MOVE WS-TEMP-FIELD TO WS-LAST-NAME

           MOVE WS-ENTER-UNIV TO DISPLAY-MSG
           PERFORM 6205-GET-VALID-REQUIRED-FIELDS
           IF WS-USER-WANT-TO-EXIT EXIT PARAGRAPH END-IF
           MOVE WS-TEMP-FIELD TO WS-UNIVERSITY

           MOVE WS-ENTER-MAJOR TO DISPLAY-MSG
           PERFORM 6205-GET-VALID-REQUIRED-FIELDS
           IF WS-USER-WANT-TO-EXIT EXIT PARAGRAPH END-IF
           MOVE WS-TEMP-FIELD TO WS-MAJOR

           PERFORM 6260-GET-VALID-YEAR.

       6106-GET-ABOUT-ME.
           SET WS-INVALID-FIELD TO TRUE
           PERFORM UNTIL WS-VALID-FIELD OR WS-USER-WANT-TO-EXIT
               MOVE WS-ENTER-ABOUT-ME TO DISPLAY-MSG
               PERFORM 8000-DISPLAY-ROUTINE

               MOVE SPACES TO WS-TEMP-ABOUT-ME-BUFFER
               READ INPUT-FILE INTO WS-TEMP-ABOUT-ME-BUFFER
                   AT END SET WS-USER-WANT-TO-EXIT TO TRUE EXIT PERFORM
               END-READ

               IF FUNCTION LENGTH(FUNCTION TRIM(WS-TEMP-ABOUT-ME-BUFFER)) > 200
                   MOVE "Input exceeds 200 characters. Please try again." TO DISPLAY-MSG
                   PERFORM 8000-DISPLAY-ROUTINE
               ELSE
                   MOVE FUNCTION TRIM(WS-TEMP-ABOUT-ME-BUFFER)(1:200) TO WS-ABOUT-ME
                   SET WS-VALID-FIELD TO TRUE
               END-IF
           END-PERFORM.

       6110-GET-OPTIONAL-EXP.
           MOVE 0 TO WS-NUM-EXP
           PERFORM VARYING J FROM 1 BY 1 UNTIL J > 3 OR WS-USER-WANT-TO-EXIT
               SET WS-USER-NOT-DONE TO TRUE
               MOVE 'N' TO WS-DONE-FLAG

               *> ---------------- TITLE ----------------
               MOVE SPACES TO WS-GENERIC-INPUT
               PERFORM UNTIL WS-USER-WANT-TO-EXIT
                          OR WS-USER-TYPED-DONE
                          OR FUNCTION LENGTH(FUNCTION TRIM(WS-GENERIC-INPUT)) > 0
                   STRING "Experience #" J WS-EXP-PROMPT-TITLE
                       DELIMITED BY SIZE INTO DISPLAY-MSG
                   PERFORM 8000-DISPLAY-ROUTINE

                   READ INPUT-FILE INTO WS-GENERIC-INPUT
                       AT END SET WS-USER-WANT-TO-EXIT TO TRUE EXIT PERFORM
                   END-READ

                   IF FUNCTION UPPER-CASE(FUNCTION TRIM(WS-GENERIC-INPUT)) = WS-DONE-LITERAL
                       SET WS-USER-TYPED-DONE TO TRUE
                   ELSE
                       IF FUNCTION LENGTH(FUNCTION TRIM(WS-GENERIC-INPUT)) = 0
                           MOVE WS-FIELD-BLANK-MSG TO DISPLAY-MSG
                           PERFORM 8000-DISPLAY-ROUTINE
                       END-IF
                   END-IF
               END-PERFORM
               IF WS-USER-TYPED-DONE OR WS-USER-WANT-TO-EXIT
                   EXIT PERFORM
               END-IF
               MOVE FUNCTION TRIM(WS-GENERIC-INPUT) TO WS-EXP-TITLE(J)

               *> ---------------- COMPANY ----------------
               MOVE 'N' TO WS-DONE-FLAG
               MOVE SPACES TO WS-GENERIC-INPUT
               PERFORM UNTIL WS-USER-WANT-TO-EXIT
                          OR WS-USER-TYPED-DONE
                          OR FUNCTION LENGTH(FUNCTION TRIM(WS-GENERIC-INPUT)) > 0
                   STRING "Experience #" J WS-EXP-PROMPT-COMPANY
                       DELIMITED BY SIZE INTO DISPLAY-MSG
                   PERFORM 8000-DISPLAY-ROUTINE

                   READ INPUT-FILE INTO WS-GENERIC-INPUT
                       AT END SET WS-USER-WANT-TO-EXIT TO TRUE EXIT PERFORM
                   END-READ

                   IF FUNCTION UPPER-CASE(FUNCTION TRIM(WS-GENERIC-INPUT)) = WS-DONE-LITERAL
                       SET WS-USER-TYPED-DONE TO TRUE
                   ELSE
                       IF FUNCTION LENGTH(FUNCTION TRIM(WS-GENERIC-INPUT)) = 0
                           MOVE WS-FIELD-BLANK-MSG TO DISPLAY-MSG
                           PERFORM 8000-DISPLAY-ROUTINE
                       END-IF
                   END-IF
               END-PERFORM
               IF WS-USER-TYPED-DONE OR WS-USER-WANT-TO-EXIT
                   EXIT PERFORM
               END-IF
               MOVE FUNCTION TRIM(WS-GENERIC-INPUT) TO WS-EXP-COMPANY(J)

               *> ---------------- DATES ----------------
               MOVE 'N' TO WS-DONE-FLAG
               MOVE SPACES TO WS-GENERIC-INPUT
               PERFORM UNTIL WS-USER-WANT-TO-EXIT
                          OR WS-USER-TYPED-DONE
                          OR FUNCTION LENGTH(FUNCTION TRIM(WS-GENERIC-INPUT)) > 0
                   STRING "Experience #" J WS-EXP-PROMPT-DATES
                       DELIMITED BY SIZE INTO DISPLAY-MSG
                   PERFORM 8000-DISPLAY-ROUTINE

                   READ INPUT-FILE INTO WS-GENERIC-INPUT
                       AT END SET WS-USER-WANT-TO-EXIT TO TRUE EXIT PERFORM
                   END-READ

                   IF FUNCTION UPPER-CASE(FUNCTION TRIM(WS-GENERIC-INPUT)) = WS-DONE-LITERAL
                       SET WS-USER-TYPED-DONE TO TRUE
                   ELSE
                       IF FUNCTION LENGTH(FUNCTION TRIM(WS-GENERIC-INPUT)) = 0
                           MOVE WS-FIELD-BLANK-MSG TO DISPLAY-MSG
                           PERFORM 8000-DISPLAY-ROUTINE
                       END-IF
                   END-IF
               END-PERFORM
               IF WS-USER-TYPED-DONE OR WS-USER-WANT-TO-EXIT
                   EXIT PERFORM
               END-IF
               MOVE FUNCTION TRIM(WS-GENERIC-INPUT) TO WS-EXP-DATES(J)

               *> ---------------- DESCRIPTION ----------------
               MOVE 'N' TO WS-DONE-FLAG
               MOVE SPACES TO WS-GENERIC-INPUT
               PERFORM UNTIL WS-USER-WANT-TO-EXIT
                          OR WS-USER-TYPED-DONE
                          OR FUNCTION LENGTH(FUNCTION TRIM(WS-GENERIC-INPUT)) > 0
                   STRING "Experience #" J WS-EXP-PROMPT-DESC
                       DELIMITED BY SIZE INTO DISPLAY-MSG
                   PERFORM 8000-DISPLAY-ROUTINE

                   READ INPUT-FILE INTO WS-GENERIC-INPUT
                       AT END SET WS-USER-WANT-TO-EXIT TO TRUE EXIT PERFORM
                   END-READ

                   IF FUNCTION UPPER-CASE(FUNCTION TRIM(WS-GENERIC-INPUT)) = WS-DONE-LITERAL
                       SET WS-USER-TYPED-DONE TO TRUE
                   ELSE
                       IF FUNCTION LENGTH(FUNCTION TRIM(WS-GENERIC-INPUT)) = 0
                           MOVE WS-FIELD-BLANK-MSG TO DISPLAY-MSG
                           PERFORM 8000-DISPLAY-ROUTINE
                       END-IF
                   END-IF
               END-PERFORM
               IF WS-USER-TYPED-DONE OR WS-USER-WANT-TO-EXIT
                   EXIT PERFORM
               END-IF
               MOVE FUNCTION TRIM(WS-GENERIC-INPUT) TO WS-EXP-DESCRIPTION(J)

               *> ---------------- COUNT ENTRY ----------------
               ADD 1 TO WS-NUM-EXP
           END-PERFORM.

       6111-GET-OPTIONAL-EDU.
           MOVE 0 TO WS-NUM-EDU
           PERFORM VARYING J FROM 1 BY 1 UNTIL J > 3 OR WS-USER-WANT-TO-EXIT
               SET WS-USER-NOT-DONE TO TRUE
               MOVE 'N' TO WS-DONE-FLAG

               *> ---------------- DEGREE ----------------
               MOVE SPACES TO WS-GENERIC-INPUT
               PERFORM UNTIL WS-USER-WANT-TO-EXIT
                          OR WS-USER-TYPED-DONE
                          OR FUNCTION LENGTH(FUNCTION TRIM(WS-GENERIC-INPUT)) > 0
                   STRING "Education #" J " - Degree (or type DONE to finish):"
                       DELIMITED BY SIZE INTO DISPLAY-MSG
                   PERFORM 8000-DISPLAY-ROUTINE

                   READ INPUT-FILE INTO WS-GENERIC-INPUT
                       AT END SET WS-USER-WANT-TO-EXIT TO TRUE EXIT PERFORM
                   END-READ

                   IF FUNCTION UPPER-CASE(FUNCTION TRIM(WS-GENERIC-INPUT)) = WS-DONE-LITERAL
                       SET WS-USER-TYPED-DONE TO TRUE
                   ELSE
                       IF FUNCTION LENGTH(FUNCTION TRIM(WS-GENERIC-INPUT)) = 0
                           MOVE WS-FIELD-BLANK-MSG TO DISPLAY-MSG
                           PERFORM 8000-DISPLAY-ROUTINE
                       END-IF
                   END-IF
               END-PERFORM
               IF WS-USER-TYPED-DONE OR WS-USER-WANT-TO-EXIT
                   EXIT PERFORM
               END-IF
               MOVE FUNCTION TRIM(WS-GENERIC-INPUT) TO WS-EDU-DEGREE(J)

               *> ---------------- UNIVERSITY ----------------
               MOVE 'N' TO WS-DONE-FLAG
               MOVE SPACES TO WS-GENERIC-INPUT
               PERFORM UNTIL WS-USER-WANT-TO-EXIT
                          OR WS-USER-TYPED-DONE
                          OR FUNCTION LENGTH(FUNCTION TRIM(WS-GENERIC-INPUT)) > 0
                   STRING "Education #" J " - University/College (or type DONE to finish):"
                       DELIMITED BY SIZE INTO DISPLAY-MSG
                   PERFORM 8000-DISPLAY-ROUTINE

                   READ INPUT-FILE INTO WS-GENERIC-INPUT
                       AT END SET WS-USER-WANT-TO-EXIT TO TRUE EXIT PERFORM
                   END-READ

                   IF FUNCTION UPPER-CASE(FUNCTION TRIM(WS-GENERIC-INPUT)) = WS-DONE-LITERAL
                       SET WS-USER-TYPED-DONE TO TRUE
                   ELSE
                       IF FUNCTION LENGTH(FUNCTION TRIM(WS-GENERIC-INPUT)) = 0
                           MOVE WS-FIELD-BLANK-MSG TO DISPLAY-MSG
                           PERFORM 8000-DISPLAY-ROUTINE
                       END-IF
                   END-IF
               END-PERFORM
               IF WS-USER-TYPED-DONE OR WS-USER-WANT-TO-EXIT
                   EXIT PERFORM
               END-IF
               MOVE FUNCTION TRIM(WS-GENERIC-INPUT) TO WS-EDU-UNIVERSITY(J)

               *> ---------------- YEARS ----------------
               MOVE 'N' TO WS-DONE-FLAG
               MOVE SPACES TO WS-GENERIC-INPUT
               PERFORM UNTIL WS-USER-WANT-TO-EXIT
                          OR WS-USER-TYPED-DONE
                          OR FUNCTION LENGTH(FUNCTION TRIM(WS-GENERIC-INPUT)) > 0
                   STRING "Education #" J " - Years Attended (e.g., 2023-2025, or type DONE to finish):"
                       DELIMITED BY SIZE INTO DISPLAY-MSG
                   PERFORM 8000-DISPLAY-ROUTINE

                   READ INPUT-FILE INTO WS-GENERIC-INPUT
                       AT END SET WS-USER-WANT-TO-EXIT TO TRUE EXIT PERFORM
                   END-READ

                   IF FUNCTION UPPER-CASE(FUNCTION TRIM(WS-GENERIC-INPUT)) = WS-DONE-LITERAL
                       SET WS-USER-TYPED-DONE TO TRUE
                   ELSE
                       IF FUNCTION LENGTH(FUNCTION TRIM(WS-GENERIC-INPUT)) = 0
                           MOVE WS-FIELD-BLANK-MSG TO DISPLAY-MSG
                           PERFORM 8000-DISPLAY-ROUTINE
                       END-IF
                   END-IF
               END-PERFORM
               IF WS-USER-TYPED-DONE OR WS-USER-WANT-TO-EXIT
                   EXIT PERFORM
               END-IF
               MOVE FUNCTION TRIM(WS-GENERIC-INPUT) TO WS-EDU-YEARS(J)

               *> ---------------- COUNT ENTRY ----------------
               ADD 1 TO WS-NUM-EDU
           END-PERFORM.


       6140-TRANSFER-DATA-TO-RECORD.
           MOVE WS-FIRST-NAME      TO UP-FIRST-NAME OF WS-USER-PROFILE-REC
           MOVE WS-LAST-NAME       TO UP-LAST-NAME OF WS-USER-PROFILE-REC
           MOVE WS-UNIVERSITY      TO UP-UNIVERSITY OF WS-USER-PROFILE-REC
           MOVE WS-MAJOR           TO UP-MAJOR OF WS-USER-PROFILE-REC
           MOVE WS-GRAD-YEAR       TO UP-GRAD-YEAR OF WS-USER-PROFILE-REC
           MOVE WS-ABOUT-ME        TO UP-ABOUT-ME OF WS-USER-PROFILE-REC
           MOVE WS-NUM-EXP         TO UP-NUM-EXP OF WS-USER-PROFILE-REC
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > WS-NUM-EXP
               MOVE WS-EXP-TITLE(I)       TO UP-EXP-TITLE       OF WS-USER-PROFILE-REC (I)
               MOVE WS-EXP-COMPANY(I)     TO UP-EXP-COMPANY     OF WS-USER-PROFILE-REC (I)
               MOVE WS-EXP-DATES(I)       TO UP-EXP-DATES       OF WS-USER-PROFILE-REC (I)
               MOVE WS-EXP-DESCRIPTION(I) TO UP-EXP-DESCRIPTION OF WS-USER-PROFILE-REC (I)
           END-PERFORM
           MOVE WS-NUM-EDU         TO UP-NUM-EDU OF WS-USER-PROFILE-REC
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > WS-NUM-EDU
               MOVE WS-EDU-DEGREE(I)     TO UP-EDU-DEGREE     OF WS-USER-PROFILE-REC (I)
               MOVE WS-EDU-UNIVERSITY(I) TO UP-EDU-UNIVERSITY OF WS-USER-PROFILE-REC (I)
               MOVE WS-EDU-YEARS(I)      TO UP-EDU-YEARS      OF WS-USER-PROFILE-REC (I)
           END-PERFORM
           CONTINUE.

       6150-SAVE-OR-UPDATE-PROFILE.
           MOVE WS-CURRENT-USER TO UP-PROFILE-USERNAME OF WS-USER-PROFILE-REC
           SET WS-PROFILE-NOT-FOUND TO TRUE

           OPEN INPUT  USER-PROFILE-FILE
           OPEN OUTPUT TEMP-PROFILE-FILE

           SET WS-NOT-EOF-FLAG TO TRUE
           PERFORM UNTIL WS-EOF-FLAG
               READ USER-PROFILE-FILE
                   AT END
                       SET WS-EOF-FLAG TO TRUE
                   NOT AT END
                       IF FUNCTION TRIM(UP-USER-NAME) = FUNCTION TRIM(WS-CURRENT-USER)
                           WRITE TEMP-PROFILE-REC FROM WS-USER-PROFILE-REC
                           SET WS-PROFILE-FOUND TO TRUE
                       ELSE
                           WRITE TEMP-PROFILE-REC FROM USER-PROFILE-REC
                       END-IF
               END-READ
           END-PERFORM

           IF WS-PROFILE-NOT-FOUND
               WRITE TEMP-PROFILE-REC FROM WS-USER-PROFILE-REC
           END-IF

           CLOSE USER-PROFILE-FILE
           CLOSE TEMP-PROFILE-FILE

           OPEN INPUT  TEMP-PROFILE-FILE
           OPEN OUTPUT USER-PROFILE-FILE
           MOVE 'N' TO WS-END-OF-FILE
           PERFORM UNTIL WS-EOF-FLAG
               READ TEMP-PROFILE-FILE INTO USER-PROFILE-REC
                   AT END
                       SET WS-EOF-FLAG TO TRUE
                   NOT AT END
                       WRITE USER-PROFILE-REC
               END-READ
           END-PERFORM

           CLOSE TEMP-PROFILE-FILE
           CLOSE USER-PROFILE-FILE

           OPEN I-O USER-PROFILE-FILE
           MOVE WS-SUCCESSFUL-PROFILE-SAVE TO DISPLAY-MSG
           PERFORM 8000-DISPLAY-ROUTINE.

       6200-VALIDATE-PROFILE-FIELDS.
           MOVE WS-FIRST-NAME TO WS-TEMP-FIELD
           PERFORM 6210-ALPHA-ONLY
           IF DISPLAY-MSG NOT = SPACES
               MOVE WS-NAME-INVALID-MSG TO DISPLAY-MSG
               EXIT PARAGRAPH
           END-IF

           MOVE WS-LAST-NAME TO WS-TEMP-FIELD
           PERFORM 6210-ALPHA-ONLY
           IF DISPLAY-MSG NOT = SPACES
               MOVE WS-NAME-INVALID-MSG TO DISPLAY-MSG
               EXIT PARAGRAPH
           END-IF

           MOVE SPACES TO DISPLAY-MSG.

       6205-GET-VALID-REQUIRED-FIELDS.
           MOVE SPACES TO WS-TEMP-FIELD
           PERFORM UNTIL FUNCTION LENGTH(FUNCTION TRIM(WS-TEMP-FIELD)) > 0
               PERFORM 8000-DISPLAY-ROUTINE
               READ INPUT-FILE INTO WS-TEMP-FIELD
                   AT END SET WS-USER-WANT-TO-EXIT TO TRUE EXIT PERFORM
               END-READ
               IF FUNCTION LENGTH(FUNCTION TRIM(WS-TEMP-FIELD)) = 0
                   MOVE WS-BLANK-INPUT-MSG TO DISPLAY-MSG
                   PERFORM 8000-DISPLAY-ROUTINE
                   MOVE WS-ENTER-FIRST TO DISPLAY-MSG
               END-IF
           END-PERFORM.

       6210-ALPHA-ONLY.
           MOVE SPACES TO DISPLAY-MSG
           COMPUTE I = 1
           PERFORM UNTIL I > FUNCTION LENGTH(FUNCTION TRIM(WS-TEMP-FIELD))
               MOVE WS-TEMP-FIELD(I:1) TO WS-CUR-CHAR
               IF (WS-CUR-CHAR < 'A' OR WS-CUR-CHAR > 'Z') AND (WS-CUR-CHAR < 'a' OR WS-CUR-CHAR > 'z')
                   MOVE 'X' TO DISPLAY-MSG(1:1)
                   EXIT PERFORM
               END-IF
               ADD 1 TO I
           END-PERFORM
           IF DISPLAY-MSG(1:1) = 'X'
               MOVE 'INVALID' TO DISPLAY-MSG
           ELSE
               MOVE SPACES TO DISPLAY-MSG
           END-IF.

       6260-GET-VALID-YEAR.
           SET WS-INVALID-FIELD TO TRUE
           PERFORM UNTIL WS-VALID-FIELD
               MOVE WS-ENTER-GY TO DISPLAY-MSG
               PERFORM 8000-DISPLAY-ROUTINE

               READ INPUT-FILE INTO WS-TEMP-FIELD
                   AT END
                       SET WS-USER-WANT-TO-EXIT TO TRUE
                       EXIT PERFORM
               END-READ

               IF NOT WS-USER-WANT-TO-EXIT
                   IF FUNCTION TRIM(WS-TEMP-FIELD) IS NUMERIC
                       MOVE FUNCTION NUMVAL(FUNCTION TRIM(WS-TEMP-FIELD)) TO WS-VALIDATED-YEAR
                       IF WS-VALIDATED-YEAR >= 1900 AND WS-VALIDATED-YEAR <= 2100
                           MOVE WS-VALIDATED-YEAR TO WS-GRAD-YEAR
                           SET WS-VALID-FIELD TO TRUE
                       ELSE
                           MOVE WS-GRAD-YEAR-INVALID TO DISPLAY-MSG
                           PERFORM 8000-DISPLAY-ROUTINE
                       END-IF
                   ELSE
                       MOVE "Year must be a 4-digit number." TO DISPLAY-MSG
                       PERFORM 8000-DISPLAY-ROUTINE
                   END-IF
               END-IF
           END-PERFORM.

       6300-VIEW-PROFILE-BY-SEARCH.
           MOVE "Enter Full name of user to search for their account." TO DISPLAY-MSG
           PERFORM 8000-DISPLAY-ROUTINE
           
           *> Get first name with validation
           SET WS-INVALID-FIELD TO TRUE
           PERFORM UNTIL WS-VALID-FIELD
               MOVE "Enter First name to search:" TO DISPLAY-MSG
               PERFORM 8000-DISPLAY-ROUTINE
               
               READ INPUT-FILE INTO WS-SEARCH-FIRST-NAME
                   AT END 
                       SET WS-USER-WANT-TO-EXIT TO TRUE
                       EXIT PERFORM
               END-READ
               
               MOVE FUNCTION TRIM(WS-SEARCH-FIRST-NAME) TO WS-SEARCH-FIRST-NAME
               
               IF FUNCTION LENGTH(FUNCTION TRIM(WS-SEARCH-FIRST-NAME)) = 0
                   MOVE "First name cannot be blank. Please try again." TO DISPLAY-MSG
                   PERFORM 8000-DISPLAY-ROUTINE
               ELSE
                   SET WS-VALID-FIELD TO TRUE
               END-IF
           END-PERFORM
           
           SET WS-INVALID-FIELD TO TRUE
           
           *> Get last name with validation
           IF NOT WS-USER-WANT-TO-EXIT
               PERFORM UNTIL WS-VALID-FIELD
                   MOVE "Enter last name to search:" TO DISPLAY-MSG
                   PERFORM 8000-DISPLAY-ROUTINE
                   
                   READ INPUT-FILE INTO WS-SEARCH-LAST-NAME
                       AT END 
                           SET WS-USER-WANT-TO-EXIT TO TRUE
                           EXIT PERFORM
                   END-READ
                   
                   MOVE FUNCTION TRIM(WS-SEARCH-LAST-NAME) TO WS-SEARCH-LAST-NAME
                   
                   IF FUNCTION LENGTH(FUNCTION TRIM(WS-SEARCH-LAST-NAME)) = 0
                       MOVE "Last name cannot be blank. Please try again." TO DISPLAY-MSG
                       PERFORM 8000-DISPLAY-ROUTINE
                   ELSE
                       SET WS-VALID-FIELD TO TRUE
                   END-IF
               END-PERFORM
           END-IF

           SET WS-NOT-EOF-FLAG TO TRUE
           SET WS-PROFILE-NOT-FOUND TO TRUE

           IF NOT WS-USER-WANT-TO-EXIT
               CLOSE USER-PROFILE-FILE
               OPEN INPUT USER-PROFILE-FILE
           END-IF

           PERFORM UNTIL WS-EOF-FLAG OR WS-PROFILE-FOUND
               READ USER-PROFILE-FILE
                   AT END
                       SET WS-EOF-FLAG TO TRUE
                   NOT AT END
                       IF FUNCTION TRIM(UP-FIRST-NAME OF USER-PROFILE-REC) = FUNCTION TRIM(WS-SEARCH-FIRST-NAME)
                       AND FUNCTION TRIM(UP-LAST-NAME OF USER-PROFILE-REC)  = FUNCTION TRIM(WS-SEARCH-LAST-NAME)
                           SET WS-PROFILE-FOUND TO TRUE
                           EXIT PERFORM
                       END-IF
               END-READ
           END-PERFORM

           CLOSE USER-PROFILE-FILE
           OPEN I-O USER-PROFILE-FILE

           IF WS-PROFILE-FOUND
               MOVE WS-FOUND-PROFILE-HEADER TO DISPLAY-MSG
               PERFORM 8000-DISPLAY-ROUTINE

               STRING FUNCTION TRIM(UP-FIRST-NAME OF USER-PROFILE-REC) " " FUNCTION TRIM(UP-LAST-NAME OF USER-PROFILE-REC)
                      DELIMITED BY SIZE INTO WS-TARGET-USER-NAME

               STRING "Name: " WS-TARGET-USER-NAME DELIMITED BY SIZE INTO DISPLAY-MSG
               PERFORM 8000-DISPLAY-ROUTINE

               STRING "University: " FUNCTION TRIM(UP-UNIVERSITY OF USER-PROFILE-REC) DELIMITED BY SIZE INTO DISPLAY-MSG
               PERFORM 8000-DISPLAY-ROUTINE

               STRING "Major: " FUNCTION TRIM(UP-MAJOR OF USER-PROFILE-REC) DELIMITED BY SIZE INTO DISPLAY-MSG
               PERFORM 8000-DISPLAY-ROUTINE

               STRING "Graduation Year: " UP-GRAD-YEAR OF USER-PROFILE-REC DELIMITED BY SIZE INTO DISPLAY-MSG
               PERFORM 8000-DISPLAY-ROUTINE

               MOVE WS-FOUND-PROFILE-FOOTER TO DISPLAY-MSG
               PERFORM 8000-DISPLAY-ROUTINE

               *> Show connection request options only if not searching for self
               IF FUNCTION TRIM(UP-USER-NAME OF USER-PROFILE-REC) NOT = FUNCTION TRIM(WS-CURRENT-USER)
                   PERFORM 7100-SHOW-CONNECTION-OPTIONS
               END-IF
           ELSE
               MOVE WS-PROFILE-NOTFOUND-MSG TO DISPLAY-MSG
               PERFORM 8000-DISPLAY-ROUTINE
           END-IF.

       7000-VIEW-PENDING-CONNECTIONS.
           MOVE WS-CONN-HEADER TO DISPLAY-MSG
           PERFORM 8000-DISPLAY-ROUTINE

           SET WS-NOT-EOF-FLAG TO TRUE
           SET WS-PROFILE-NOT-FOUND TO TRUE

           OPEN INPUT CONNECTIONS-FILE

           PERFORM UNTIL WS-EOF-FLAG
               READ CONNECTIONS-FILE
                   AT END
                       SET WS-EOF-FLAG TO TRUE
                   NOT AT END
                       IF FUNCTION TRIM(CONN-TO-USER) = FUNCTION TRIM(WS-CURRENT-USER)
                       AND FUNCTION TRIM(CONN-STATUS) = "PENDING"
                           SET WS-PROFILE-FOUND TO TRUE
                           MOVE SPACES TO DISPLAY-MSG
                           STRING "Request from: " FUNCTION TRIM(CONN-FROM-USER) DELIMITED BY SIZE INTO DISPLAY-MSG
                           PERFORM 8000-DISPLAY-ROUTINE
                           
                           SET WS-INVALID-FIELD TO TRUE
                           
                           PERFORM UNTIL WS-VALID-FIELD
                               MOVE WS-ACCEPT-CONN-MSG TO DISPLAY-MSG
                               PERFORM 8000-DISPLAY-ROUTINE
                               MOVE WS-REJECT-CONN-MSG TO DISPLAY-MSG
                               PERFORM 8000-DISPLAY-ROUTINE
                               MOVE WS-PROMPT-CHOICE TO DISPLAY-MSG
                               PERFORM 8000-DISPLAY-ROUTINE

                               READ INPUT-FILE INTO WS-INPUT-CHOICE
                                   AT END 
                                       SET WS-USER-WANT-TO-EXIT TO TRUE
                                       EXIT PERFORM
                               END-READ

                               EVALUATE WS-INPUT-CHOICE
                                   WHEN "1"
                                       SET WS-VALID-FIELD TO TRUE
                                   WHEN "2"
                                       SET WS-VALID-FIELD TO TRUE
                                   WHEN OTHER
                                       MOVE WS-INVALID-CHOICE TO DISPLAY-MSG
                                       PERFORM 8000-DISPLAY-ROUTINE
                               END-EVALUATE
                           END-PERFORM

                           *> Close file before modifying it
                           CLOSE CONNECTIONS-FILE

                           *> Process the valid choice
                           IF WS-INPUT-CHOICE = "1"
                               PERFORM 7400-ACCEPT-CONNECTION
                           ELSE
                               IF WS-INPUT-CHOICE = "2"
                                   PERFORM 7450-REJECT-CONNECTION
                               END-IF
                           END-IF
                           
                           *> Exit loop after handling first pending request
                           SET WS-EOF-FLAG TO TRUE
                       END-IF
               END-READ
           END-PERFORM

           IF NOT WS-EOF-FLAG
               CLOSE CONNECTIONS-FILE
           END-IF

           IF WS-PROFILE-NOT-FOUND
               MOVE WS-NO-CONN-MSG TO DISPLAY-MSG
               PERFORM 8000-DISPLAY-ROUTINE
           END-IF

           MOVE WS-CONN-FOOTER TO DISPLAY-MSG
           PERFORM 8000-DISPLAY-ROUTINE.

       7100-SHOW-CONNECTION-OPTIONS.
           SET WS-INVALID-FIELD TO TRUE
           
           PERFORM UNTIL WS-VALID-FIELD
               MOVE WS-SEND-CONN-REQ-MSG TO DISPLAY-MSG
               PERFORM 8000-DISPLAY-ROUTINE
               MOVE WS-BACK-TO-MENU-MSG TO DISPLAY-MSG
               PERFORM 8000-DISPLAY-ROUTINE
               MOVE WS-PROMPT-CHOICE TO DISPLAY-MSG
               PERFORM 8000-DISPLAY-ROUTINE

               READ INPUT-FILE INTO WS-INPUT-CHOICE
                   AT END 
                       SET WS-USER-WANT-TO-EXIT TO TRUE
                       EXIT PERFORM
               END-READ

               EVALUATE WS-INPUT-CHOICE
                   WHEN "1"
                       PERFORM 7200-SEND-CONNECTION-REQUEST
                       SET WS-VALID-FIELD TO TRUE
                   WHEN "2"
                       SET WS-VALID-FIELD TO TRUE
                   WHEN OTHER
                       MOVE WS-INVALID-CHOICE TO DISPLAY-MSG
                       PERFORM 8000-DISPLAY-ROUTINE
               END-EVALUATE
           END-PERFORM.

       7200-SEND-CONNECTION-REQUEST.
           PERFORM 7300-CHECK-CONNECTION-STATUS

           IF WS-CONN-EXISTS
               CONTINUE
           ELSE
               *> Create on demand if missing
               OPEN I-O CONNECTIONS-FILE
               IF WS-CONNECTIONS-FILE-STATUS NOT = "00"
                   OPEN OUTPUT CONNECTIONS-FILE
                   CLOSE CONNECTIONS-FILE
                   OPEN EXTEND CONNECTIONS-FILE
               ELSE
                   CLOSE CONNECTIONS-FILE
                   OPEN EXTEND CONNECTIONS-FILE
               END-IF
               MOVE WS-CURRENT-USER TO CONN-FROM-USER
               MOVE FUNCTION TRIM(UP-USER-NAME OF USER-PROFILE-REC) TO CONN-TO-USER
               MOVE "PENDING" TO CONN-STATUS
               WRITE CONNECTION-REC
               CLOSE CONNECTIONS-FILE

               MOVE SPACES TO WS-TEMP-FIELD
               STRING FUNCTION TRIM(WS-CONN-SENT-MSG) " " FUNCTION TRIM(WS-TARGET-USER-NAME) "."
                      DELIMITED BY SIZE INTO WS-TEMP-FIELD
               MOVE FUNCTION TRIM(WS-TEMP-FIELD) TO DISPLAY-MSG
               PERFORM 8000-DISPLAY-ROUTINE
           END-IF.

       7300-CHECK-CONNECTION-STATUS.
           SET WS-CONN-NOT-EXISTS TO TRUE
           SET WS-NOT-EOF-FLAG TO TRUE

           OPEN INPUT CONNECTIONS-FILE

           PERFORM UNTIL WS-EOF-FLAG
               READ CONNECTIONS-FILE
                   AT END
                       SET WS-EOF-FLAG TO TRUE
                   NOT AT END
                       *> Check if already connected (status is ACCEPTED)
                       IF (FUNCTION TRIM(CONN-FROM-USER) = FUNCTION TRIM(WS-CURRENT-USER)
                       AND FUNCTION TRIM(CONN-TO-USER) = FUNCTION TRIM(UP-USER-NAME OF USER-PROFILE-REC)
                       AND FUNCTION TRIM(CONN-STATUS) = "ACCEPTED")
                       OR (FUNCTION TRIM(CONN-TO-USER) = FUNCTION TRIM(WS-CURRENT-USER)
                       AND FUNCTION TRIM(CONN-FROM-USER) = FUNCTION TRIM(UP-USER-NAME OF USER-PROFILE-REC)
                       AND FUNCTION TRIM(CONN-STATUS) = "ACCEPTED")
                           SET WS-CONN-EXISTS TO TRUE
                           MOVE WS-ALREADY-CONNECTED-MSG TO DISPLAY-MSG
                           PERFORM 8000-DISPLAY-ROUTINE
                           EXIT PERFORM
                       END-IF

                       *> Check if they already sent us a request  
                       IF FUNCTION TRIM(CONN-FROM-USER) = FUNCTION TRIM(UP-USER-NAME OF USER-PROFILE-REC)
                       AND FUNCTION TRIM(CONN-TO-USER) = FUNCTION TRIM(WS-CURRENT-USER)
                       AND FUNCTION TRIM(CONN-STATUS) = "PENDING"
                           SET WS-CONN-EXISTS TO TRUE
                           MOVE WS-PENDING-FROM-THEM-MSG TO DISPLAY-MSG
                           PERFORM 8000-DISPLAY-ROUTINE
                           EXIT PERFORM
                       END-IF

                       *> Check if we already sent them a request
                       IF FUNCTION TRIM(CONN-FROM-USER) = FUNCTION TRIM(WS-CURRENT-USER)
                       AND FUNCTION TRIM(CONN-TO-USER) = FUNCTION TRIM(UP-USER-NAME OF USER-PROFILE-REC)
                       AND FUNCTION TRIM(CONN-STATUS) = "PENDING"
                           SET WS-CONN-EXISTS TO TRUE
                           MOVE WS-ALREADY-CONNECTED-MSG TO DISPLAY-MSG
                           PERFORM 8000-DISPLAY-ROUTINE
                           EXIT PERFORM
                       END-IF
               END-READ
           END-PERFORM

           CLOSE CONNECTIONS-FILE.

       7400-ACCEPT-CONNECTION.
           *> Add to established connections (both directions)
           OPEN EXTEND ESTABLISHED-CONNECTIONS-FILE
           MOVE FUNCTION TRIM(WS-CURRENT-USER) TO EST-CONN-USER1
           MOVE FUNCTION TRIM(CONN-FROM-USER) TO EST-CONN-USER2
           WRITE ESTABLISHED-CONNECTION-REC
           MOVE FUNCTION TRIM(CONN-FROM-USER) TO EST-CONN-USER1
           MOVE FUNCTION TRIM(WS-CURRENT-USER) TO EST-CONN-USER2
           WRITE ESTABLISHED-CONNECTION-REC
           CLOSE ESTABLISHED-CONNECTIONS-FILE
           
           *> Remove from pending connections
           PERFORM 7600-REMOVE-PENDING-CONNECTION
           
           MOVE WS-CONN-ACCEPTED-MSG TO DISPLAY-MSG
           PERFORM 8000-DISPLAY-ROUTINE.

       7450-REJECT-CONNECTION.
           *> Remove from pending connections
           PERFORM 7600-REMOVE-PENDING-CONNECTION
           
           MOVE WS-CONN-REJECTED-MSG TO DISPLAY-MSG
           PERFORM 8000-DISPLAY-ROUTINE.

       7500-VIEW-NETWORK.
           MOVE WS-NETWORK-HEADER TO DISPLAY-MSG
           PERFORM 8000-DISPLAY-ROUTINE

           SET WS-NOT-EOF-FLAG TO TRUE
           SET WS-PROFILE-NOT-FOUND TO TRUE

           OPEN INPUT ESTABLISHED-CONNECTIONS-FILE

           PERFORM UNTIL WS-EOF-FLAG
               READ ESTABLISHED-CONNECTIONS-FILE
                   AT END
                       SET WS-EOF-FLAG TO TRUE
                   NOT AT END
                       IF FUNCTION TRIM(EST-CONN-USER1) = FUNCTION TRIM(WS-CURRENT-USER)
                           SET WS-PROFILE-FOUND TO TRUE
                           MOVE SPACES TO DISPLAY-MSG
                           STRING WS-CONNECTED-WITH-MSG FUNCTION TRIM(EST-CONN-USER2) DELIMITED BY SIZE INTO DISPLAY-MSG
                           PERFORM 8000-DISPLAY-ROUTINE
                       END-IF
               END-READ
           END-PERFORM

           CLOSE ESTABLISHED-CONNECTIONS-FILE

           IF WS-PROFILE-NOT-FOUND
               MOVE WS-NO-NETWORK-MSG TO DISPLAY-MSG
               PERFORM 8000-DISPLAY-ROUTINE
           END-IF

           MOVE WS-NETWORK-FOOTER TO DISPLAY-MSG
           PERFORM 8000-DISPLAY-ROUTINE.

       7600-REMOVE-PENDING-CONNECTION.
           *> Remove the pending connection by rewriting file without it
           *> CONNECTION-REC already contains the record to remove
           OPEN INPUT CONNECTIONS-FILE
           OPEN OUTPUT TEMP-PROFILE-FILE
           
           SET WS-NOT-EOF-FLAG TO TRUE
           PERFORM UNTIL WS-EOF-FLAG
               READ CONNECTIONS-FILE INTO WS-TEMP-CONNECTION-REC
                   AT END
                       SET WS-EOF-FLAG TO TRUE
                   NOT AT END
                       *> Only write records that don't match the one to remove
                       *> We compare against the CONNECTION-REC that was read earlier
                       IF NOT (WS-TEMP-CONNECTION-REC(1:100) = CONN-FROM-USER
                       AND WS-TEMP-CONNECTION-REC(101:100) = CONN-TO-USER)
                           WRITE TEMP-PROFILE-REC FROM WS-TEMP-CONNECTION-REC
                       END-IF
               END-READ
           END-PERFORM
           
           CLOSE CONNECTIONS-FILE
           CLOSE TEMP-PROFILE-FILE
           
           *> Copy temp file back to connections file
           OPEN INPUT TEMP-PROFILE-FILE
           OPEN OUTPUT CONNECTIONS-FILE
           
           SET WS-NOT-EOF-FLAG TO TRUE
           PERFORM UNTIL WS-EOF-FLAG
               READ TEMP-PROFILE-FILE
                   AT END
                       SET WS-EOF-FLAG TO TRUE
                   NOT AT END
                       WRITE CONNECTION-REC FROM TEMP-PROFILE-REC
               END-READ
           END-PERFORM
           
           CLOSE TEMP-PROFILE-FILE
           CLOSE CONNECTIONS-FILE.

       8000-DISPLAY-ROUTINE.
           DISPLAY DISPLAY-MSG
           MOVE DISPLAY-MSG TO OUTPUT-RECORD
           INSPECT OUTPUT-RECORD REPLACING ALL LOW-VALUE BY SPACE
           WRITE OUTPUT-RECORD AFTER ADVANCING 1
           MOVE SPACES TO DISPLAY-MSG.

       9000-TERMINATE-PROGRAM.
           CLOSE INPUT-FILE
           CLOSE OUTPUT-FILE
           CLOSE USER-ACCOUNT-FILE
           CLOSE USER-PROFILE-FILE
           EXIT.
