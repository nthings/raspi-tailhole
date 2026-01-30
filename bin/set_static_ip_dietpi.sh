#!/bin/bash
set -e

echo "###########################################"
echo "#     Set static IP (DietPi Native)       #"
echo "###########################################"

# 1. Encontrar interfaz activa (excluyendo virtuales)
for iface in $(ls /sys/class/net/); do
  if [ "$iface" != "lo" ] && [[ ! "$iface" =~ ^(docker|veth|br-|virbr|tailscale|wg) ]]; then
    ip_data=$(ip -4 addr show "$iface" | awk '/inet / {print $2}')
    if [ -n "$ip_data" ]; then
      interface_found=$iface
      ip=$(echo "$ip_data" | cut -d/ -f1)
      mask_bits=$(echo "$ip_data" | cut -d/ -f2)
      break
    fi
  fi
done

if [ -z "$interface_found" ]; then
  echo "Error: No se encontró interfaz activa."
  exit 1
fi

# 2. Detectar Gateway y DNS
gateway_ip=$(ip route show dev "$interface_found" | grep default | awk '{print $3}' | head -n 1)
dns_ip=$(awk '/nameserver/ {print $2}' /etc/resolv.conf | head -n 1)
[ -z "$dns_ip" ] && dns_ip="1.1.1.1"

# 3. Calcular máscara de subred (de CIDR a Decimal)
# La mayoría de redes locales son /24 (255.255.255.0)
if [ "$mask_bits" -eq 24 ]; then netmask="255.255.255.0"; else netmask="255.255.255.0"; fi

echo "Configurando $interface_found con IP: $ip..."

# 4. Modificar el archivo de interfaces de DietPi
# Hacemos backup por seguridad
sudo cp /etc/network/interfaces /etc/network/interfaces.bak

# Escribir la nueva configuración
cat <<EOF | sudo tee /etc/network/interfaces
auto lo
iface lo inet loopback

auto $interface_found
iface $interface_found inet static
    address $ip
    netmask $netmask
    gateway $gateway_ip
    dns-nameservers $dns_ip
EOF

echo "Reiniciando red..."
sudo ifdown "$interface_found" && sudo ifup "$interface_found"

echo "¡Listo! IP Estática configurada en DietPi."
