#!/bin/bash

module=$1
action=$2

dnsmasq_name="pxe_dnsmasq"
nginx_name="pxe_nginx"

usage() {
    echo "Usage: $0 {nginx|dnsmasq} {start|stop|status|restart}"
    exit 1;
}

if [ $# -lt 1 ]; then
    usage
fi

nginx_start(){
    docker run --rm -p 80:80 -v /Users/sino/tmp/pxe/data:/data -v /Users/sino/tmp/pxe/nginx/nginx.conf:/etc/nginx/nginx.conf --name $nginx_name -dt nginx
}
nginx_status() {
    docker ps -a | grep -E "(pxe_nginx)"
}

nginx_stop() {
    docker stop  $nginx_name
}

dnsmasq_start(){
    docker run --rm -p 67:67/udp -p 69:69/udp -p 8080:8080 -v /Users/sino/tmp/pxe/data:/data -v /Users/sino/tmp/pxe/dnsmasq/dnsmasq.conf:/etc/dnsmasq.conf --name $dnsmasq_name -dt jpillora/dnsmasq
    #docker run --rm -p 69:69/udp -p 8080:8080 -v /Users/sino/tmp/pxe/data:/data -v /Users/sino/tmp/pxe/dnsmasq/dnsmasq.conf:/etc/dnsmasq.conf --name $dnsmasq_name -dt jpillora/dnsmasq
}

dnsmasq_status() {
    docker ps -a | grep -E "(pxe_dnsmasq)"
}

dnsmasq_stop() {
    docker stop  $dnsmasq_name
}

all_start(){
    nginx_start
    dnsmasq_start
}

all_status() {
    docker ps -a | grep -E "(pxe_dnsmasq|pxe_nginx)"
}
all_stop() {
    docker stop $dnsmasq_name $nginx_name
}

case "$module-$action" in
    all-start)
        all_start
        ;;
    all-stop)
        all_stop
        ;;
    all-status)
        all_status
        ;;
    nginx-start)
        nginx_start
        ;;
    nginx-status)
        nginx_status
        ;;
    nginx-stop)
        nginx_stop
        ;;
    dnsmasq-start)
        dnsmasq_start
        ;;
    dnsmasq-status)
        dnsmasq_status
        ;;
    dnsmasq-stop)
        dnsmasq_stop
        ;;
    all-restart)
        all_stop
        all_start
        ;;
    *)
        usage
        ;;
esac
