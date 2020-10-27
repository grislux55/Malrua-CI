#!/system/bin/sh

# Readahead boost
find /sys/devices -name read_ahead_kb | while read node; do echo 2048 > $node; done

# Stune boost
echo 1 > /dev/stune/schedtune.prefer_idle
echo 100 > /dev/stune/schedtune.boost

# Replace msm_irqbalance.conf
echo "PRIO=1,1,1,1,0,0,0,0
# arch_timer,arch_mem_timer,arm-pmu,kgsl-3d0,glink_lpass
IGNORED_IRQ=19,38,21,332,188" > /dev/msm_irqbalance.conf
chmod 644 /dev/msm_irqbalance.conf
mount --bind /dev/msm_irqbalance.conf /vendor/etc/msm_irqbalance.conf
chcon "u:object_r:vendor_configs_file:s0" /vendor/etc/msm_irqbalance.conf

killall msm_irqbalance
