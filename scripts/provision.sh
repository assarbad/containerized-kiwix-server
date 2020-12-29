#!/bin/bash
VERSION=3.1.2-4
MACHINE=$(uname -m)

# Install kiwix-tools
wget https://download.kiwix.org/release/kiwix-tools/kiwix-tools_linux-${MACHINE}-${VERSION}.tar.gz
tar -xvzf kiwix-tools_linux-${MACHINE}-${VERSION}.tar.gz -C ./bin --strip-components 1
