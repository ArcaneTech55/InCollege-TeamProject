>>SOURCE FORMAT FREE
IDENTIFICATION DIVISION.
PROGRAM-ID. SETUP-INCOLLEGE-DB.

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
    SELECT USER-ACCOUNT-FILE ASSIGN TO "data/USER-ACCOUNT.DAT"
        ORGANIZATION IS SEQUENTIAL.
    SELECT USER-PROFILE-FILE ASSIGN TO "data/USER-PROFILE.DAT"
        ORGANIZATION IS SEQUENTIAL.
    SELECT JOB-POSTINGS-FILE ASSIGN TO "data/JOB-POSTINGS.DAT"
        ORGANIZATION IS SEQUENTIAL.
    SELECT JOB-APPLICATIONS-FILE ASSIGN TO "data/JOB-APPLICATIONS.DAT"
        ORGANIZATION IS SEQUENTIAL.

    SELECT ESTABLISHED-CONNECTIONS-FILE ASSIGN TO "data/ESTABLISHED-CONNECTIONS.DAT"
        ORGANIZATION IS SEQUENTIAL.

    SELECT MESSAGES-FILE ASSIGN TO "data/MESSAGES.DAT"
        ORGANIZATION IS SEQUENTIAL.
DATA DIVISION.
FILE SECTION.
FD USER-ACCOUNT-FILE.
01 USER-ACCOUNT-REC.
    05 USER-NAME     PIC X(100).
    05 USER-PASSWORD PIC X(100).

FD MESSAGES-FILE.
01 MESSAGE-REC.
    05 MSG-FROM-USER      PIC X(100).
    05 MSG-TO-USER        PIC X(100).
    05 MSG-BODY           PIC X(500).
    05 MSG-READ-FLAG      PIC X.

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

FD JOB-POSTINGS-FILE.
01 JOB-POSTING-REC.
    05 JP-JOB-ID          PIC 9(6).
    05 JP-JOB-TITLE       PIC X(100).
    05 JP-JOB-DESCRIPTION PIC X(250).
    05 JP-JOB-EMPLOYER    PIC X(100).
    05 JP-JOB-LOCATION    PIC X(100).
    05 JP-JOB-SALARY      PIC X(50).
    05 JP-POSTED-BY       PIC X(100).

FD JOB-APPLICATIONS-FILE.
01 JOB-APPLICATION-REC.
    05 JA-USERNAME        PIC X(100).
    05 JA-JOB-ID          PIC 9(6).
    05 JA-JOB-TITLE       PIC X(100).
    05 JA-JOB-EMPLOYER    PIC X(100).
    05 JA-JOB-LOCATION    PIC X(100).

FD ESTABLISHED-CONNECTIONS-FILE.
01 ESTABLISHED-CONNECTION-REC.
    05 EST-CONN-USER1     PIC X(100).
    05 EST-CONN-USER2     PIC X(100).

WORKING-STORAGE SECTION.
01 WS-COUNTERS.
    05 WS-USER-COUNT PIC 9 VALUE 0.
    05 WS-JOB-COUNT  PIC 9 VALUE 0.
    05 WS-CONN-COUNT PIC 9 VALUE 0.

    05 WS-MSG-COUNT  PIC 9 VALUE 0.


PROCEDURE DIVISION.
0000-MAIN.
    DISPLAY "========================================".
    DISPLAY "InCollege Database Setup Utility".
    DISPLAY "========================================".
    DISPLAY " ".

    PERFORM 1000-CREATE-USER-ACCOUNTS
    PERFORM 2000-CREATE-USER-PROFILES
    PERFORM 3000-CREATE-JOB-POSTINGS
    PERFORM 4000-CREATE-EMPTY-APPLICATIONS
    PERFORM 5000-CREATE-ESTABLISHED-CONNECTIONS
    PERFORM 6000-CREATE-MESSAGES

    DISPLAY " ".
    DISPLAY "========================================".
    DISPLAY "Database setup complete!".
    DISPLAY "Created " WS-USER-COUNT " user accounts".
    DISPLAY "Created " WS-JOB-COUNT " job postings".
    DISPLAY "Created " WS-CONN-COUNT " established connections".
    DISPLAY "========================================".

    STOP RUN.

