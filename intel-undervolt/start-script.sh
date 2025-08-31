#!/usr/bin/bash
# ---------
systemctl start intel-undervolt-loop.service

#echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
#echo powersave | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor



#timeshift --check
#sudo update-grub
#sudo systemctl restart grub-btrfsd




#echo "20" | tee /sys/devices/system/cpu/intel_pstate/min_perf_pctbl
#echo "31" | tee /sys/devices/system/cpu/intel_pstate/min_perf_pct
#echo "50" | sudo tee /sys/devices/system/cpu/intel_pstate/min_perf_pct



#echo "89" | tee /sys/devices/system/cpu/intel_pstate/max_perf_pct

