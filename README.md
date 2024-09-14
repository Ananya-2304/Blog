
# Content Management System (CMS)

This project is a **Content Management System (CMS)** designed to provide an intuitive and efficient platform for managing blogs. The system supports content editing, viewing, and collaboration, with features such as **category-based post creation**, **comments**, **likes**, and **email notifications** to enhance user engagement.

## Features

- **Category-based Post Creation**: Users can create and manage blog posts under different categories.
- **Post Management Interfaces**: Easy-to-use interfaces for viewing, editing, and deleting posts.
- **Comments and Likes**: Allows users to engage with content by adding comments and likes.
- **Email Notifications**: Sends notifications to users about new posts and comments.
- **Responsive Design**: The platform is fully responsive, providing an optimal user experience across devices.

## Technology Stack

- **Frontend**: React.js, SCSS
- **Backend**: Node.js, Express.js
- **Database**: MySQL
- **Email Notifications**: NodeMailer 

## Prerequisites

Before running the project, make sure you have the following installed:

- **Node.js** (version 14.x or higher)
- **MySQL** (with a user and database configured)
- **NPM** or **Yarn** package manager

## Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/your-username/cms-project.git
cd cms-project
```

### 2. Install dependencies

In both the **frontend** and **backend** directories, install the required dependencies.

#### Backend Setup

```bash
cd api
npm install
```

#### Frontend Setup

```bash
cd client
npm install
```

### 3. Configure MySQL Database

1. Run the sql queries in blog(1).sql
2. Update the database credentials

### 4. Setup Nodemailer configurations
1. Create Google app password.
2.Navigate to comment.js and update the app details in 
```bash
const transporter = nodemailer.createTransport({
    service: 'Gmail',
    auth: {
        user: 'your_email',
        pass: 'app_password'
    }
});
```

### 5. Run the backend server

In the **backend** directory, start the Express server:

```bash
npm start
```

The backend server will run on `http://localhost:5000`.

### 6. Run the frontend server

In the **frontend** directory, start the React app:

```bash
npm start
```

The React application will run on `http://localhost:3000`.

### 7. Open the application

Open your browser and go to `http://localhost:3000` to access the CMS.

