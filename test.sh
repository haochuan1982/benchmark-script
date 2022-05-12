iclientConfig="iperf-client-config-tpl.yaml"
iserverConfig="iperf-server-config.yaml"
lclientConfig="latency-client-config-tpl.yaml"
lserverConfig="latency-config.yaml"

#protocal="zeromq"
protocal="passthrough"
operator="iperf"
#operator="latency"
#operator="iperf latency"
hosts="vm"
#hosts="localhost"

ilength="512 1K 2K 4K 8K 16K 32K 64K 128K"
llength="16 32 64 128 256 512 1024 2048 8192 16384 32768 65536 131072"

for host in $hosts 
do
	for op in $operator
	do
		if [[ $op == "iperf" ]];
       		then
			client=iperf3Client
			cconfig=$iclientConfig

			server=iperf3Server
			sconfig=$iserverConfig
			length=$ilength
		elif [[ $op == "latency" ]];
		then
			client=latencyClient
			cconfig=$lclientConfig

			server=latencyServer
			sconfig=$lserverConfig
			length=$llength
		fi

		for len in $length
		do
			cfile=${op}-client-config-${len}.yaml
			cp ../examples/${cconfig} ../examples/${cfile}
			sed -i -e "s/LENGTH/${len}/" -e "s/PROTOCAL/${protocal}/" ../examples/${cfile}

			cp ${protocal}/benchmark_${protocal}.yml.${host}.tpl  benchmark_config.yml 
			sed -i -e "s/CLIENT/${client}/" -e  "s/SERVER/${server}/" -e "s/CCONFIG/${cfile}/" -e "s/SCONFIG/${sconfig}/"  benchmark_config.yml

			echo ${protocal} ${op} ${len} ${host}
			echo "##### prepare #####"
			./benchmark prepare -c benchmark_config.yml
			sleep 2

			echo "##### start #####"
			./benchmark start
			sleep 2

			echo "####### stop #####"
			./benchmark stop
			sleep 2

			./benchmark cleanup

			rm -rf ../examples/${cfile}
			rm -rf benchmark_config.yml 
			ps -aux | grep runner | awk '{print $2}' | xargs sudo kill -9
			sleep 2
		done
	done
done
