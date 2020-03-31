#!/usr/bin/fish

set master_email $argv[1]
set global_password 'rtlgn24bgn'

test "$master_email" = ''; and set ENABLE_REGISTER '1' ; or set ENABLE_REGISTER '0'

function echo2
    echo $argv 1>&2
end

function register # prints email on success
    set username "recolic-"(random 10000000 99999999)
    set password $global_password
    set email $username"%40gmail.com"
    set inviteCode $argv[1]
    test "$inviteCode" = '' ; and set inviteCode 0

    echo2 "SUBMIT REGISTER: $email $password with inviteCode $inviteCode"
    curl 'https://hualuows.xyz/auth/register' -H 'accept-encoding: gzip, deflate' --data "email=$email&name=$username&passwd=$password&repasswd=$password&code=$inviteCode" --compressed -s | grep '"ret":1' 1>&2
    or return 1 # failed

    echo $email
end

function login # prints cookie on success
    set email $argv[1]
    set password $global_password
    set tmpfl (mktemp)

    echo2 "SUBMIT LOGIN: $email $password, tmpFile=$tmpfl"
    curl 'https://hualuows.xyz/auth/login' -H 'accept-encoding: gzip, deflate' --compressed --data "email=$email&passwd=$password&code=" -vv > $tmpfl 2>&1
    grep '"ret":1' $tmpfl 1>&2 ; or return 1 # failed

    set cookie (cat $tmpfl | grep set-cookie -i | sed 's|^.*: ||g' | sed 's|; .*$|; |g' | tr -d '\r\n')
    rm -f $tmpfl
    echo $cookie
end

function get_invite_code # prints invite_code on success
    set cookie $argv[1]

    echo2 "GET_INVITE_CODE: cookie=$cookie"
    set invite_code ( curl 'https://hualuows.xyz/user/invite' -H 'accept-encoding: gzip, deflate' --compressed -s --cookie "$cookie" | grep 'data-clipboard-text=' | sed 's|^.*auth/register?code=||g' | sed 's|".*$||g' )
    test $invite_code = '' ; and return 1 # failed

    echo $invite_code
end

function get_ssr_param # prints ssr PASSWORD OBFS_PARAM PROTOCOL_PARAM
    set cookie $argv[1]
    set tmpfl (mktemp)

    echo2 "GETTING_SSR_PARAM: tmpfl=$tmpfl, cookie=$cookie"
    curl 'https://hualuows.xyz/user/node/36?ismu=0&relay_rule=0' -H 'accept-encoding: gzip, deflate' --compressed -s --cookie "$cookie" > $tmpfl
    or return 1 # failed
    set res (./extract_json_from_xingmeng_web.py $tmpfl)
    test $res = '' ; and return 1 # failed

    rm -f $tmpfl
    echo $res
end
    

#############################################

if test $ENABLE_REGISTER = 1
    set master_email (register)
        or exit 2
    echo 'DEBUG: new registered email=' $master_email
else
    echo 'DEBUG: using email=' $master_email
end

set cookie (login $master_email)
    or exit 2
echo 'DEBUG: cookie=' $cookie

set invite_code (get_invite_code $cookie)
    or exit 2
echo 'DEBUG: invite_code=' $invite_code

#############################################

if test $ENABLE_REGISTER = 1
    register $invite_code
else
    echo 'DEBUG: Skipping registering for invite_code.'
end

set show_email (echo "$master_email" | sed 's|%40|@|g')
echo ">>>>> ACCOUNT DONE! Use account=$show_email and password=$global_password"

#############################################

echo 'SSR PASSWORD+OBFS_PARAM+PROTOCOL_PARAM ='
get_ssr_param $cookie
