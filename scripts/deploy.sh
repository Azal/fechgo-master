#!/bin/bash

# Este script es para recompilar y preparar nuevas dependencias del proyecto
# Se puede ejecutar n veces

[ -f ~/.profile ] && source ~/.profile
set -e
cd /home/ubuntu/fechgo

echo "Updating GIT"
git pull

echo "Preparing fechgo"
mix do deps.get, deps.compile

echo "Preparing fetchgo (assets and phoenix part)"
(cd /home/ubuntu/fechgo/assets && nvm use 5.6 && npm install && node node_modules/brunch/bin/brunch build --production)
(cd /home/ubuntu/fechgo && mix phx.digest)

# echo "Temporal fix for assets (Run from local only)"
# (cd priv/static && rsync -aR * ubuntu@206.189.222.16:/home/ubuntu/fechgo/_build/prod/rel/fechgo/lib/fechgo-0.0.1/priv/static/)

echo "Compiling fetchgo in release mode"
REPLACE_OS_VARS=false mix release --name fechgo --no-tar
# (cd /home/ubuntu/fechgo/_build/ && rsync -aR * "/home/ubuntu/fechgo/_releases/")

echo "Running migrations"
mix ecto.migrate

echo "Restarting app"
if (/home/ubuntu/fechgo/_build/prod/rel/fechgo/bin/fechgo ping) ; then
  /home/ubuntu/fechgo/_build/prod/rel/fechgo/bin/fechgo restart
else
  /home/ubuntu/fechgo/_build/prod/rel/fechgo/bin/fechgo start
fi

echo "Done!"
