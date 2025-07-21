# 🗓️ Event Management Platform – Team Nova

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
│   ├── page.tsx                   # Home page
│   ├── create-event/              # Event creation UI
│   └── events/[id]/               # View/edit events
│
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

Frontend runs on: [http://localhost:3000](http://localhost:3000)

---

### 🧠 Run Jaseci Backend

```bash
cd ../event-management-backend
jsctl
```

Inside the Jaseci shell:
```bash
actions load planner-user.jac
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
