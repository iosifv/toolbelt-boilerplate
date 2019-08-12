docker build -t "toolbelt:latest" \
    --build-arg ssh_private_key="$(cat ~/.ssh/id_rsa)" \
    --build-arg ssh_public_key="$(cat ~/.ssh/id_rsa.pub)" \
    .