1000-CREATE-USER-ACCOUNTS.
    DISPLAY "Creating user accounts...".

    OPEN OUTPUT USER-ACCOUNT-FILE.

    *> User 1: TestUser
    MOVE "TestUser" TO USER-NAME
    MOVE "Test123!" TO USER-PASSWORD
    WRITE USER-ACCOUNT-REC
    ADD 1 TO WS-USER-COUNT

    *> User 2: JobPoster1
    MOVE "JobPoster1" TO USER-NAME
    MOVE "Post123!" TO USER-PASSWORD
    WRITE USER-ACCOUNT-REC
    ADD 1 TO WS-USER-COUNT

    *> User 3: AliceSmith
    MOVE "AliceSmith" TO USER-NAME
    MOVE "Alice123!" TO USER-PASSWORD
    WRITE USER-ACCOUNT-REC
    ADD 1 TO WS-USER-COUNT

    *> User 4: BobJones
    MOVE "BobJones" TO USER-NAME
    MOVE "Bob123!" TO USER-PASSWORD
    WRITE USER-ACCOUNT-REC
    ADD 1 TO WS-USER-COUNT

    CLOSE USER-ACCOUNT-FILE.
    DISPLAY "  -> " WS-USER-COUNT " user accounts created.".

2000-CREATE-USER-PROFILES.
    DISPLAY "Creating user profiles...".

    OPEN OUTPUT USER-PROFILE-FILE.

    *> Profile 1: TestUser
    INITIALIZE USER-PROFILE-REC
    MOVE "TestUser" TO UP-USER-NAME
    MOVE "John" TO UP-FIRST-NAME
    MOVE "Doe" TO UP-LAST-NAME
    MOVE "University of South Florida" TO UP-UNIVERSITY
    MOVE "Computer Science" TO UP-MAJOR
    MOVE 2025 TO UP-GRAD-YEAR
    MOVE "Passionate about software development and AI." TO UP-ABOUT-ME
    MOVE 1 TO UP-NUM-EXP
    MOVE "Software Intern" TO UP-EXP-TITLE(1)
    MOVE "Tech Solutions Inc" TO UP-EXP-COMPANY(1)
    MOVE "Summer 2024" TO UP-EXP-DATE(1)
    MOVE "Developed web applications using React and Node.js" TO UP-EXP-DESC(1)
    MOVE 1 TO UP-NUM-EDU
    MOVE "Bachelor of Science in Computer Science" TO UP-EDU-DEGREE(1)
    MOVE "University of South Florida" TO UP-EDU-UNI(1)
    MOVE "2021-2025" TO UP-EDU-YEARS(1)
    WRITE USER-PROFILE-REC

    *> Profile 2: AliceSmith
    INITIALIZE USER-PROFILE-REC
    MOVE "AliceSmith" TO UP-USER-NAME
    MOVE "Alice" TO UP-FIRST-NAME
    MOVE "Smith" TO UP-LAST-NAME
    MOVE "Florida State University" TO UP-UNIVERSITY
    MOVE "Data Science" TO UP-MAJOR
    MOVE 2024 TO UP-GRAD-YEAR
    MOVE "Data enthusiast with experience in machine learning." TO UP-ABOUT-ME
    MOVE 1 TO UP-NUM-EXP
    MOVE "Data Analyst Intern" TO UP-EXP-TITLE(1)
    MOVE "Analytics Corp" TO UP-EXP-COMPANY(1)
    MOVE "Fall 2023" TO UP-EXP-DATE(1)
    MOVE "Analyzed customer data and created dashboards" TO UP-EXP-DESC(1)
    MOVE 1 TO UP-NUM-EDU
    MOVE "Bachelor of Science in Data Science" TO UP-EDU-DEGREE(1)
    MOVE "Florida State University" TO UP-EDU-UNI(1)
    MOVE "2020-2024" TO UP-EDU-YEARS(1)
    WRITE USER-PROFILE-REC

    *> Profile 3: BobJones
    INITIALIZE USER-PROFILE-REC
    MOVE "BobJones" TO UP-USER-NAME
    MOVE "Bob" TO UP-FIRST-NAME
    MOVE "Jones" TO UP-LAST-NAME
    MOVE "University of Florida" TO UP-UNIVERSITY
    MOVE "Business Administration" TO UP-MAJOR
    MOVE 2026 TO UP-GRAD-YEAR
    MOVE "Aspiring entrepreneur with marketing experience." TO UP-ABOUT-ME
    MOVE 1 TO UP-NUM-EXP
    MOVE "Marketing Intern" TO UP-EXP-TITLE(1)
    MOVE "BrandBuilders LLC" TO UP-EXP-COMPANY(1)
    MOVE "Summer 2024" TO UP-EXP-DATE(1)
    MOVE "Managed social media campaigns and content creation" TO UP-EXP-DESC(1)
    MOVE 1 TO UP-NUM-EDU
    MOVE "Bachelor of Business Administration" TO UP-EDU-DEGREE(1)
    MOVE "University of Florida" TO UP-EDU-UNI(1)
    MOVE "2022-2026" TO UP-EDU-YEARS(1)
    WRITE USER-PROFILE-REC

    CLOSE USER-PROFILE-FILE.
    DISPLAY "  -> User profiles created.".

