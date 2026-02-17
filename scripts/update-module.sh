#!/bin/bash
# =============================================================================
# Script para atualizar módulo(s) específico(s) do Odoo
# Uso: ./scripts/update-module.sh <nome_banco> <modulo1> [modulo2] [modulo3]...
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
if [ $# -lt 2 ]; then
    echo -e "${RED}Uso: $0 <nome_banco> <modulo1> [modulo2] [modulo3]...${NC}"
    echo -e "${YELLOW}Exemplo: $0 odoo_dev sale,purchase,stock${NC}"
    exit 1
fi

DATABASE=$1
shift
MODULES=$(IFS=,; echo "$*")

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}     Atualizando Módulos Odoo          ${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "${YELLOW}Banco: ${CYAN}${DATABASE}${NC}"
echo -e "${YELLOW}Módulos: ${CYAN}${MODULES}${NC}"
echo ""

# Ativar ambiente virtual
if [ -d "$VENV_DIR" ]; then
    source "${VENV_DIR}/bin/activate"
else
    echo -e "${RED}Ambiente virtual não encontrado!${NC}"
    exit 1
fi

cd "$ODOO_DIR"
python odoo-bin -c "$CONFIG_FILE" -d "$DATABASE" -u "$MODULES" --stop-after-init

echo ""
echo -e "${GREEN}Atualização concluída!${NC}"
