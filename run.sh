#!/bin/bash
set -e

# Ejecutar el generador de certificados
bash utils/gen_server_cert.sh

# Levantar los contenedores
docker-compose up --build
