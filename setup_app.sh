#!/usr/bin/env bash

# Determine OS
OS="$(uname)"

if [[ $# -eq 2 ]]; then
    module=$1
    app=$2

    mv lib/basic_phx_app lib/"${app}"
    mv lib/basic_phx_app_web lib/"${app}_web"
    mv lib/basic_phx_app.ex lib/"${app}.ex"
    mv lib/basic_phx_app_web.ex lib/"${app}_web.ex"
    mv test/basic_phx_app_web test/"${app}_web"

    if [[ "$OS" == "Darwin" ]]; then
        # MacOS uses BSD sed
        find ./{.gitignore,.envrc-sample,README.md,assets,config,lib,mix.exs,mix.lock,priv,test,./docker-compose.yml} -type f -print0 | xargs -0 sed -i '' "s/BasicPhxApp/${module}/g"
        find ./{.gitignore,.envrc-sample,README.md,assets,config,lib,mix.exs,mix.lock,priv,test,./docker-compose.yml} -type f -print0 | xargs -0 sed -i '' "s/basic_phx_app/${app}/g"
    else
        # Assume Linux uses GNU sed
        find ./{.gitignore,.envrc-sample,README.md,assets,config,lib,mix.exs,mix.lock,priv,test,./docker-compose.yml} -type f -print0 | xargs -0 sed -i "s/BasicPhxApp/${module}/g"
        find ./{.gitignore,.envrc-sample,README.md,assets,config,lib,mix.exs,mix.lock,priv,test,./docker-compose.yml} -type f -print0 | xargs -0 sed -i "s/basic_phx_app/${app}/g"
    fi

    cp .envrc-sample .envrc

    rm -rf _build

    mix deps.get
    mix format
    rm setup_app.sh
else
    echo "Usage: ./setup_app.sh {ModuleName} {app_name}"
    exit 1
fi
