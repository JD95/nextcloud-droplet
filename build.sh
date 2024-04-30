trap cleanup INT

function cleanup() {
  rm -r secrets
}

rm -r secrets 2> /dev/null
mkdir secrets
sops -d --extract '["nextcloud-password"]' vault.yaml > ./secrets/nextcloud-admin-pass
sops -d --extract '["server-password"]' vault.yaml | mkpasswd -s > ./secrets/server-pass
sops -d --extract '["config"]'   vault.yaml > ./secrets/nextcloud-secrets.json
nixos-generate -f 'do' --flake .
cleanup
