# Báo cáo Chẩn đoán lỗi L03

* **1. Hiện tượng:** Khi khởi động OpenOCD, hệ thống báo lỗi không kết nối được target (`Error: init mode failed (unable to connect to the target)`).
* **2. Giả thuyết ban đầu:**
  * Giả thuyết 1 (H1 - Lớp Điện/Vật lý): Mất đường mass GND chung hoặc lỏng/đứt dây tín hiệu SWDIO/SWCLK.
  * Giả thuyết 2 (H2 - Lớp Cấu hình OpenOCD): Tệp cấu hình `stm32f103_stlink.cfg` bị sai lệch thiết lập target.
* **3. Phép đo & Phân biệt:**
  * Kiểm tra cấu hình phần mềm: File `stm32f103_stlink.cfg` hoàn toàn không bị chỉnh sửa so với phiên làm việc nạp Flash thành công ở `L03-E03` -> Loại trừ H2.
  * Kiểm tra kết nối vật lý: Phát hiện cọc chân GND trên ST-Link bị rút ra khỏi chân GND của kit STM32 -> Xác nhận H1 đúng.
* **4. Nguyên nhân gốc:** Mất dây mass GND chung làm mất mốc điện áp tham chiếu cho hai tín hiệu số SWDIO và SWCLK, khiến khối SW-DP trong chip không thể nhận diện xung clock và khung truyền.
* **5. Thao tác khắc phục:** Cắm lại duy nhất chân dây GND từ ST-Link vào chân GND của board STM32F103 (không sửa code, không đổi cấu hình).
* **6. Kiểm tra lại (Hồi quy):** Chạy lại chính xác cùng lệnh `openocd -f common/openocd/stm32f103_stlink.cfg -c "exit"`. Kết quả ghi nhận `SWD DPIDR 0x2ba01477`, lõi Cortex-M3 được nhận diện và hoàn tất không lỗi.
* **7. Biện pháp phòng tránh:** Luôn đấu nối chân GND trước khi cấp nguồn; kiểm tra độ chắc chắn của dây jumper trước khi debug.
