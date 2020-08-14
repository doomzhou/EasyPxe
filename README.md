pxe引导winpe[more]
===

把pxe引导winpe整合到一起，通过docker启动




### Usage

0. 镜像下载winpe.iso 放置到 `data/wwwroot/pxefiles/winpe.iso`
 
1. 启动dnsmasq(dncp, tftp), nginx(http) 服务，会首先拉取docker镜像
`./handle.sh all start`
`./handle.sh all status`

2. bios启动改成网卡启动 , 完事


### Misc

1. 不能使用太封闭的路由器，比如华为，小米这样的
原因是dhcp的udp广播会被路由器吃掉，关了防火墙也没用。

2. macpro下测试, dhcp响应包tcpdump的时候 会报 bad udp cksum 0x89c5 -> 0xf74c
这样的话，就需要直接在macpor下安装dnsmasq 然后 `sudo dnsmasq -C dnsmasq.conf -d`

3. 针对自己的windows机器，需要针对主板支持的不同硬盘模式来选择下载winpe镜像。
UEFI等等
