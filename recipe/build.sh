#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

# Create package archive and install globally
npm pack --ignore-scripts
npm install -ddd \
    --no-bin-links \
    --global \
    --build-from-source \
    ${SRC_DIR}/${PKG_NAME}-${PKG_NAME}-${PKG_VERSION}.tgz

# Create license report for dependencies
pnpm install
pnpm-licenses generate-disclaimer --prod --output-file=third-party-licenses.txt

mkdir -p ${PREFIX}/bin
tee ${PREFIX}/bin/dotenvx << EOF
#!/bin/sh
exec \${CONDA_PREFIX}/lib/node_modules/@dotenvx/dotenvx/src/cli/dotenvx.js "\$@"
EOF
chmod +x ${PREFIX}/bin/dotenvx

tee ${PREFIX}/bin/git-dotenvx << EOF
#!/bin/sh
exec \${CONDA_PREFIX}/lib/node_modules/@dotenvx/dotenvx/src/cli/dotenvx.js "\$@"
EOF
chmod +x ${PREFIX}/bin/git-dotenvx

tee ${PREFIX}/bin/dotenvx.cmd << EOF
call %CONDA_PREFIX%\bin\node %CONDA_PREFIX%\lib\node_modules\@dotenvx\dotenvx\src\cli\dotenvx.js %*
EOF

tee ${PREFIX}/bin/git-dotenvx.cmd << EOF
call %CONDA_PREFIX%\bin\node %CONDA_PREFIX%\lib\node_modules\@dotenvx\dotenvx\src\cli\dotenvx.js %*
EOF
