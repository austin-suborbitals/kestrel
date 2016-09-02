PROG=kestrel
TARGET=thumbv7m-none-eabi

RELEASE_FNAME=target/$(TARGET)/release/$(PROG)

default: build

clean:
	cargo clean

build:
	cargo build --target $(TARGET)

release:
	cargo build --target $(TARGET) --release

binary: release
	@arm-none-eabi-objcopy -O binary $(RELEASE_FNAME) $(RELEASE_FNAME).bin

symtab: release
	arm-none-eabi-objdump -x $(RELEASE_FNAME)

info: binary
	@echo "ELF Size: "$(shell ls -lh $(RELEASE_FNAME)     | awk '{print $$5}')" KiB"
	@echo "BIN Size: "$(shell ls -lh $(RELEASE_FNAME).bin | awk '{print $$5}')" KiB"
