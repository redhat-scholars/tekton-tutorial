set -eu

declare CFG=$1
echo "Adapting ${CFG} for suitable in container kubeconfig"

sed -i -e "s#/Users/${MAC_USER}#${HOME}#g" $CFG