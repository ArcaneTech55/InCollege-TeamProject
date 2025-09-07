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
