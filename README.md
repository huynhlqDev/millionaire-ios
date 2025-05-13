# 🎮 Ai Là Triệu Phú - SwiftUI Game

Một trò chơi "Ai Là Triệu Phú" (Millionaire) được xây dựng bằng SwiftUI, mô phỏng chương trình truyền hình nổi tiếng với giao diện đẹp, dễ chơi và dễ mở rộng.

## 📱 Tính năng

- Hiển thị câu hỏi trắc nghiệm với 4 đáp án.
- Hệ thống các mốc phần thưởng tăng dần.
- Các quyền trợ giúp: 50:50, Gọi điện, Hỏi khán giả (có thể thêm sau).
- Giao diện trực quan, dễ dùng.
- Hỗ trợ flow:
  - Màn hình chào mừng (Welcome)
  - Màn chơi chính (Game)
  - Màn hình thắng (Win)
  - Màn hình thua (Lose)
  - Màn hình dừng cuộc chơi (Result)

## 🧱 Kiến trúc SwiftUI

- `WelcomeView`: Màn hình khởi đầu với nút bắt đầu game.
- `GameView`: Hiển thị câu hỏi, đáp án, quyền trợ giúp và bảng mốc.
- `AnswerButton`: Component hiển thị một đáp án (A/B/C/D).
- `QuestionView`: Component hiển thị câu hỏi.
- `LifelineButtonsView`: Các nút quyền trợ giúp.
- `ResultView`, `WinView`, `LoseView`: Các màn hình kết thúc.
