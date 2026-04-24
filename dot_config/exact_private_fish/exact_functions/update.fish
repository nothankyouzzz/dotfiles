function update
  sudo snap refresh

  sudo apt update
  and sudo apt full-upgrade -y
  and sudo apt autoremove -y

  bun upgrade
  and bun update --global --latest
end
