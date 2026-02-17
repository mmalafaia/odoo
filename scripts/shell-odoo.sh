#!/bin/bash
# =============================================================================
# Script para abrir o shell interativo do Odoo
# Uso: ./scripts/shell-odoo.sh <nome_banco>
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
    echo -e "${RED}Uso: $0 <nome_banco>${NC}"
    echo -e "${YELLOW}Exemplo: $0 odoo_dev${NC}"
    exit 1
fi

DATABASE=$1

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}      Odoo Interactive Shell           ${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "${YELLOW}Banco: ${CYAN}${DATABASE}${NC}"
echo ""
echo -e "${YELLOW}Variáveis disponíveis:${NC}"
echo -e "  ${CYAN}env${NC}    - Odoo Environment"
echo -e "  ${CYAN}self${NC}   - Current record"
echo ""

# Ativar ambiente virtual
if [ -d "$VENV_DIR" ]; then
    source "${VENV_DIR}/bin/activate"
else
    echo -e "${RED}Ambiente virtual não encontrado!${NC}"
    exit 1
fi

cd "$ODOO_DIR"
python odoo-bin shell -c "$CONFIG_FILE" -d "$DATABASE"
