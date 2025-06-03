#!/bin/bash
set -e
cd ..

if [ -z "$1" ]; then
  echo "Debes especificar el nombre del usuario. Ej: ./gen_client_cert.sh usuario1"
  exit 1
fi

USERNAME=$1
CERT_DIR=certs/$USERNAME
mkdir -p $CERT_DIR

echo "Generando clave privada para el cliente '$USERNAME'..."
openssl genrsa -out $CERT_DIR/${USERNAME}.key 2048

echo "Generando CSR..."
openssl req -new -key $CERT_DIR/${USERNAME}.key \
  -subj "/CN=${USERNAME}" \
  -out $CERT_DIR/${USERNAME}.csr

echo "Firmando certificado cliente con la CA..."
openssl x509 -req -in $CERT_DIR/${USERNAME}.csr \
  -CA certs/ca.pem -CAkey private/ca.key -CAcreateserial \
  -out $CERT_DIR/${USERNAME}.crt -days 365 -sha256

# Limpieza
rm $CERT_DIR/${USERNAME}.csr

echo ""
echo "Certificado generado correctamente:"
echo "  - $CERT_DIR/${USERNAME}.key   ← Clave privada"
echo "  - $CERT_DIR/${USERNAME}.crt   ← Certificado firmado"
echo "  - certs/ca.pem                ← CA pública (necesaria para conexión)"
echo ""
echo "Puedes probarlo con:"
echo "curl -v https://localhost:8443/ --key $CERT_DIR/${USERNAME}.key --cert $CERT_DIR/${USERNAME}.crt --cacert certs/ca.pem"
