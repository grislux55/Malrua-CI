# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

# set up working directory variables
test "$home" || home=$PWD;
bootimg=$home/boot.img;
bin=$home/tools;
patch=$home/patch;
ramdisk=$home/ramdisk;
split_img=$home/split_img;

## AnyKernel setup
eval $(cat $home/props | grep -v '\.')

## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. tools/ak3-core.sh;

## Select the correct image to flash
hotdog="$(grep -wom 1 hotdog*.* /system/build.prop | sed 's/.....$//')";
guacamole="$(grep -wom 1 guacamole*.* /system/build.prop | sed 's/.....$//')";
userflavor="$(file_getprop /system/build.prop "ro.build.user"):$(file_getprop /system/build.prop "ro.build.flavor")";
userflavor2="$(file_getprop2 /system/build.prop "ro.build.user"):$(file_getprop2 /system/build.prop "ro.build.flavor")";
if [ "$userflavor" == "jenkins:$hotdog-user" ] || [ "$userflavor2" == "jenkins:$guacamole-user" ]; then
  os="stock";
  os_string="OxygenOS/HydrogenOS";
else
  os="custom";
  os_string="a custom ROM";
fi;
ui_print " " "You are on $os_string!";

if [ -f $home/imgs/Image.gz ] && [ -f $home/imgs/dtb ]; then
  mv $home/imgs/Image.gz $home/Image.gz;
  mv $home/imgs/dtb $home/dtb;
else
  ui_print " " "There is no file for your OS in this zip! Aborting...";
  exit 1;
fi

if [ $os == "custom" ]; then
  mv $home/Image.gz $home/Image.gz-dtb;
  cat $home/dtb >> $home/Image.gz-dtb;
  rm $home/dtb;
fi

install() {
  ## AnyKernel install
  dump_boot;

  # Clean up existing ramdisk overlays
  rm -rf $ramdisk/overlay;
  rm -rf $ramdisk/overlay.d;

  # Use the provided dtb
  if [ -f $home/dtb ]; then
    mv $home/dtb $home/split_img/;
  fi

  case "$ZIPFILE" in
  *BATTERY*)
    ui_print " " "Removing limit to learn battery capacity...";
    patch_cmdline "battery_capacity.remove_op_capacity" "battery_capacity.remove_op_capacity=1";
    ;;
  *)
    ui_print " " "Keeping the limit for learning battery capacity...";
    patch_cmdline "battery_capacity.remove_op_capacity" "battery_capacity.remove_op_capacity=0";
    ;;
  esac

  if [ -d $ramdisk/.backup ]; then
    mv $home/overlay.d $ramdisk/overlay.d;
    chmod -R 750 $ramdisk/overlay.d/*;
    chown -R root:root $ramdisk/overlay.d/*;
    chmod -R 755 $ramdisk/overlay.d/sbin/*;
    chown -R root:root $ramdisk/overlay.d/sbin/*;
  fi

  # Install the boot image
  write_boot;
}

install;

case $is_slot_device in
  1|auto)
    ui_print " ";
    ui_print "Installing to the secondary slot";
    slot_select=inactive;
    unset block;
    eval $(cat $home/props | grep '^block=' | grep -v '\.')
    reset_ak;
    install;
  ;;
esac

## end install
