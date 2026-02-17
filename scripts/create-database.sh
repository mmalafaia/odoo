#!/bin/bash
# =============================================================================
# Script para criar um novo banco de dados Odoo
# Uso: ./scripts/create-database.sh <nome_banco> [idioma]
# =============================================================================

ODOO_DIR="/home/vanguard/Documentos/GitHub/odoo"
CONFIG_FILE="${ODOO_DIR}/odoo.conf"
VENV_DIR="${ODOO_DIR}/venv"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Verificar argumentos
if [ $# -lt 1 ]; then
    echo -e "${RED}Uso: $0 <nome_banco> [idioma]${NC}"
    echo -e "${YELLOW}Exemplo: $0 odoo_dev pt_BR${NC}"
    exit 1
fi

DATABASE=$1
LANGUAGE=${2:-"pt_BR"}

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}   Criando Banco de Dados Odoo         ${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "${YELLOW}Banco: ${CYAN}${DATABASE}${NC}"
echo -e "${YELLOW}Idioma: ${CYAN}${LANGUAGE}${NC}"
echo ""

# Ativar ambiente virtual
if [ -d "$VENV_DIR" ]; then
    source "${VENV_DIR}/bin/activate"
else
    echo -e "${RED}Ambiente virtual não encontrado!${NC}"
    exit 1
fi

cd "$ODOO_DIR"

# Inicializar banco de dados com módulo base
python odoo-bin -c "$CONFIG_FILE" \
    -d "$DATABASE" \
    -i base \
    --load-language="$LANGUAGE" \
    --stop-after-init \
    --without-demo=all

echo ""
echo -e "${GREEN}Banco de dados ${DATABASE} criado com sucesso!${NC}"
echo -e "${YELLOW}Acesse http://localhost:8069 e selecione o banco ${DATABASE}${NC}"
