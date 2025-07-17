# Event Planner Assistant – Jac Example Project

<img width="1690" height="366" alt="Screenshot from 2025-07-16 11-01-07" src="https://github.com/user-attachments/assets/bc7cd50b-c89b-40f3-b01f-789534b1f70f" />

## Overview

This project demonstrates how to build an Event Planner Assistant using the Jac programming language. The assistant helps users create events, generate checklists, and suggest budgets using LLM-powered reasoning.

---

## Getting Started

### 1. Clone the Repository

Open your terminal or command prompt and run:

```
git clone https://github.com/RavimalRanathunga/Jac_Example_Team_Nova.git
cd Jac_Example_Team_Nova
```

### 2. Create a Python Virtual Environment

Create and activate a virtual environment to isolate dependencies:

- **On Windows:**
  ```
  python -m venv venv
  venv\Scripts\activate
  ```
- **On macOS/Linux:**
  ```
  python3 -m venv venv
  source venv/bin/activate
  ```

### 3. Install Jac Language

With your virtual environment activated, install Jac using pip:

```
pip install jac
```

---

## Navigating to Main Program Folders

The main Jac programs are located in the following folders:

- **Step 5:**  
  `event-planner-assistant/step-5/`
- **Step 6:**  
  `event-planner-assistant/step-6/`

Navigate to either folder to run the respective program:

```
cd event-planner-assistant/step-5
```
or
```
cd event-planner-assistant/step-6
```

---

## Running the Programs

To run a Jac program, use the following command inside the desired folder:

```
jac run step-5.jac
```
or
```
jac run step-6.jac
```

---

## Features

### Step 5: Interactive Event and Checklist Manager

- Create new events with name, date, and guest count.
- Add checklist items to each event with priority levels.
- View all created events and their checklists.
- User-friendly Command Line menu-driven interface.

### Step 6: LLM-Powered Event Planning Assistant

- Collects event details from the user.
- Uses an LLM (e.g., Gemini) to analyze event needs.
- Automatically generates a checklist based on event details and analysis.
- Suggests a budget tailored to the event.
- Guides the user through each planning phase interactively.

---

## Notes

- Ensure your terminal is pointed at the correct folder (step-5 or step-6) before running the Jac commands.
- The Jac programs are designed to be run in sequence, with step-6 building upon the functionality of step-5.
- For any issues or bugs, please check the GitHub repository for updates or raise a new issue.

---

## Acknowledgments

- Inspired by the need for efficient event planning solutions.
- Leveraging the Jac programming language for its simplicity and power.
- Utilizing LLMs for intelligent checklist generation and budget suggestion.
