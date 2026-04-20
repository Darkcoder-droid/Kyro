<div align="center">

```
██╗  ██╗██╗   ██╗██████╗  ██████╗
██║ ██╔╝╚██╗ ██╔╝██╔══██╗██╔═══██╗
█████╔╝  ╚████╔╝ ██████╔╝██║   ██║
██╔═██╗   ╚██╔╝  ██╔══██╗██║   ██║
██║  ██╗   ██║   ██║  ██║╚██████╔╝
╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝
```

**A next-generation student productivity & collaboration platform**

[![License: MIT](https://img.shields.io/badge/License-MIT-7F77DD.svg?style=flat-square)](LICENSE)
[![Node.js](https://img.shields.io/badge/Node.js-18+-339933.svg?style=flat-square&logo=node.js&logoColor=white)](https://nodejs.org)
[![React](https://img.shields.io/badge/React-18-61DAFB.svg?style=flat-square&logo=react&logoColor=white)](https://reactjs.org)
[![Supabase](https://img.shields.io/badge/Supabase-Free_Tier-3ECF8E.svg?style=flat-square&logo=supabase&logoColor=white)](https://supabase.com)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](CONTRIBUTING.md)

[Features](#-features) · [Demo](#-demo) · [Getting Started](#-getting-started) · [Tech Stack](#-tech-stack) · [Contributing](#-contributing)

</div>

---

## ✦ Overview

Kyro is an all-in-one platform built for students who want to do more than just survive their coursework. It combines deep-focus tools, AI-powered learning assistance, real-time collaboration, and a publishing system — all in one clean, distraction-free interface.

> Built free. Built open. Built for learners.

---

## ◈ Features

<table>
<tr>
<td width="50%">

### 🗂 Task Management
Organize your work with priorities, categories, deadlines, and daily/weekly views. Never miss what matters.

### ⏱ Pomodoro Timer
Custom work/break intervals with session tracking. Stay focused, measure your progress.

### 🎧 Focus Mode
Full-screen minimal UI with ambient sound player — rain, café, white noise, forest. Built with Howler.js.

### 🤖 AI Learning Assistant
Powered by Gemini API (free tier). Ask questions, get learning paths, explain anything — with full conversation history.

</td>
<td width="50%">

### 🔍 Resource Finder
AI-curated learning resources filtered by type and difficulty. Save anything worth revisiting.

### 💬 Real-Time Messaging
1:1 and group chat with typing indicators. Socket.io powered, Supabase persisted.

### 🎙 Study Rooms
Create or join live study sessions with WebRTC peer-to-peer voice calls and host-synced shared audio.

### 📝 Publishing System
Write and publish notes, articles, and resources with a full Tiptap rich text editor. Discover what others share.

</td>
</tr>
</table>

---

## ◈ Demo

> Coming soon — deployment in progress.

Screenshots and a live demo link will appear here once the first release is deployed.

---

## ◈ Tech Stack

| Layer | Technology |
|---|---|
| Frontend | React 18 + Vite + TailwindCSS |
| Backend | Node.js + Express |
| Database | Supabase (PostgreSQL + Auth + Storage + Realtime) |
| AI | Google Gemini API (free tier) |
| Real-time | Socket.io |
| Voice | WebRTC via simple-peer |
| Rich Text | Tiptap |
| Audio | Howler.js |

---

## ◈ Getting Started

### Prerequisites

- Node.js 18+
- A [Supabase](https://supabase.com) account (free tier)
- A [Google Gemini API key](https://aistudio.google.com/app/apikey) (free, no credit card)

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/your-username/kyro.git
cd kyro

# 2. Install server dependencies
cd server && npm install

# 3. Install client dependencies
cd ../client && npm install
```

### Environment Setup

Create `server/.env`:

```env
SUPABASE_URL=your_supabase_project_url
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key
GEMINI_API_KEY=your_gemini_api_key
PORT=5000
```

Create `client/.env`:

```env
VITE_SUPABASE_URL=your_supabase_project_url
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key
VITE_API_BASE_URL=http://localhost:5000/api
```

### Database Setup

1. Go to your Supabase project → SQL Editor
2. Run the full schema from [`/server/schema.sql`](server/schema.sql)
3. Row Level Security is automatically configured

### Run Locally

```bash
# In /server
npm run dev

# In /client (separate terminal)
npm run dev
```

App will be available at `http://localhost:5173`

---

## ◈ Project Structure

```
kyro/
├── client/                  # React frontend (Vite)
│   └── src/
│       ├── components/      # UI primitives, layout, feature components
│       ├── pages/           # Route-level page components
│       ├── context/         # Auth, Theme, Socket context providers
│       ├── hooks/           # Custom React hooks
│       └── lib/             # Supabase + socket client config
│
├── server/                  # Express backend
│   ├── routes/              # API route definitions
│   ├── controllers/         # Business logic
│   ├── services/            # AI, resource, recommendation services
│   ├── sockets/             # Socket.io chat + room handlers
│   └── middleware/          # JWT auth, error handling
│
└── README.md
```

---

## ◈ Roadmap

- [ ] OAuth login (Google)
- [ ] Mobile app (React Native)
- [ ] Offline mode with service workers
- [ ] Flashcard / spaced repetition module
- [ ] Calendar integration
- [ ] Collaborative document editing

---

## ◈ Contributing

Contributions are welcome. Please open an issue first to discuss what you'd like to change.

```bash
# Fork → clone → create a feature branch
git checkout -b feature/your-feature-name

# Make your changes, then
git commit -m "feat: describe your change"
git push origin feature/your-feature-name

# Open a Pull Request
```

Please follow the existing code style and write clear commit messages.

---

## ◈ License

Distributed under the [MIT License](LICENSE). Free to use, modify, and distribute.

---

<div align="center">

Built with care by students, for students.

**[⬆ Back to top](#)**

</div>
