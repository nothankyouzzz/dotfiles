function update
  sudo snap refresh
  sudo apt update
  sudo apt full-upgrade
  sudo apt autoremove
  sudo npm install -g @openai/codex
  sudo npm install -g @github/copilot
  sudo npm install -g @google/gemini-cli
end
