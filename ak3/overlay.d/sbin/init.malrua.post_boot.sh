#!/system/bin/sh

# Setup readahead
find /sys/devices -name read_ahead_kb | while read node; do echo 128 > $node; done

# Setting b.L scheduler parameters
echo 95 95 > /proc/sys/kernel/sched_upmigrate
echo 85 85 > /proc/sys/kernel/sched_downmigrate

# Remove unused swapfile
rm -f /data/vendor/swap/swapfile 2>/dev/null
sync

# Zram settings
swapoff /dev/block/zram0
echo 1 > /sys/block/zram0/reset
echo lz4 > /sys/block/zram0/comp_algorithm
echo 2G > /sys/block/zram0/disksize
echo 0 > /sys/block/zram0/mem_limit

# Set swappiness reflecting the device's RAM size
RamStr=$(cat /proc/meminfo | grep MemTotal)
RamMB=$((${RamStr:16:8} / 1024))
if [ $RamMB -le 6144 ]; then
  echo 190 > /proc/sys/vm/rswappiness
elif [ $RamMB -le 8192 ]; then
  echo 160 > /proc/sys/vm/rswappiness
else
  echo 130 > /proc/sys/vm/rswappiness
fi
mkswap /dev/block/zram0
swapon /dev/block/zram0

# blkio
echo 2000 > /dev/blkio/blkio.group_idle
echo 0 > /dev/blkio/background/blkio.group_idle
echo 1000 > /dev/blkio/blkio.weight
echo 200 > /dev/blkio/background/blkio.weight

# stune
echo 0 > /dev/stune/schedtune.prefer_idle
echo 0 > /dev/stune/schedtune.boost
echo 1 > /dev/stune/foreground/schedtune.prefer_idle
echo 1 > /dev/stune/top-app/schedtune.prefer_idle
echo 1 > /dev/stune/top-app/schedtune.boost

# UFS powersave
echo 1 > /sys/devices/platform/soc/1d84000.ufshc/clkgate_enable
echo 1 > /sys/devices/platform/soc/1d84000.ufshc/hibern8_on_idle_enable

# lpm_level
echo N > /sys/module/lpm_levels/parameters/sleep_disabled
