#if DEBUG
// MARK: - Module Dependency

import SwiftUI
import Spectrum
import Director

// MARK: - Context

@MainActor fileprivate let primeEventDirector = GlobalEntity.Director.primeEvent

// MARK: - Body

struct ObservationToggleWindow: View {

    @State private var offset: CGPoint = .zero
    @State private var lastOffset: CGPoint = .zero

    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            HStack {
                Button(action: {
                    Task {
                        await primeEventDirector.receive(.observationButtonTapped)
                    }
                }, label: {
                    Text("Observation")
                        .font(.system(size: 15))
                        .foregroundStyle(DS.SemanticColor.generalText)
                        .lineLimit(nil)
                        .padding(4)
                        .background(
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color(hex: "AAAA77"))
                                .strokeBorder(Color.black, lineWidth: 1)
                        )
                })
                .offset(x: offset.x, y: offset.y)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            // 드래그 중 실시간 이동량 = 이전 위치 + 현재 translation
                            offset = CGPoint(
                                x: lastOffset.x + value.translation.width,
                                y: lastOffset.y + value.translation.height
                            )
                        }
                        .onEnded { _ in
                            // 드래그 끝난 시점 위치를 저장
                            lastOffset = offset
                        }
                )
                Spacer()
            }
            Spacer()
                .frame(height: 100)
        }
    }
}
#endif
