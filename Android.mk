#
# Integration of kernel building into AOSP build system
#

LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_ARCH),arm64)
 TARGET_CROSS_COMPILE := aarch64-linux-android-
else
 $(error TARGET_ARCH=$(TARGET_ARCH) is not supported. Only arm64 is supported)
endif

TARGET_KERNEL_BUILD_FLAGS := -j4

TARGET_KERNEL_DEFCONFIG   := hikey960_defconfig
TARGET_KERNEL_SRC_DIR     := $(LOCAL_PATH)
TARGET_KERNEL_BUILD_DIR   := $(PRODUCT_OUT)/obj/KERNEL

TARGET_KERNEL_OUT         := $(TARGET_KERNEL_BUILD_DIR)/arch/$(TARGET_ARCH)/boot
TARGET_KERNEL_IMG         := $(TARGET_KERNEL_OUT)/Image.gz
TARGET_KERNEL_DTB         := $(TARGET_KERNEL_OUT)/dts/hisilicon/hi3660-hikey960.dtb

.PHONY: kernel-config kernel-build

kernel-build: kernel-config
	@echo Building kernel
	$(MAKE) -C $(TARGET_KERNEL_BUILD_DIR) ARCH=$(TARGET_ARCH) CROSS_COMPILE=$(TARGET_CROSS_COMPILE) $(TARGET_KERNEL_BUILD_FLAGS)
kernel-config:
	$(MAKE) -C $(TARGET_KERNEL_SRC_DIR) O=$$(readlink -f $(TARGET_KERNEL_BUILD_DIR)) ARCH=$(TARGET_ARCH) $(TARGET_KERNEL_DEFCONFIG)

$(TARGET_PREBUILT_KERNEL): kernel-build
	cp $(TARGET_KERNEL_IMG) $@

$(TARGET_PREBUILT_DTB): kernel-build
	cp $(TARGET_KERNEL_IMG) $@
