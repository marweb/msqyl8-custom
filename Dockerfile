FROM mysql:8.0

# Copiar archivo de configuración personalizado
COPY mysql-config/custom.cnf /etc/mysql/conf.d/

# Exponer puerto 3306
EXPOSE 3306