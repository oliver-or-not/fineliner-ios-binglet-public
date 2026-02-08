// MARK: - Module Dependency

import SwiftUI
import Spectrum
import Director
import Agent
import Plate

// MARK: - Body

struct LogWindow: View {

    @Bindable var windowModel: LogWindowModel

    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading) {
                Spacer()
                    .frame(height: 50)
                Text("Log")
                    .font(.system(size: 15))
                    .foregroundStyle(DS.SemanticColor.generalText)
                    .lineLimit(1)
                ForEach(0..<(windowModel.logFormArray.count), id: \.self) { index in
                    let form = windowModel.logFormArray[index]
                    VStack(alignment: .leading, spacing: 0) {
                        Text(form.category)
                            .font(.system(size: 13))
                            .foregroundStyle(DS.SemanticColor.generalText)
                            .lineLimit(nil)
                            .padding(1)
                            .background(
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(Color(hex: "777777"))
                                    .strokeBorder(Color.black, lineWidth: 1)
                            )
                            .border(Color.black, width: 1)
                        Text(form.message)
                            .font(.system(size: 15))
                            .foregroundStyle(DS.SemanticColor.generalText)
                            .lineLimit(nil)
                            .padding(1)
                            .background(
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(form.logType.backgroundColor)
                                    .strokeBorder(Color.black, lineWidth: 1)
                            )
                    }
                }
                Spacer()
            }
            Spacer()
        }
        .opacity(windowModel.isVisible ? 0.3 : 0)
        .allowsHitTesting(false)
    }
}

fileprivate extension LogDirectorLogType {

    var backgroundColor: Color {
        switch self {
        case .debug:
            Color(hex: "CCCCCC")
        case .info:
            Color(hex: "999999")
        case .default:
            Color(hex: "777777")
        case .error: // yellow
            Color(hex: "55AAAA")
        case .fault: // red
            Color(hex: "BB6666")
        }
    }
}
