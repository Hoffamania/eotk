#!/bin/sh -x

# platform-independent lib.sh
cd `dirname $0` || exit 1
opt_dir=`pwd`
. ./lib.sh || exit 1

# platform dependencies
shared_deps="
curl
dirmngr
gcc
libevent-devel
openssl-devel
pcre-devel
"
# i wonder if i need to pare this down to something more minimalist?
sudo yum -y groupinstall 'Development Tools'
sudo yum -y install --best --allowerasing $shared_deps || exit 1

## Try adding tor keys before errors during build.
gpg --refresh-keys EF6E286DDA85EA2A4BA7DE684E2C6E8793298290

# build openresty
SetupOpenRestyVars || exit 1
CustomiseVars || exit 1
SetupForBuild || exit 1
ConfigureOpenResty || exit 1
BuildAndCleanup || exit 1

# build tor
SetupTorVars || exit 1
CustomiseVars || exit 1
SetupForBuild || exit 1
ConfigureTor || exit 1
BuildAndCleanup || exit 1

# done
exit 0
