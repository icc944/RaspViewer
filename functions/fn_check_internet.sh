fn_check_internet() {
    local is_internet=false
    ping -c 1 www.google.com.mx > /dev/null && is_internet=true || is_internet=false
    echo "$is_internet"
}