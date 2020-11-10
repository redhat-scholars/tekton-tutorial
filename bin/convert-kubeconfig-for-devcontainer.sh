set -eu

declare CFG=$1
echo "Adapting ${CFG} for suitable in container kubeconfig"

sed -i -e "s#127.0.0.1#docker.for.mac.localhost#g" $CFG
sed -i -e "s#/Users/${MAC_USER}#${HOME}#g" $CFG