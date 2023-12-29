#!/usr/bin/env bash

# Determine OS
OS="$(uname)"

if [[ $# -eq 2 ]]; then
    module=$1
    app=$2

    rm -rf _build
    rm -rf .elixir_ls

    mv lib/basic_phx_app lib/"${app}"
    mv lib/basic_phx_app_web lib/"${app}_web"
    mv lib/basic_phx_app.ex lib/"${app}.ex"
    mv lib/basic_phx_app_web.ex lib/"${app}_web.ex"
    mv test/basic_phx_app_web test/"${app}_web"

    if [[ "$OS" == "Darwin" ]]; then
        # MacOS uses BSD sed
        find . -type f -not -path './.git/*' -print0 | xargs -0 sed -i '' "s/BasicPhxApp/${module}/g"
        find . -type f -not -path './.git/*' -print0 | xargs -0 sed -i '' "s/basic_phx_app/${app}/g"
    else
        # Assume Linux uses GNU sed
        find . -type f -not -path './.git/*' -print0 | xargs -0 sed -i "s/BasicPhxApp/${module}/g"
        find . -type f -not -path './.git/*' -print0 | xargs -0 sed -i "s/basic_phx_app/${app}/g"
    fi

    cp .envrc-sample .envrc
    direnv allow

    mix do deps.get deps.compile format
    rm setup_app.sh
else
    echo "Usage: ./setup_app.sh {ModuleName} {app_name}"
    exit 1
fi
