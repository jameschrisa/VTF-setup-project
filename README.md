# Vue.js, Tailwind CSS, and Flask VTF Project Setup Script

This bash script automates the creation of a project structure for a web application using Vue.js with Tailwind CSS for the frontend and Flask for the backend. It sets up a complete development environment with all necessary configuration files and directory structures.

## Features

- Creates a full project structure for both frontend (Vue.js) and backend (Flask)
- Sets up Tailwind CSS configuration
- Generates basic Vue.js components and views
- Creates a simple Flask application structure
- Includes error handling and user-friendly messages
- Generates a .gitignore file and a project README.md

## Prerequisites

Before running this script, ensure you have the following installed:

- Bash shell
- Node.js and npm (for Vue.js and Tailwind CSS)
- Python (for Flask)
- `tree` command (optional, for displaying project structure)

## Usage

1. Save the script to a file, e.g., `setup_project.sh`.
2. Make the script executable:
   ```
   chmod +x setup_project.sh
   ```
3. Run the script:
   ```
   ./setup_project.sh
   ```
4. Follow the prompts to enter your project name and location.

## Project Structure

The script creates the following project structure:

```
project_name/
├── backend/
│   ├── app/
│   │   ├── __init__.py
│   │   ├── models.py
│   │   └── routes.py
│   ├── requirements.txt
│   └── run.py
├── frontend/
│   ├── public/
│   │   └── index.html
│   ├── src/
│   │   ├── assets/
│   │   │   └── tailwind.css
│   │   ├── components/
│   │   │   └── HelloWorld.vue
│   │   ├── router/
│   │   │   └── index.js
│   │   ├── store/
│   │   │   └── index.js
│   │   ├── views/
│   │   │   └── Home.vue
│   │   ├── App.vue
│   │   └── main.js
│   ├── package.json
│   ├── postcss.config.js
│   └── tailwind.config.js
├── .gitignore
└── README.md
```

## Setup After Running the Script

### Backend (Flask)

1. Navigate to the backend directory:
   ```
   cd backend
   ```
2. Create a virtual environment:
   ```
   python -m venv venv
   ```
3. Activate the virtual environment:
   - On Windows: `venv\Scripts\activate`
   - On macOS and Linux: `source venv/bin/activate`
4. Install dependencies:
   ```
   pip install -r requirements.txt
   ```
5. Run the Flask application:
   ```
   python run.py
   ```

### Frontend (Vue.js)

1. Navigate to the frontend directory:
   ```
   cd frontend
   ```
2. Install dependencies:
   ```
   npm install
   ```
3. Run the development server:
   ```
   npm run serve
   ```

## Customization

Feel free to modify the script to add or remove files, change configurations, or adjust the project structure to better suit your needs.

## Contributing

If you'd like to contribute to this project, please fork the repository and submit a pull request with your changes.

## License

This project is open-source and available under the MIT License.