3000-CREATE-JOB-POSTINGS.
    DISPLAY "Creating job postings...".

    OPEN OUTPUT JOB-POSTINGS-FILE.

    *> Job 1
    MOVE 1 TO JP-JOB-ID
    MOVE "Software Engineer Intern" TO JP-JOB-TITLE
    MOVE "Develop and maintain software applications. Work with cross-functional teams on exciting projects." TO JP-JOB-DESCRIPTION
    MOVE "TechCorp" TO JP-JOB-EMPLOYER
    MOVE "New York, NY" TO JP-JOB-LOCATION
    MOVE "$25/hour" TO JP-JOB-SALARY
    MOVE "JobPoster1" TO JP-POSTED-BY
    WRITE JOB-POSTING-REC
    ADD 1 TO WS-JOB-COUNT

    *> Job 2
    MOVE 2 TO JP-JOB-ID
    MOVE "Data Analyst" TO JP-JOB-TITLE
    MOVE "Analyze large datasets and create insightful reports. Experience with SQL and Python required." TO JP-JOB-DESCRIPTION
    MOVE "DataSolutions" TO JP-JOB-EMPLOYER
    MOVE "Remote" TO JP-JOB-LOCATION
    MOVE "$50000/year" TO JP-JOB-SALARY
    MOVE "JobPoster1" TO JP-POSTED-BY
    WRITE JOB-POSTING-REC
    ADD 1 TO WS-JOB-COUNT

    *> Job 3
    MOVE 3 TO JP-JOB-ID
    MOVE "Marketing Specialist" TO JP-JOB-TITLE
    MOVE "Create and manage marketing campaigns. Handle social media and content strategy." TO JP-JOB-DESCRIPTION
    MOVE "BrandInc" TO JP-JOB-EMPLOYER
    MOVE "Chicago, IL" TO JP-JOB-LOCATION
    MOVE "NONE" TO JP-JOB-SALARY
    MOVE "JobPoster1" TO JP-POSTED-BY
    WRITE JOB-POSTING-REC
    ADD 1 TO WS-JOB-COUNT

    *> Job 4
    MOVE 4 TO JP-JOB-ID
    MOVE "Web Developer" TO JP-JOB-TITLE
    MOVE "Build responsive websites using modern frameworks. 2+ years experience preferred." TO JP-JOB-DESCRIPTION
    MOVE "WebWorks LLC" TO JP-JOB-EMPLOYER
    MOVE "San Francisco, CA" TO JP-JOB-LOCATION
    MOVE "$70000/year" TO JP-JOB-SALARY
    MOVE "TestUser" TO JP-POSTED-BY
    WRITE JOB-POSTING-REC
    ADD 1 TO WS-JOB-COUNT

    *> Job 5
    MOVE 5 TO JP-JOB-ID
    MOVE "UX Designer Intern" TO JP-JOB-TITLE
    MOVE "Design user interfaces and improve user experience. Work with design tools like Figma." TO JP-JOB-DESCRIPTION
    MOVE "DesignHub" TO JP-JOB-EMPLOYER
    MOVE "Austin, TX" TO JP-JOB-LOCATION
    MOVE "$22/hour" TO JP-JOB-SALARY
    MOVE "TestUser" TO JP-POSTED-BY
    WRITE JOB-POSTING-REC
    ADD 1 TO WS-JOB-COUNT

    CLOSE JOB-POSTINGS-FILE.
    DISPLAY "  -> " WS-JOB-COUNT " job postings created.".

