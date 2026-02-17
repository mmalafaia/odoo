#!/bin/bash
# =============================================================================
# Script para iniciar o Odoo
# =============================================================================

ODOO_DIR="/home/vanguard/Documentos/GitHub/odoo"
CONFIG_FILE="${ODOO_DIR}/odoo.conf"
VENV_DIR="${ODOO_DIR}/venv"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}       Iniciando Odoo Server           ${NC}"
echo -e "${GREEN}========================================${NC}"

# Verificar se o ambiente virtual existe
if [ -d "$VENV_DIR" ]; then
    echo -e "${YELLOW}Ativando ambiente virtual...${NC}"
    source "${VENV_DIR}/bin/activate"
else
    echo -e "${RED}Ambiente virtual não encontrado em ${VENV_DIR}${NC}"
    echo -e "${YELLOW}Execute primeiro: ./scripts/setup-venv.sh${NC}"
    exit 1
fi

# Verificar se o arquivo de configuração existe
if [ ! -f "$CONFIG_FILE" ]; then
    echo -e "${RED}Arquivo de configuração não encontrado: ${CONFIG_FILE}${NC}"
    exit 1
fi

# Verificar se o PostgreSQL está rodando
if ! pg_isready -q 2>/dev/null; then
    echo -e "${YELLOW}PostgreSQL não está respondendo. Tentando iniciar...${NC}"
    sudo systemctl start postgresql
    sleep 2
fi

echo -e "${GREEN}Iniciando Odoo na porta 8069...${NC}"
echo -e "${YELLOW}Acesse: http://localhost:8069${NC}"
echo ""

cd "$ODOO_DIR"
python odoo-bin -c "$CONFIG_FILE" "$@"
