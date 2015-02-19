proc avnet_generate_ip {ip_name} {
   source ../IP/$ip_name/$ip_name.tcl -notrace
   cd ../IP/$ip_name
   make_ip $ip_name
   cd ../../Scripts
}