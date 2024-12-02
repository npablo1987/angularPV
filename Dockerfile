# Etapa 1: Construcción
FROM alpine:3.19 AS build

# Instalar dependencias necesarias
RUN apk update && \
    apk add --no-cache nodejs npm git python3 make g++ bash

# Establecer el directorio de trabajo
WORKDIR /app

# Clonar el repositorio
RUN git clone https://git.produccion.svc.indap.cl/pvilches/ProyectoAngularPruebas.git .

# Instalar dependencias
RUN npm install

# Construir la aplicación Angular
RUN npm run build --prod

# Etapa 2: Servidor Nginx
FROM nginx:alpine

# Copiar archivos construidos al directorio de Nginx
COPY --from=build /app/dist/ProyectoAngularPruebas/ /usr/share/nginx/html

# Copiar configuración de Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Exponer el puerto 80
EXPOSE 80

# Comando para iniciar Nginx
CMD ["nginx", "-g", "daemon off;"]
