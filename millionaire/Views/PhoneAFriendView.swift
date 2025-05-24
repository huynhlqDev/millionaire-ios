//
//  CallAFriendView.swift
//  millionaire
//
//  Created by huynh on 24/5/25.
//

import SwiftUI

struct PhoneAFriendView: View {
    @State var isCalling: Bool = false
    @State private var message: String = ""
    @State private var isTyping = false
    var answerIndex: Int
    var okAction: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
            VStack {
                if isCalling {
                    Text("Calling...").font(.title2).bold().padding()
                    Color.white.frame(height: 2)
                    Text(message)
                        .padding()
                        .background(.gray.opacity(0.5))

                    Spacer()
                    OKButtonView(okAction: okAction)
                } else {
                    Text("📞 Bạn muốn gọi cho ai?").font(.title2).bold().padding()
                    List(Contact.contacts, id: \.id) { contact in
                        Button(action: {call(to: contact)}) {
                            HStack {
                                Image(systemName: "person.crop.circle.fill")
                                    .scaledToFit()
                                    .foregroundStyle(.black)
                                Text(contact.name)
                                    .foregroundStyle(.black)
                                    .padding()
                            }
                        }
                    }
                }
            }
            .frame(width: screenWidth*0.8, height: screenHeight*0.4)
            .foregroundColor(Color.white)
            .background(Color.blue.opacity(0.8))
            .cornerRadius(8)
            .shadow(radius: 12)
        }
        .animation(.linear, value: isCalling)
        .ignoresSafeArea()
    }

    private func call(to contact: Contact) {
        let answer = {
            switch answerIndex {
            case 1: "A"
            case 2: "B"
            case 3: "C"
            case 4: "D"
            default:
                "Không biết"
            }
        }
        let fullMessage = contact.message(answer())
        isCalling = true
        isTyping = true
        message = ""
        for (index, char) in fullMessage.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.05) {
                message.append(char)
                if index == fullMessage.count - 1 {
                    isTyping = false
                }
            }
        }
    }
}

struct Contact: Identifiable {
    static let contacts: [Contact] = [
        Contact(
            name: "Mẹ",
            message: { answer in "Mẹ nghĩ đáp án là \(answer), cố lên con nhé!" }
        ),
        Contact(
            name: "Bố",
            message: { answer in "Theo bố thì đáp án phải là \(answer), bố tin con chọn đúng!" }
        ),
        Contact(
            name: "Anh trai",
            message: { answer in "Chắc là \(answer) đấy, nhưng nhớ kiểm tra lại cho chắc!" }
        ),
        Contact(
            name: "Bạn thân",
            message: { answer in "Haha tao nghĩ là \(answer), nhưng không chắc đâu nha =))" }
        ),
        Contact(
            name: "Thầy Huấn",
            message: { answer in "Dựa trên kiến thức của thầy thì \(answer) là lựa chọn hợp lý nhất." }
        )
    ]
    let id: Int = UUID().hashValue
    let name: String
    let message: (String) -> String
}

#Preview {
    PhoneAFriendView(answerIndex: 1, okAction: { print("OK") })
}
