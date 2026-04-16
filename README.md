# Biblioteca Digital - Galaxy Proyecto Final

Sistema de gestión de biblioteca digital con funcionalidades de catálogo, préstamos, devoluciones, multas, reservas y estadísticas.

## Estructura del Proyecto

```
.
├── backend/                 # Backend Python/Flask
│   ├── app.py              # Punto de entrada
│   ├── config.py           # Configuración
│   ├── requirements.txt     # Dependencias Python
│   ├── models/             # Modelos de base de datos
│   ├── routes/             # Rutas de API
│   └── utils/              # Funciones utilidad
├── frontend/               # Frontend HTML/CSS/JavaScript
│   ├── index.html          # Página principal
│   ├── login.html          # Login/Registro
│   ├── pages/              # Páginas adicionales
│   └── static/
│       ├── css/            # Estilos
│       └── js/             # Scripts
├── docker/                 # Configuración Docker
│   ├── Dockerfile.backend
│   └── Dockerfile.frontend
├── docker-compose.yml      # Orquestación de servicios
├── .env                    # Variables de entorno
└── .gitignore             # Archivos ignorados

## Tareas del Proyecto

### 1. Login y Registro (Task 19)
- Registro de usuarios
- Diferentes roles: estudiante, bibliotecario
- Inicio de sesión
- Perfil de usuario

### 2. Catálogo de Libros (Task 7)
- Registrar libros
- Gestionar autores
- Gestionar editoriales
- Gestionar ISBN

### 3. Buscador (Task 5)
- Búsqueda avanzada
- Filtros por título, autor, fecha

### 4. Préstamos y Devoluciones (Task 17)
- Gestionar estado de libros
- Fechas de préstamo
- Renovaciones

### 5. Multas y Reservas (Task 16)
- Calcular sanciones
- Gestionar devoluciones
- Renovar préstamos
- Reservar libros

### 6. Barra de Favoritos (Task 10)
- Sugerencias basadas en préstamos
- Libros más leídos

### 7. Estadísticas (Task 11)
- Reportes de uso
- Estado de préstamos
- Libros más solicitados

### 8. Interfaz (Task 20)
- Interfaz principal
- Pantalla de renta de libros
- Pantallas de cada sección

## Requisitos

- Docker y Docker Compose
- Python 3.11+ (para desarrollo local)
- MySQL 8.0

## Ejecución con Docker

```bash
docker-compose up
```

Servicios:
- Frontend: http://localhost
- Backend API: http://localhost:5000
- MySQL: localhost:3306

## Ejecución Local (sin Docker)

### Backend
```bash
cd backend
pip install -r requirements.txt
python app.py
```

### Frontend
Abrir `frontend/index.html` en el navegador o usar un servidor local.

## Despliegue

El proyecto está diseñado para ser deployable con Docker en cualquier servidor.
