#!/bin/bash
# Automatic xingmeng SSR script. It re-register the account and re-start SSR every 1 hour.

ssr_conf=result/sd-tw3.sh

function restart_ssr () {
    ################### xingmeng fucker edition begin
    if [[ _$1 != _0 ]]; then
        ./generate_all.fish || return 3
    fi
    cat "$ssr_conf" | sed 's|^sslocal.*$|& \&|g' > /tmp/tmp.ssr.sh
    [[ $ssr_pid != '' ]] && kill -9 $ssr_pid
    source /tmp/tmp.ssr.sh
    ################### xingmeng fucker edition end
    # sslocal -c "$ssr_conf" &
    ssr_pid=$!
    sleep 1
    ps -p $ssr_pid ; return $?
}

while true; do
    while true; do
        echo 'LOG: Restart ssr...' $(date)
        restart_ssr && break
        echo 'LOG: Failed to restart ssr. Return '$?
        sleep 10
    done
    sleep 57m # xingmeng new account is valid for 1 hour.
done

