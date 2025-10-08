# InCollege-TeamProject
Developing InCollege for a Software Engineering Class at USF

# Prerequisites

To ensure a reproducible development environment, we recommend using **Visual Studio Code (VS Code)** as the primary editor for this project.

At this stage, all development should be done inside a **Docker container** for consistency across team members.

---

## Setup Instructions

1. **Clone the repository**
   ```bash
   git clone https://github.com/ArcaneTech55/InCollege-TeamProject.git
   cd InCollege-TeamProject
   ```

2. **Start Docker Engine**

    Make sure Docker Engine is running (via opening Docker Desktop or configuring terminal setup).

    This is the same setup we used in `COBOL Hello World` assignment.

3. **Open the project in a Dev Container**

    In VS Code, open the Command Palette (`Ctrl + Shift + P` on Windows, `Shift + Command + P` on Mac).

    Search for and select:

    ```yaml
    Dev Containers: Reopen in Container
    ```

    VS Code will rebuild and reopen the project inside the configured Docker container.

---

## Build (Compile) the COBOL programs

We use GnuCOBOL inside the dev container.

1. Create a `bin` directory, if it is not created, for compiled executables:
   ```bash
   mkdir -p bin
   ```

2. Compile the main program (`src/InCollege.cob`):
   ```bash
   cobc -x -free -std=cobol2014 -Wall -o bin/InCollege src/InCollege.cob
   ```

3. Compile the sample account generator (src/create_sample_account_file.cob):
   ```bash
   cobc -x -free -std=cobol2014 -Wall -o bin/create_sample_account_file src/create_sample_account_file.cob
   ```
---

## Prepare input and data files

- The program reads user input from a text file named `InCollege-Input.txt` in the project root.
- Program output is displayed on-screen and also written to `InCollege-Output.txt` in the project root.
- Persistent data files are created under `data/`:
  - `data/USER-ACCOUNT.DAT`
  - `data/USER-PROFILE.DAT`
  - `data/TEMP-PROFILE.DAT`
  - `data/CONNECTIONS.DAT` (connection requests)
  - `data/ESTABLISHED-CONNECTIONS.DAT` (accepted connections)

You have two options to have valid accounts available for login:

1) Seed accounts using the sample account generator:
   ```bash
   ./bin/create_sample_account_file
   ```
   This will create or update `USER-ACCOUNT.DAT` with sample accounts.

2) Or create an account through the main app by providing appropriate inputs in `InCollege-Input.txt` (choose "Create New Account" at the main menu, then provide username and password that meet the requirements below).

### Password requirements
- 8–12 characters in length
- At least one capital letter (A–Z)
- At least one digit (0–9)
- At least one special character from: `! @ # $ % ^ & * ( )`

### Example `InCollege-Input.txt`
Below is an example that:
- Logs in to an existing user `stduser` with password `ValidPass1!`
- Exercises post-login options (Search job, Find someone), opens Learn a new skill, selects a skill, then returns.

```text
1
stduser
ValidPass1!
1
2
3
1
6
```

If you need to create the user first, your input should start with creating an account (option `2`) before logging in, for example:

```text
2
stduser
ValidPass1!
1
stduser
ValidPass1!
```

Save your desired sequence to `InCollege-Input.txt` before running the program.

---

## Profile Creation - Upon successful login create a user profile for InCollege
- Create a profile with this information:
- First Name and Last Name
- University/College Attended
- Major
- Graduation Year - Valid four digit number
- About me - short description about where users can provide extra details about themself
- Experience (Up to three entries) - Any project or past work experience
- Education (Up to three entries) - Users can provide any additional education background
---

## Profile Viewing - Upon creating a user profile users can view their own profile
- Once completeing a user a profile it can be viewed by navigating the post login menu to "View My Profile"

---
## Run the program

Run the compiled executable from the project root:
```bash
./bin/InCollege
```

The program will:
- Read all inputs from `InCollege-Input.txt`
- Display all prompts/messages on the console
- Write the exact same prompts/messages to `InCollege-Output.txt`

If `InCollege-Input.txt` is exhausted (EOF), the program exits gracefully.

---

## Where to find outputs and data
- Input file: `InCollege-Input.txt`
- Console output: printed during execution
- Output mirror file: `InCollege-Output.txt`
- Persistent data files (created/updated at runtime): under `data/`
  - `USER-ACCOUNT.DAT`
  - `USER-PROFILE.DAT`
  - `TEMP-PROFILE.DAT`
  - `CONNECTIONS.DAT`
  - `ESTABLISHED-CONNECTIONS.DAT`

---

## Connection Management (Send, Accept/Reject, View Network)

### Overview
After logging in, the post-login menu includes:
- `4. View My Pending Connection Requests`
- `5. View My Network`
- Searching for a user by full name shows a profile view with:
  - `1. Send Connection Request`
  - `2. Back to Main Menu`

All outputs are mirrored to `InCollege-Output.txt`. Connection data is stored persistently in:
- `data/CONNECTIONS.DAT` (pending requests)
- `data/ESTABLISHED-CONNECTIONS.DAT` (accepted connections)

### Managing Pending Connection Requests
When viewing pending connection requests, users can:
- **Accept**: Establishes a permanent connection between users
- **Reject**: Removes the request without establishing a connection
- Both actions provide clear confirmation messages

### Network Display
The "View My Network" option displays:
- Full names of all connected users
- University and major information for each connection
- Format: `"Connected with: [Full Name] (University: [University], Major: [Major])"`

### Input Preparation (Single-Run End-to-End)
Below example will:
1) Create two accounts (TestUser, NewStudent)
2) Log in as NewStudent and create a profile
3) Log out, log in as TestUser, send a connection request to New Student
4) Log out, log in as NewStudent, accept the connection request
5) View the established network

```text
2
TestUser
Password123!
2
NewStudent
Password123!
1
NewStudent
Password123!
6
New
Student
West Coast Uni
Business
2027

DONE
DONE
1
TestUser
Password123!
2
New
Student
1
7
1
NewStudent
Password123!
4
1
5
7
```

### What to Expect in Output
- After search and profile view, when sending a request:
  - `Connection request sent to New Student.`
- When viewing pending requests (as NewStudent):
  - `--- Pending Connection Requests ---`
  - `Request from: TestUser`
  - `1. Accept` / `2. Reject`
  - `Connection request accepted!` (or rejected)
- When viewing network (after accepting):
  - `--- Your Network ---`
  - `Connected with: Test User (University: USF, Major: Computer Science)`
  - `--------------------`

### Data Files Used
- `data/CONNECTIONS.DAT` holds connection requests as records:
  - From Username (sender)
  - To Username (recipient)
  - Status (`PENDING`)
- `data/ESTABLISHED-CONNECTIONS.DAT` holds accepted connections as records:
  - User1 (connected user)
  - User2 (connected user)
  - Each connection is stored as two records (bidirectional)

Files in `data/` are re-created as needed on startup or on demand, and are ignored by git (see `.gitignore`).
