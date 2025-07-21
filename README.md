# Solution 1:Event Planner Assistant – Command Line Tool with AI

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

With your virtual environment activated, install Jac and dependencies using pip:

```
pip install -r requirements.txt
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

##  🚀 Features

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


# Solution 2:Event Management Platform – Intractive Web based solution with Jac Backend

This is a full-stack event management platform developed using **Next.js** for the frontend and **Jaseci** for backend logic with `.jac` files. The system allows users to create, view, and manage events with an integrated smart planning assistant.

---

## 🚀 Features

- 🌐 Modern, responsive UI using Next.js + Tailwind CSS  
- 🧠 Smart event planner powered by Jaseci  
- 📝 Create, edit, and view event details  
- 📊 Personalized dashboard interface  
- 🔒 Session handling with logout route  

---

## 🛠️ Tech Stack

**Frontend**
- [Next.js](https://nextjs.org/)
- [TypeScript](https://www.typescriptlang.org/)
- [TailwindCSS](https://tailwindcss.com/)

**Backend**
- [Jaseci](https://docs.jaseci.org/) – AI-powered backend logic
- `.jac` file for defining planner behavior

---

## 📁 Project Structure

```
Jac_Example_Team_Nova/
├── event-management-frontend/     # Frontend (Next.js + TailwindCSS)
│   ├── app/                       # Page routing and layout
│   ├── globals.css                # Global styles
├── event-management-backend/     # Backend (Jaseci logic)
│   └── planner-user.jac
└── README.md
```

---

## 🔧 Getting Started

### ✅ Prerequisites

- Node.js (v18 or newer)
- npm / pnpm / yarn
- Python 3.x with Jaseci CLI

Install Jaseci:
```bash
pip install jaseci
```

---

### ⚙️ Setup Instructions

#### 1. Clone the Repository
```bash
git clone https://github.com/yourusername/Jac_Example_Team_Nova.git
cd Jac_Example_Team_Nova
```

#### 2. Install Frontend Dependencies
```bash
cd event-management-frontend
npm install  # or pnpm install
```

#### 3. Run the Frontend
```bash
npm run dev
```

---

### 🧠 Run Jaseci Backend

```bash
cd ../
```

Create or activate a virtual environment to isolate dependencies:

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

With your virtual environment activated, install Jac and dependencies using pip:

```
pip install -r requirements.txt
```

---

```bash
cd event-management-backend
```

Inside the Jaseci shell:
```bash
jac serve planner-user.jac
```

---

## 🔮 Future Improvements

- 🔐 User authentication and roles  
- 📧 Email notifications/reminders  
- 📱 Mobile-friendly enhancements  
- 💡 AI-driven event suggestions  
- 📂 Event categories and filtering  

---

## 👥 Authors

Built with ❤️ by **Team Nova**

---

## 📄 License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).
