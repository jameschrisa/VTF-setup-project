#!/bin/bash

# Set errexit, pipefail and nounset options
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to log errors
log_error() {
    echo -e "${RED}ERROR: $1${NC}" >&2
}

# Function to log warnings
log_warning() {
    echo -e "${YELLOW}WARNING: $1${NC}"
}

# Function to log success messages
log_success() {
    echo -e "${GREEN}$1${NC}"
}

# Function to create a file with content
create_file() {
    local file_path="$1"
    local content="$2"
    mkdir -p "$(dirname "$file_path")" || { log_error "Failed to create directory for $file_path"; exit 1; }
    echo -e "$content" > "$file_path" || { log_error "Failed to create file $file_path"; exit 1; }
    log_success "Created file: $file_path"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check for required commands
for cmd in mkdir touch tree; do
    if ! command_exists "$cmd"; then
        log_error "Required command '$cmd' not found. Please install it and try again."
        exit 1
    fi
done

# Prompt user for project details
read -p "Enter project name: " project_name
if [[ -z "$project_name" ]]; then
    log_error "Project name cannot be empty."
    exit 1
fi

read -p "Enter project location (press Enter for current directory): " project_location

# Set project directory
if [ -z "$project_location" ]; then
    project_dir="$PWD/$project_name"
else
    project_dir="$project_location/$project_name"
fi

# Check if project directory already exists
if [ -d "$project_dir" ]; then
    log_warning "Directory $project_dir already exists. Files may be overwritten."
    read -p "Do you want to continue? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_error "Project creation aborted."
        exit 1
    fi
fi

# Create project directory
mkdir -p "$project_dir" || { log_error "Failed to create project directory"; exit 1; }
cd "$project_dir" || { log_error "Failed to change to project directory"; exit 1; }

log_success "Creating project structure for $project_name..."

# Create backend (Flask) structure
mkdir -p backend/app || { log_error "Failed to create backend directory structure"; exit 1; }
touch backend/run.py || { log_error "Failed to create run.py"; exit 1; }
create_file backend/app/__init__.py "# Flask app initialization and configuration"
create_file backend/app/routes.py "# Define your Flask routes here"
create_file backend/app/models.py "# Define your database models here"
create_file backend/requirements.txt "Flask==2.0.1
python-dotenv==0.19.0
Flask-SQLAlchemy==2.5.1
Flask-Migrate==3.1.0
Flask-CORS==3.0.10"

# Create frontend (Vue.js) structure
mkdir -p frontend/src/{assets,components,views,router,store} frontend/public || { log_error "Failed to create frontend directory structure"; exit 1; }
create_file frontend/package.json '{
  "name": "'$project_name'-frontend",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "serve": "vue-cli-service serve",
    "build": "vue-cli-service build",
    "lint": "vue-cli-service lint"
  },
  "dependencies": {
    "core-js": "^3.6.5",
    "vue": "^3.0.0",
    "vue-router": "^4.0.0-0",
    "vuex": "^4.0.0-0",
    "axios": "^0.21.1"
  },
  "devDependencies": {
    "@vue/cli-plugin-babel": "~4.5.0",
    "@vue/cli-plugin-eslint": "~4.5.0",
    "@vue/cli-plugin-router": "~4.5.0",
    "@vue/cli-plugin-vuex": "~4.5.0",
    "@vue/cli-service": "~4.5.0",
    "@vue/compiler-sfc": "^3.0.0",
    "babel-eslint": "^10.1.0",
    "eslint": "^6.7.2",
    "eslint-plugin-vue": "^7.0.0",
    "tailwindcss": "^2.2.19",
    "autoprefixer": "^10.4.0",
    "postcss": "^8.4.4"
  }
}'
create_file frontend/src/main.js "import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import './assets/tailwind.css'

createApp(App).use(store).use(router).mount('#app')"
create_file frontend/src/App.vue "<template>
  <div id=\"app\">
    <!-- Navigation component can go here -->
    <router-view/>
  </div>
</template>

<script>
export default {
  name: 'App'
}
</script>

