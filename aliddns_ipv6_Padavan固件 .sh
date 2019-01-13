# 自行测试哪个代码能获取正确的IP，删除前面的#可生效
arIpAddress () {
# IPv4地址获取
# 获得外网地址
curltest=`which curl`
if [ -z "$curltest" ] || [ ! -s "`which curl`" ] ; then
    wget --no-check-certificate --quiet --output-document=- "https://www.ipip.net" | grep "IP地址" | grep -E -o '([0-9]+\.){3}[0-9]+'
    #wget --no-check-certificate --quiet --output-document=- "http://members.3322.org/dyndns/getip" | grep -E -o '([0-9]+\.){3}[0-9]+'
    #wget --no-check-certificate --quiet --output-document=- "ip.6655.com/ip.aspx" | grep -E -o '([0-9]+\.){3}[0-9]+'
    #wget --no-check-certificate --quiet --output-document=- "ip.3322.net" | grep -E -o '([0-9]+\.){3}[0-9]+'
else
    curl -L -k -s "https://www.ipip.net" | grep "IP地址" | grep -E -o '([0-9]+\.){3}[0-9]+'
    #curl -k -s "http://members.3322.org/dyndns/getip" | grep -E -o '([0-9]+\.){3}[0-9]+'
    #curl -k -s ip.6655.com/ip.aspx | grep -E -o '([0-9]+\.){3}[0-9]+'
    #curl -k -s ip.3322.net | grep -E -o '([0-9]+\.){3}[0-9]+'
fi
}
arIpAddress6 () {
# IPv6地址获取
# 因为一般ipv6没有nat ipv6的获得可以本机获得
#ifconfig $(nvram get wan0_ifname_t) | awk '/Global/{print $3}' | awk -F/ '{print $1}'
# wan0_ifname_t为虚拟ipv6地址  br0_ifname_t为实际ipv6公网地址 cut -d ':' -f 1,2,3,4  是获取路由器ipv6地址的前64位
ifconfig $(nvram get br0_ifname_t) | awk '/Global/{print $3}' | awk -F/ '{print $1}'|cut -d ':' -f 1,2,3,4     
}

# 需要DDNS的主机ipv6后64位 -------此处需要修改 其他无视-------
Host_ipv6=:1111:2222:3333:4444


# 路由器重新拨号获取的ipv6前64位
Router_arIpAddress6=$(echo $(arIpAddress6) |cut -d ' ' -f 1)
#Router_arIpAddress6=$(arIpAddress6)
# 直接通过路由器命令获取的ipv6前64可能是类型不同不能直接和主机ipv6拼接一起需要处理一下
len=$(echo ${Router_arIpAddress6} |wc -L)
Router_ipv6=${Router_arIpAddress6:0:${len}}
# 将处理后的路由器ipv6前64位和需要DDNS的ipv6主机后64位拼接一起
ipv6_16B=${Router_ipv6}${Host_ipv6}

if [ "$IPv6" = "1" ] ; then
arIpAddress=${ipv6_16B}
else
arIpAddress=$(arIpAddress)
fi

#version 1.4
#Date 2018.12.29


