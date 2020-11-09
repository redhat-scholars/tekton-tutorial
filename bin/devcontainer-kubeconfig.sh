set -eu

sed -i.bak -e "s#127.0.0.1#docker.for.mac.localhost#g" ~/.kube/config
sed -i.bak -e "s#/Users/${MAC_USER}#..#g" ~/.kube/config