<style>
/* Global styles */
</style>"
create_file frontend/src/router/index.js "import { createRouter, createWebHistory } from 'vue-router'
import Home from '../views/Home.vue'

const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home
  },
  // Add more routes as needed
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

export default router"
create_file frontend/src/store/index.js "import { createStore } from 'vuex'

export default createStore({
  state: {
  },
  mutations: {
  },
  actions: {
  },
  modules: {
  }
})"
create_file frontend/src/assets/tailwind.css "@import 'tailwindcss/base';
@import 'tailwindcss/components';
@import 'tailwindcss/utilities';"
create_file frontend/tailwind.config.js "module.exports = {
  purge: ['./index.html', './src/**/*.{vue,js,ts,jsx,tsx}'],
  darkMode: false,
  theme: {
    extend: {},
  },
  variants: {
    extend: {},
  },
  plugins: [],
}"
create_file frontend/postcss.config.js "module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  }
}"
create_file frontend/public/index.html "<!DOCTYPE html>
<html lang=\"\">
  <head>
    <meta charset=\"utf-8\">
    <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">
    <meta name=\"viewport\" content=\"width=device-width,initial-scale=1.0\">
    <link rel=\"icon\" href=\"<%= BASE_URL %>favicon.ico\">
    <title><%= htmlWebpackPlugin.options.title %></title>
  </head>
  <body>
    <noscript>
      <strong>We're sorry but <%= htmlWebpackPlugin.options.title %> doesn't work properly without JavaScript enabled. Please enable it to continue.</strong>
    </noscript>
    <div id=\"app\"></div>
    <!-- built files will be auto injected -->
  </body>
</html>"
create_file frontend/src/components/HelloWorld.vue "<template>
  <div class=\"hello\">
    <h1>{{ msg }}</h1>
    <p>
      Welcome to your new Vue.js and Flask project!
    </p>
  </div>
</template>

<script>
export default {
  name: 'HelloWorld',
  props: {
    msg: String
  }
}
</script>

<!-- Add \"scoped\" attribute to limit CSS to this component only -->
<style scoped>
h1 {
  margin: 40px 0 0;
}
</style>"
create_file frontend/src/views/Home.vue "<template>
  <div class=\"home\">
    <img alt=\"Vue logo\" src=\"../assets/logo.png\">
    <HelloWorld msg=\"Welcome to Your Vue.js App\"/>
  </div>
</template>

<script>
import HelloWorld from '@/components/HelloWorld.vue'

export default {
  name: 'Home',
  components: {
    HelloWorld
  }
}
</script>"

# Create root project files
create_file .gitignore "# Python
__pycache__/
*.py[cod]
*.pyo
*.pyd
.Python
env/
venv/
*.env

# Vue.js
.DS_Store
node_modules
/dist

# local env files
.env.local
.env.*.local

# Log files
npm-debug.log*
yarn-debug.log*
yarn-error.log*
pnpm-debug.log*

# Editor directories and files
.idea
.vscode
*.suo
*.ntvs*
*.njsproj
*.sln
*.sw?"
create_file README.md "# $project_name

This project uses Vue.js with Tailwind CSS for the frontend and Flask for the backend.

## Setup and Installation

### Backend (Flask)
1. Navigate to the backend directory: \`cd backend\`
2. Create a virtual environment: \`python -m venv venv\`
3. Activate the virtual environment:
   - On Windows: \`venv\\Scripts\\activate\`
   - On macOS and Linux: \`source venv/bin/activate\`
4. Install dependencies: \`pip install -r requirements.txt\`
5. Run the Flask application: \`python run.py\`

### Frontend (Vue.js)
1. Navigate to the frontend directory: \`cd frontend\`
2. Install dependencies: \`npm install\`
3. Run the development server: \`npm run serve\`

## Project Structure

[Project structure will be displayed here]"

log_success "Project setup complete!"
echo "Project structure:"
if ! tree -L 3 "$project_dir"; then
    log_warning "Unable to display project structure. 'tree' command failed."
    echo "Please check the project directory manually: $project_dir"
fi

log_success "Setup completed successfully. Happy coding!"
