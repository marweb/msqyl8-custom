# Configuración MySQL 8

Este directorio contiene la configuración personalizada para MySQL 8.0.

## Archivos

- `custom.cnf` - Archivo de configuración principal de MySQL

## Explicación de Configuraciones

### [mysqld] - Configuración del Servidor

#### Modo SQL
```ini
sql_mode = NO_ENGINE_SUBSTITUTION
```
**Propósito**: Desactiva la sustitución automática de motores de almacenamiento.
**Explicación**: Evita que MySQL cambie automáticamente el motor si el especificado no está disponible, manteniendo consistencia en el comportamiento.

#### Autenticación y Caracteres
```ini
default-authentication-plugin = mysql_native_password
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci
```
- **default-authentication-plugin**: Usa el método tradicional de contraseñas, necesario para compatibilidad con aplicaciones más antiguas
- **character-set-server**: Soporte completo para Unicode, utf8mb4 soporta emojis y caracteres especiales (4 bytes por carácter)
- **collation-server**: Define cómo se ordenan y comparan los caracteres, unicode_ci = case insensitive, soporta múltiples idiomas correctamente

#### Configuraciones de Rendimiento InnoDB
```ini
innodb_buffer_pool_size = 512M
innodb_log_file_size = 128M
innodb_log_buffer_size = 16M
innodb_flush_log_at_trx_commit = 2
innodb_flush_method = O_DIRECT
```
- **innodb_buffer_pool_size**: Memoria para cachear datos y índices. 512M es adecuado para sistemas con 2-4GB RAM (usar 70-80% de RAM disponible)
- **innodb_log_file_size**: Tamaño de cada archivo de log para transacciones y recuperación. 128M permite manejar transacciones grandes sin problemas
- **innodb_log_buffer_size**: Buffer de log en memoria antes de escribir a disco. 16M reduce la frecuencia de escrituras mejorando rendimiento
- **innodb_flush_log_at_trx_commit**: Frecuencia de sincronización del log de transacciones
  - `2` = escribe cada segundo (balance entre rendimiento y seguridad)
  - `1` = más seguro pero más lento
  - `0` = más rápido pero menos seguro
- **innodb_flush_method**: O_DIRECT evita el doble buffering del sistema operativo, mejora rendimiento

#### Gestión de Conexiones
```ini
max_connections = 100
thread_cache_size = 10
```
- **max_connections**: Número máximo de conexiones simultáneas. 100 es suficiente para aplicaciones pequeñas a medianas
- **thread_cache_size**: Hilos de conexión mantenidos en caché. 10 hilos reutilizables reducen el overhead de crear/destruir conexiones

#### Configuraciones de Tablas y Memoria
```ini
table_open_cache = 2000
tmp_table_size = 64M
max_heap_table_size = 64M
```
- **table_open_cache**: Número de tablas que pueden estar abiertas simultáneamente. 2000 permite manejar aplicaciones con muchas tablas
- **tmp_table_size**: Tamaño máximo de tablas temporales en memoria antes de escribir a disco. Mejora rendimiento de consultas complejas
- **max_heap_table_size**: Tamaño máximo de tablas MEMORY/HEAP. Debe coincidir con tmp_table_size para consistencia

#### Buffers para Consultas Complejas
```ini
sort_buffer_size = 2M
read_buffer_size = 128K
read_rnd_buffer_size = 256K
```
- **sort_buffer_size**: Buffer para operaciones de ordenamiento (ORDER BY, GROUP BY). 2M por conexión es suficiente para la mayoría de consultas
- **read_buffer_size**: Buffer para lecturas secuenciales de tablas. 128K es un buen balance entre memoria y rendimiento para escaneos
- **read_rnd_buffer_size**: Buffer para lecturas aleatorias cuando se usan índices. 256K mejora el rendimiento de consultas que usan índices para ordenar

### [mysql] y [client] - Configuración de Clientes

```ini
[mysql]
default-character-set = utf8mb4

[client]
default-character-set = utf8mb4
```
- **[mysql]**: Configuración específica para el cliente de línea de comandos mysql
- **[client]**: Configuración para todos los clientes MySQL (mysql, mysqldump, etc.)
- Ambos aseguran que todos los clientes usen utf8mb4 por defecto, manteniendo consistencia con la configuración del servidor

## Recomendaciones de Uso

### Ajustes según el Hardware
- **Sistemas con más RAM**: Aumentar `innodb_buffer_pool_size` hasta 70-80% de la RAM disponible
- **Aplicaciones con muchas conexiones**: Incrementar `max_connections` y `thread_cache_size`
- **Consultas complejas frecuentes**: Aumentar los buffers de sort y read

### Monitoreo
- Revisar el uso de memoria con `SHOW ENGINE INNODB STATUS`
- Monitorear conexiones activas con `SHOW PROCESSLIST`
- Verificar el hit ratio del buffer pool para optimizar su tamaño

### Seguridad vs Rendimiento
- Para máxima seguridad: `innodb_flush_log_at_trx_commit = 1`
- Para máximo rendimiento: `innodb_flush_log_at_trx_commit = 0`
- Balance recomendado: `innodb_flush_log_at_trx_commit = 2` (configuración actual)