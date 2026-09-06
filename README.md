# Bài 03 — Debug STM32F103 với VS Code, OpenOCD, GDB và ST-Link

Đây là **project thực hành dành cho sinh viên**, khớp với các ví dụ thao tác trong tài liệu `BAI_03_STUDENT_TECHNICAL_MANUAL.pdf`.

## 1. Target

- MCU: STM32F103C8 / Cortex-M3
- Board tham chiếu: Blue Pill
- Debug probe: ST-Link
- Transport: SWD
- Build artifact chính: `lesson.elf`

## 2. Cấu trúc project

```text
L03_STUDENT_PROJECT/
├── .vscode/
│   ├── launch.json
│   ├── tasks.json
│   ├── settings.json
│   └── extensions.json
├── common/
│   ├── startup.c
│   ├── linker.ld
│   └── openocd/
│       └── stm32f103_stlink.cfg
├── scripts/
│   ├── verify_env.sh
│   ├── openocd_server.sh
│   ├── program_verify.sh
│   └── gdb_cli.txt
├── evidence/
├── main.c
└── Makefile
```

## 3. Kiểm môi trường

```bash
./scripts/verify_env.sh
```

Kết quả cuối cần có:

```text
ENV PASS
```

## 4. Build

```bash
make clean
make
```

Artifact mong đợi:

```text
lesson.elf
lesson.bin
lesson.map
```

Khóa exact ELF:

```bash
sha256sum lesson.elf
```

## 5. Debug bằng VS Code

1. Mở thư mục `L03_STUDENT_PROJECT` bằng VS Code.
2. Cài các extension được VS Code đề xuất.
3. Nhấn `Ctrl+Shift+B` để build.
4. Mở `Run and Debug`.
5. Chọn `Debug STM32F103 (OpenOCD)`.
6. Nhấn Start Debug / F5.
7. Đặt breakpoint tại `main()`.
8. Quan sát Variables, Registers, Memory và Disassembly.

`launch.json` không chứa đường dẫn tuyệt đối của máy biên soạn; project dùng tool từ `PATH`.

## 6. Program + verify bằng OpenOCD

Khi đã nối ST-Link/Blue Pill đúng:

```bash
./scripts/program_verify.sh
```

Hoặc chạy trực tiếp:

```bash
openocd -f common/openocd/stm32f103_stlink.cfg \
  -c "program lesson.elf verify reset exit"
```

## 7. GDB CLI

Terminal 1 — chạy OpenOCD:

```bash
./scripts/openocd_server.sh
```

Terminal 2 — chạy GDB:

```bash
arm-none-eabi-gdb -q lesson.elf
```

Sau đó dùng chuỗi command trong `scripts/gdb_cli.txt`.

Các lệnh cốt lõi:

```gdb
target extended-remote localhost:3333
monitor reset halt
break main
continue
info program
info registers pc sp lr xpsr
p/x &known_var
p/x known_var
x/wx &known_var
disassemble main
```

## 8. Biến kiểm chứng dùng trong tài liệu

`main.c` chứa:

```c
volatile uint32_t known_var = 0x1234ABCDu;
volatile uint32_t loop_count = 0u;
```

Hai biến này được dùng xuyên suốt để sinh viên kiểm tra:

```text
source → symbol → address → raw RAM
```

## 9. Lưu ý

- `Build PASS` không đồng nghĩa `Flash verify PASS`.
- `Verify PASS` không đồng nghĩa CPU boot đúng application.
- Khi debug sai, luôn kiểm exact ELF, target state và boot path trước khi build lại ngẫu nhiên.
