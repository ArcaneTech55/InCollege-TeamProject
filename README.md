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
- User accounts are persisted in `USER-ACCOUNT.DAT` (created/updated in the project root).

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
- Persistent accounts file: `USER-ACCOUNT.DAT`

All of the above are located in the project root.
