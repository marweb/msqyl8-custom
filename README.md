# MySQL 8 Docker Setup

Este proyecto configura un contenedor MySQL 8 con configuración personalizada usando variables de entorno.

## Configuración

- **MySQL Version**: 8.0
- **SQL Mode**: NO_ENGINE_SUBSTITUTION
- **Puerto**: Configurable via variable de entorno
- **Autenticación**: mysql_native_password
- **Charset**: utf8mb4

## Setup inicial

1. Copia el archivo de ejemplo de variables de entorno:
```bash
cp .env.example .env
```

2. Edita el archivo `.env` con tus valores:
```bash
# Configuración de MySQL
MYSQL_ROOT_PASSWORD=tu_password_root
MYSQL_DATABASE=tu_base_de_datos
MYSQL_USER=tu_usuario
MYSQL_PASSWORD=tu_password

# Configuración del contenedor
MYSQL_PORT=3306
CONTAINER_NAME=mysql8_custom

# Configuración de red
NETWORK_NAME=mysql_network

# Configuración de volumen
VOLUME_NAME=mysql_data
```

## Variables de entorno disponibles

### MySQL
- `MYSQL_ROOT_PASSWORD`: Contraseña del usuario root
- `MYSQL_DATABASE`: Nombre de la base de datos inicial
- `MYSQL_USER`: Usuario de aplicación
- `MYSQL_PASSWORD`: Contraseña del usuario de aplicación

### Contenedor
- `MYSQL_PORT`: Puerto a exponer (por defecto 3306)
- `CONTAINER_NAME`: Nombre del contenedor
- `NETWORK_NAME`: Nombre de la red Docker
- `VOLUME_NAME`: Nombre del volumen para datos

## Uso

### Iniciar el contenedor
```bash
docker-compose up -d
```

### Detener el contenedor
```bash
docker-compose down
```

### Ver logs
```bash
docker-compose logs mysql
```

### Conectar a MySQL
```bash
docker exec -it ${CONTAINER_NAME} mysql -u root -p
```

## Personalización

- **Variables de entorno**: Modifica el archivo `.env`
- **Configuración MySQL**: Edita `mysql-config/custom.cnf`

## Seguridad

- Nunca commitees el archivo `.env` con credenciales reales
- El archivo `.env.example` sirve como plantilla
- Usa contraseñas seguras en producción