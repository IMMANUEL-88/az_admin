# 📱 AttendZone Admin App

A powerful Flutter-based attendance and team management app built for companies. The admin panel helps HRs and managers track attendance, view analytics, assign tasks, and communicate effectively with employees.

## 🚀 Features

- **📊 Home Dashboard**
  - Weekly attendance bar graph
  - Navigation to Present/Absent data pages
  - Filter by selected date

- **📢 Announcements**
  - Send announcements to users via chat-like interface
  - Users get real-time updates

- **📁 Project Management**
  - View all projects with:
    - Completion %
    - Priority
    - Status
    - Deadline

- **👥 User Management**
  - List of all registered users
  - View user details quickly

- **📈 Analytics Dashboard**
  - Weekly analytics summary
  - Detailed charts and breakdowns

- **🌙🌞 Dark Mode / Light Mode**
  - Seamless UI switching

- **👤 Profile Section**
  - User photo and email
  - Quick access to Analytics Dashboard

- **🔐 Logout Button**

## 📸 Demo

- [Home Dashboard](demo/home.gif)
- [Announcements](demo/announcements.gif)
- [Projects Page](demo/projects.gif)
- [Analytics Dashboard](demo/analytics.gif)
- [Dark Mode Toggle](demo/profilescreen.gif)

## 📦 Tech Stack

- 🔧 Flutter (Admin App)
- 🗃 MongoDB
- 🌐 Node.js (Backend)
- 📡 REST API

## 📁 Folder Structure

```
lib/
├── screens/
├── widgets/
├── models/
├── services/
```

## 📬 Backend APIs
- The backend is built using Node.js and Express.js, and handles authentication, attendance tracking, announcements, project management, and analytics.

## 🛠 Setup

```bash
git clone https://github.com/IMMANUEL-88/az_admin.git
cd az_admin
flutter pub get
flutter run

