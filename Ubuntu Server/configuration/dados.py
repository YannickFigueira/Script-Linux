import json
import os

adicionar_dados = ""

# Dados iniciais

dados_config = {
    "app": {
        "name": "raid_monitor",
        "version": "4.0.0"
    },
    "database": {
        "telegrambot": "",
        "chat_id": ""
    }}

# Diretórios base
dados_dir = "dados"

if os.path.exists("Dados"):
    os.rename("Dados", "Dados.old")
    os.rename("Imagens", "imagens")

if not os.path.exists(dados_dir):
    os.makedirs(dados_dir)

    with open(f"{dados_dir}/config.json", "w", encoding="utf-8") as c:
        json.dump(dados_config, c, indent=4, ensure_ascii=False)

# --- Gravação ---
def gravar_dados(campo, valor):
    with open(f"{dados_dir}/config.json", "r", encoding="utf-8") as f:
        config = json.load(f)
    
    config["database"][campo] = valor

    with open(f"{dados_dir}/config.json", "w", encoding="utf-8") as fw:
        json.dump(config, fw, indent=4, ensure_ascii=False)

def ler_dados(dados):
    with open(f"{dados_dir}/config.json", "r", encoding="utf-8") as d:
        config = json.load(d)

    # Acessando dados
    telegrambot = config["database"]["telegrambot"]
    chat_id = config["database"]["chat_id"]
    
    if dados == "telegrambot":
        return telegrambot
    elif dados == "chat_id":
        return chat_id
    return None


