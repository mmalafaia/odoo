#!/bin/bash
# =============================================================================
# Script para criar e configurar ambiente virtual do Odoo
# =============================================================================

set -e  # Parar ao primeiro erro

ODOO_DIR="/home/vanguard/Documentos/GitHub/odoo"
VENV_DIR="${ODOO_DIR}/venv"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Configurando Ambiente Virtual Odoo   ${NC}"
echo -e "${GREEN}========================================${NC}"

# Verificar dependências do sistema
echo -e "${YELLOW}Verificando dependências do sistema...${NC}"

MISSING_DEPS=""
if ! dpkg -l | grep -q "libpq-dev"; then
    MISSING_DEPS="$MISSING_DEPS libpq-dev"
fi
if ! dpkg -l | grep -q "python3-dev"; then
    MISSING_DEPS="$MISSING_DEPS python3-dev"
fi
if ! dpkg -l | grep -q "build-essential"; then
    MISSING_DEPS="$MISSING_DEPS build-essential"
fi
if ! dpkg -l | grep -q "python3.*-venv"; then
    MISSING_DEPS="$MISSING_DEPS python3-venv"
fi

if [ -n "$MISSING_DEPS" ]; then
    echo -e "${RED}Dependências do sistema faltando:${MISSING_DEPS}${NC}"
    echo -e "${YELLOW}Execute o seguinte comando e depois rode este script novamente:${NC}"
    echo -e "${CYAN}sudo apt install -y${MISSING_DEPS}${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Todas as dependências do sistema estão instaladas${NC}"

# Verificar Python
PYTHON_BIN=$(which python3.12 || which python3.11 || which python3.10 || which python3)
if [ -z "$PYTHON_BIN" ]; then
    echo -e "${RED}Python 3 não encontrado!${NC}"
    exit 1
fi

PYTHON_VERSION=$($PYTHON_BIN --version)
echo -e "${YELLOW}Usando: ${PYTHON_VERSION}${NC}"

# Criar ambiente virtual se não existir
if [ -d "$VENV_DIR" ]; then
    echo -e "${YELLOW}Ambiente virtual já existe em ${VENV_DIR}${NC}"
    read -p "Deseja recriar? (s/N): " RECREATE
    if [[ "$RECREATE" =~ ^[Ss]$ ]]; then
        rm -rf "$VENV_DIR"
    else
        echo -e "${GREEN}Mantendo ambiente existente.${NC}"
        exit 0
    fi
fi

echo -e "${YELLOW}Criando ambiente virtual...${NC}"
$PYTHON_BIN -m venv "$VENV_DIR"

# Verificar se o ambiente foi criado corretamente
if [ ! -f "${VENV_DIR}/bin/activate" ]; then
    echo -e "${RED}Falha ao criar ambiente virtual!${NC}"
    exit 1
fi

# Ativar ambiente
source "${VENV_DIR}/bin/activate"

# Atualizar pip
echo -e "${YELLOW}Atualizando pip...${NC}"
pip install --upgrade pip wheel setuptools

# Instalar dependências do Odoo
echo -e "${YELLOW}Instalando dependências do Odoo...${NC}"
if ! pip install -r "${ODOO_DIR}/requirements.txt"; then
    echo -e "${RED}Erro ao instalar dependências. Verifique os logs acima.${NC}"
    exit 1
fi

# Dependências extras úteis para desenvolvimento
echo -e "${YELLOW}Instalando ferramentas extras de desenvolvimento...${NC}"
pip install ipython debugpy pylint-odoo

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Ambiente configurado com sucesso!    ${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "Para ativar o ambiente manualmente:"
echo -e "  ${CYAN}source ${VENV_DIR}/bin/activate${NC}"
echo ""
