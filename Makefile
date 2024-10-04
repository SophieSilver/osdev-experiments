AS := nasm
SRC := src
ASFLAGS := -f bin 
TARGET := target
ASMDEPS := $(TARGET)/asm_deps
QEMU := qemu-system-x86_64
QEMU_FLAGS := -accel kvm -cpu host -monitor stdio
QEMU_DRIVE_FLAGS := format=raw,index=0,media=disk

.PHONY: all build run

all: build
build: $(TARGET)/os.img

run: build
	$(QEMU) $(QEMU_FLAGS) -drive file=$(TARGET)/os.img,$(QEMU_DRIVE_FLAGS)


$(TARGET)/os.img: $(ASMDEPS)/boot
	mkdir -p $(@D)
	cp $^ $@

$(ASMDEPS)/boot: $(SRC)/boot.asm
	mkdir -p $(@D)
	$(AS) $(ASFLAGS) $^ -o $@ -l $@.lst

clean:
	rm -rf target/*