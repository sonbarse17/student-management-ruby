# Student Management System

A Ruby on Rails web application for managing student records with full CRUD operations.

## Description

This application allows users to manage student information including personal details, contact information, and academic data. Students can be created, viewed, updated, and deleted through a web interface.

## Tech Stack

- **Backend**: Ruby 3.0.2, Rails 7.1.5
- **Database**: PostgreSQL
- **Frontend**: HTML/ERB templates, CSS, JavaScript (Stimulus, Turbo)
- **Web Server**: Puma
- **Asset Pipeline**: Sprockets

## Project Structure

```
student-management-ruby/
├── app/
│   ├── controllers/          # Application controllers
│   │   └── students_controller.rb
│   ├── models/              # Data models
│   │   └── student.rb
│   ├── views/               # View templates
│   │   └── students/        # Student-related views
│   └── assets/              # CSS, JS, images
├── config/
│   ├── database.yml         # Database configuration
│   ├── routes.rb           # Application routes
│   └── puma.rb             # Web server config
├── db/
│   ├── migrate/            # Database migrations
│   └── schema.rb           # Database schema
├── Dockerfile.app          # Application container
├── Dockerfile.db           # Database container
└── docker-compose.yml      # Container orchestration
```

## Features

- **Student Management**: Create, read, update, delete student records
- **Data Validation**: Email uniqueness, required fields, format validation
- **Student Attributes**: Name, email, phone, date of birth, grade, address
- **Age Calculation**: Automatic age calculation from date of birth
- **Responsive Interface**: Clean web interface for data management

## Ports Used

- **Application**: 3000 (Rails server)
- **Database**: 5432 (PostgreSQL)

## Local Development Setup

### Prerequisites
- Ruby 3.0.2
- PostgreSQL
- Bundler gem

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd student-management-ruby
   ```

2. **Install dependencies**
   ```bash
   bundle install
   ```

3. **Setup database**
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. **Start the server**
   ```bash
   rails server
   ```

5. **Access the application**
   - Open browser to `http://localhost:3000`

## Docker Deployment

### Quick Start
```bash
docker-compose up --build
```

### Manual Container Build
```bash
# Build application container
docker build -f Dockerfile.app -t student-app .

# Build database container
docker build -f Dockerfile.db -t student-db .

# Run containers
docker run -d --name postgres-db student-db
docker run -d --name rails-app -p 3000:3000 --link postgres-db:db student-app
```

### Environment Variables
- `DATABASE_HOST`: Database hostname (default: localhost)
- `DATABASE_USERNAME`: Database user (default: postgres)
- `DATABASE_PASSWORD`: Database password (default: postgres)
- `RAILS_ENV`: Rails environment (development/production)

## Database Schema

**Students Table:**
- `first_name` (string, required)
- `last_name` (string, required)
- `email` (string, unique, required)
- `phone` (string)
- `date_of_birth` (date)
- `grade` (string)
- `address` (text)

## Kubernetes Deployment

### Prerequisites
- Kubernetes cluster
- kubectl configured
- Docker images available:
  - `sonbarse17/ruby-app:latest`
  - `sonbarse17/ruby-db:latest`

### Setup
1. **Create Rails master key secret**
   ```bash
   kubectl create secret generic rails-master-key --from-file=master.key=config/master.key
   ```

2. **Deploy to Kubernetes**
   ```bash
   kubectl apply -f k8s/db-pvc.yml
   kubectl apply -f k8s/db-svc.yml
   kubectl apply -f k8s/db-deploy.yml
   kubectl apply -f k8s/app-svc.yml
   kubectl apply -f k8s/app-deployment.yml
   kubectl apply -f k8s/ingress.yml
   ```

3. **Verify deployment**
   ```bash
   kubectl get pods
   kubectl get services
   kubectl get ingress
   ```

### K8s Components
- **Database**: PostgreSQL StatefulSet with persistent storage (30Gi)
- **Application**: Rails Deployment with 3 replicas
- **Services**: ClusterIP services for internal communication
- **Ingress**: NGINX ingress for external access
- **Storage**: PersistentVolumeClaim for database data

## API Endpoints

- `GET /` - List all students
- `GET /students/:id` - Show student details
- `GET /students/new` - New student form
- `POST /students` - Create student
- `GET /students/:id/edit` - Edit student form
- `PATCH/PUT /students/:id` - Update student
- `DELETE /students/:id` - Delete student