#!/bin/bash
set -e

# Carpetas
cd ..
mkdir -p certs
mkdir -p private
cd private

echo "Generando CA (Autoridad Certificadora)..."
# Clave privada de la CA
openssl genrsa -out ca.key 4096

# Certificado público de la CA (autofirmado)
openssl req -x509 -new -nodes -key ca.key -sha256 -days 3650 \
  -subj "/CN=MyCA" \
  -out ca.pem

echo "Generando clave privada del servidor..."
openssl genrsa -out server.key 4096

echo "Generando CSR del servidor..."
openssl req -new -key server.key -out server.csr \
  -subj "/CN=localhost"

echo "Firmando certificado del servidor con la CA..."
openssl x509 -req -in server.csr -CA ca.pem -CAkey ca.key -CAcreateserial \
  -out server.crt -days 365 -sha256

# Mover la CA a la carpeta pública
mv ca.pem ../certs/

# Limpieza
rm server.csr

echo "Certificados generados correctamente:"
echo "  - certs/ca.pem          ← CA pública"
echo "  - private/ca.key        ← CA privada (protéjela)"
echo "  - private/server.crt    ← Certificado del servidor"
echo "  - private/server.key    ← Clave privada del servidor"
