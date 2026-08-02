# Eliminar versiones antiguas si existen
sudo apt remove -y docker docker-engine docker.io containerd runc

# Crear directorio para claves
sudo install -m 0755 -d /etc/apt/keyrings

# Descargar la clave
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Permisos
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Añadir repositorio
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo $VERSION_CODENAME) stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Actualizar índices
sudo apt update

# Instalar Docker
sudo apt install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

# Añadir usuario al grupo docker
sudo usermod -aG docker $USER

# Reiniciar sesión (o reiniciar la máquina)