4000-CREATE-EMPTY-APPLICATIONS.
    DISPLAY "Creating empty applications file...".

    OPEN OUTPUT JOB-APPLICATIONS-FILE.
    CLOSE JOB-APPLICATIONS-FILE.

    DISPLAY "  -> Empty applications file created.".

5000-CREATE-ESTABLISHED-CONNECTIONS.
    DISPLAY "Creating established connections...".

    OPEN OUTPUT ESTABLISHED-CONNECTIONS-FILE.

    *> Connection 1: TestUser <-> AliceSmith (bidirectional)
    MOVE "TestUser" TO EST-CONN-USER1
    MOVE "AliceSmith" TO EST-CONN-USER2
    WRITE ESTABLISHED-CONNECTION-REC
    ADD 1 TO WS-CONN-COUNT

    MOVE "AliceSmith" TO EST-CONN-USER1
    MOVE "TestUser" TO EST-CONN-USER2
    WRITE ESTABLISHED-CONNECTION-REC

    *> Connection 2: TestUser <-> BobJones (bidirectional)
    MOVE "TestUser" TO EST-CONN-USER1
    MOVE "BobJones" TO EST-CONN-USER2
    WRITE ESTABLISHED-CONNECTION-REC
    ADD 1 TO WS-CONN-COUNT

    MOVE "BobJones" TO EST-CONN-USER1
    MOVE "TestUser" TO EST-CONN-USER2
    WRITE ESTABLISHED-CONNECTION-REC

    *> Connection 3: AliceSmith <-> BobJones (bidirectional)
    MOVE "AliceSmith" TO EST-CONN-USER1
    MOVE "BobJones" TO EST-CONN-USER2
    WRITE ESTABLISHED-CONNECTION-REC
    ADD 1 TO WS-CONN-COUNT

    MOVE "BobJones" TO EST-CONN-USER1
    MOVE "AliceSmith" TO EST-CONN-USER2
    WRITE ESTABLISHED-CONNECTION-REC

    *> JobPoster1 has no connections (good for testing rejection)

    CLOSE ESTABLISHED-CONNECTIONS-FILE.
    DISPLAY "  -> " WS-CONN-COUNT " established connections created.".

6000-CREATE-MESSAGES.
    DISPLAY "Creating dummy messages...".

    OPEN OUTPUT MESSAGES-FILE.

    *> Message 1: From AliceSmith (a connection) to TestUser
    INITIALIZE MESSAGE-REC
    MOVE "AliceSmith" TO MSG-FROM-USER
    MOVE "TestUser" TO MSG-TO-USER
    MOVE "Hi TestUser, I saw your post about the new React framework. What are your thoughts on it?" TO MSG-BODY
    MOVE "N" TO MSG-READ-FLAG
    WRITE MESSAGE-REC
    ADD 1 TO WS-MSG-COUNT

    *> Message 2: From BobJones (a connection) to TestUser
    INITIALIZE MESSAGE-REC
    MOVE "BobJones" TO MSG-FROM-USER
    MOVE "TestUser" TO MSG-TO-USER
    MOVE "Hey, are you going to the UF-USF football game this weekend? We should catch up!" TO MSG-BODY
    MOVE "N" TO MSG-READ-FLAG
    WRITE MESSAGE-REC
    ADD 1 TO WS-MSG-COUNT

    *> Message 3: Another message from AliceSmith to TestUser
    INITIALIZE MESSAGE-REC
    MOVE "AliceSmith" TO MSG-FROM-USER
    MOVE "TestUser" TO MSG-TO-USER
    MOVE "I was wondering if you wanted to collaborate on that Data Science project we discussed." TO MSG-BODY
    MOVE "N" TO MSG-READ-FLAG
    WRITE MESSAGE-REC
    ADD 1 TO WS-MSG-COUNT

    CLOSE MESSAGES-FILE.
    DISPLAY "  -> " WS-MSG-COUNT " messages created.".