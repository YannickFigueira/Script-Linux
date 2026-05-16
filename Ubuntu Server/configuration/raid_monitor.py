import dados
import time
import asyncio
from telegram import Bot

# --- CONFIGURAÇÕES ---
TOKEN = dados.ler_dados('telegrambot')
CHAT_ID = dados.ler_dados('chat_id')
ARRAY_NAME = "md0"
CHECK_INTERVAL = 300

# Inicializa o Bot
bot = Bot(token=TOKEN)

async def send_telegram_msg(text):
    try:
        # O método send_message é assíncrono nas versões recentes da biblioteca
        await bot.send_message(chat_id=CHAT_ID, text=text, parse_mode="Markdown")
        return True
    except Exception as e:
        print(f"Erro ao enviar Telegram: {e}")
        return False

def check_raid():
    try:
        with open("/proc/mdstat", "r") as f:
            content = f.read()

        if ARRAY_NAME not in content:
            return f"🚨 *ALERTA*: Array {ARRAY_NAME} não encontrado!"

        if "_" in content:
            return f"⚠️ *ALERTA*: RAID {ARRAY_NAME} DEGRADADO!"

        return None
    except Exception as e:
        return f"❌ *ERRO*: Falha ao ler /proc/mdstat: {e}"

async def main():
    print(f"🚀 Monitor iniciado (Usando Telegram Bot Lib)...")
    last_status_was_ok = True

    while True:
        alert_msg = check_raid()

        if alert_msg:
            if last_status_was_ok:
                print(f"Enviando alerta: {alert_msg}")
                success = await send_telegram_msg(alert_msg)
                if success:
                    last_status_was_ok = False
        else:
            if not last_status_was_ok:
                await send_telegram_msg(f"✅ *RAID NORMALIZADO*: {ARRAY_NAME} saudável.")
                last_status_was_ok = True
            print("Status OK")

        await asyncio.sleep(CHECK_INTERVAL)

if __name__ == "__main__":
    asyncio.run(main())