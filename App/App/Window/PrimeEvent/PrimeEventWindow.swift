// MARK: - Module Dependency

import SwiftUI
import Spectrum
import Director
import Agent
import Plate

// MARK: - Body

struct PrimeEventWindow: View {

    @Bindable var windowModel: PrimeEventWindowModel

    var body: some View {
        HStack(spacing: 0) {
            Spacer()
            VStack(alignment: .trailing) {
                VStack(alignment: .trailing, spacing: 0) {
                    Text("Thrown")
                        .font(.system(size: 15))
                        .foregroundStyle(DS.SemanticColor.generalText)
                        .lineLimit(1)
                    if windowModel.thrownArray.count >= 7 {
                        Text("...")
                            .font(.system(size: 15))
                            .foregroundStyle(DS.SemanticColor.generalText)
                            .lineLimit(1)
                            .padding(1)
                        ForEach(0..<6, id: \.self) { index in
                            if index < Array(windowModel.thrownArray.suffix(6)).count {
                                let tuple = Array(windowModel.thrownArray.suffix(6))[index]
                                Text(tuple.0.rawValue)
                                    .font(.system(size: 15))
                                    .foregroundStyle(DS.SemanticColor.generalText)
                                    .lineLimit(1)
                                    .padding(1)
                                    .background(
                                        RoundedRectangle(cornerRadius: 3)
                                            .fill(tuple.0.category.backgroundColor)
                                            .strokeBorder(Color.black, lineWidth: 1)
                                    )
                            } else {
                                Text("INVISIBLE")
                                    .font(.system(size: 15))
                                    .foregroundStyle(DS.SemanticColor.generalText)
                                    .lineLimit(1)
                                    .padding(1)
                                    .opacity(0)
                            }
                        }
                    } else {
                        ForEach(0..<7, id: \.self) { index in
                            if index < windowModel.thrownArray.count {
                                let tuple = windowModel.thrownArray[index]
                                Text(tuple.0.rawValue)
                                    .font(.system(size: 15))
                                    .foregroundStyle(DS.SemanticColor.generalText)
                                    .lineLimit(1)
                                    .padding(1)
                                    .background(
                                        RoundedRectangle(cornerRadius: 3)
                                            .fill(tuple.0.category.backgroundColor)
                                            .strokeBorder(Color.black, lineWidth: 1)
                                    )
                            } else {
                                Text("INVISIBLE")
                                    .font(.system(size: 15))
                                    .foregroundStyle(DS.SemanticColor.generalText)
                                    .lineLimit(1)
                                    .padding(1)
                                    .opacity(0)
                            }
                        }
                    }
                }
                VStack(alignment: .trailing, spacing: 0) {
                    Text("Waiting")
                        .font(.system(size: 15))
                        .foregroundStyle(DS.SemanticColor.generalText)
                        .lineLimit(1)
                    if windowModel.waitingArray.count >= 7 {
                        Text("...")
                            .font(.system(size: 15))
                            .foregroundStyle(DS.SemanticColor.generalText)
                            .lineLimit(1)
                            .padding(1)
                        ForEach(0..<6, id: \.self) { index in
                            if index < Array(windowModel.waitingArray.suffix(6)).count {
                                let designation = Array(windowModel.waitingArray.suffix(6))[index]
                                Text(designation.rawValue)
                                    .font(.system(size: 15))
                                    .foregroundStyle(DS.SemanticColor.generalText)
                                    .lineLimit(1)
                                    .padding(1)
                                    .background(
                                        RoundedRectangle(cornerRadius: 3)
                                            .fill(designation.category.backgroundColor)
                                            .strokeBorder(Color.black, lineWidth: 1)
                                    )
                            } else {
                                Text("INVISIBLE")
                                    .font(.system(size: 15))
                                    .foregroundStyle(DS.SemanticColor.generalText)
                                    .lineLimit(1)
                                    .padding(1)
                                    .opacity(0)
                            }
                        }
                    } else {
                        ForEach(0..<7, id: \.self) { index in
                            if index < windowModel.waitingArray.count {
                                let designation = windowModel.waitingArray[index]
                                Text(designation.rawValue)
                                    .font(.system(size: 15))
                                    .foregroundStyle(DS.SemanticColor.generalText)
                                    .lineLimit(1)
                                    .padding(1)
                                    .background(
                                        RoundedRectangle(cornerRadius: 3)
                                            .fill(designation.category.backgroundColor)
                                            .strokeBorder(Color.black, lineWidth: 1)
                                    )
                            } else {
                                Text("INVISIBLE")
                                    .font(.system(size: 15))
                                    .foregroundStyle(DS.SemanticColor.generalText)
                                    .lineLimit(1)
                                    .padding(1)
                                    .opacity(0)
                            }
                        }
                    }
                }
                VStack(alignment: .trailing, spacing: 0) {
                    Text("Performing")
                        .font(.system(size: 15))
                        .foregroundStyle(DS.SemanticColor.generalText)
                        .lineLimit(1)
                    if windowModel.performingArray.count >= 7 {
                        Text("...")
                            .font(.system(size: 15))
                            .foregroundStyle(DS.SemanticColor.generalText)
                            .lineLimit(1)
                            .padding(1)
                        ForEach(0..<6, id: \.self) { index in
                            if index < Array(windowModel.performingArray.suffix(6)).count {
                                let designation = Array(windowModel.performingArray.suffix(6))[index]
                                Text(designation.rawValue)
                                    .font(.system(size: 15))
                                    .foregroundStyle(DS.SemanticColor.generalText)
                                    .lineLimit(1)
                                    .padding(1)
                                    .background(
                                        RoundedRectangle(cornerRadius: 3)
                                            .fill(designation.category.backgroundColor)
                                            .strokeBorder(Color.black, lineWidth: 1)
                                    )
                            } else {
                                Text("INVISIBLE")
                                    .font(.system(size: 15))
                                    .foregroundStyle(DS.SemanticColor.generalText)
                                    .lineLimit(1)
                                    .padding(1)
                                    .opacity(0)
                            }
                        }
                    } else {
                        ForEach(0..<7, id: \.self) { index in
                            if index < windowModel.performingArray.count {
                                let designation = windowModel.performingArray[index]
                                Text(designation.rawValue)
                                    .font(.system(size: 15))
                                    .foregroundStyle(DS.SemanticColor.generalText)
                                    .lineLimit(1)
                                    .padding(1)
                                    .background(
                                        RoundedRectangle(cornerRadius: 3)
                                            .fill(designation.category.backgroundColor)
                                            .strokeBorder(Color.black, lineWidth: 1)
                                    )
                            } else {
                                Text("INVISIBLE")
                                    .font(.system(size: 15))
                                    .foregroundStyle(DS.SemanticColor.generalText)
                                    .lineLimit(1)
                                    .padding(1)
                                    .opacity(0)
                            }
                        }
                    }
                }
                VStack(alignment: .trailing, spacing: 0) {
                    Text("Completed")
                        .font(.system(size: 15))
                        .foregroundStyle(DS.SemanticColor.generalText)
                        .lineLimit(1)
                    if windowModel.completedArray.count >= 7 {
                        Text("...")
                            .font(.system(size: 15))
                            .foregroundStyle(DS.SemanticColor.generalText)
                            .lineLimit(1)
                            .padding(1)
                        ForEach(0..<6, id: \.self) { index in
                            if index < Array(windowModel.completedArray.suffix(6)).count {
                                let tuple = Array(windowModel.completedArray.suffix(6))[index]
                                Text(tuple.0.rawValue)
                                    .font(.system(size: 15))
                                    .foregroundStyle(DS.SemanticColor.generalText)
                                    .lineLimit(1)
                                    .padding(1)
                                    .background(
                                        RoundedRectangle(cornerRadius: 3)
                                            .fill(tuple.0.category.backgroundColor)
                                            .strokeBorder(Color.black, lineWidth: 1)
                                    )
                            } else {
                                Text("INVISIBLE")
                                    .font(.system(size: 15))
                                    .foregroundStyle(DS.SemanticColor.generalText)
                                    .lineLimit(1)
                                    .padding(1)
                                    .opacity(0)
                            }
                        }
                    } else {
                        ForEach(0..<7, id: \.self) { index in
                            if index < windowModel.completedArray.count {
                                let tuple = windowModel.completedArray[index]
                                Text(tuple.0.rawValue)
                                    .font(.system(size: 15))
                                    .foregroundStyle(DS.SemanticColor.generalText)
                                    .lineLimit(1)
                                    .padding(1)
                                    .background(
                                        RoundedRectangle(cornerRadius: 3)
                                            .fill(tuple.0.category.backgroundColor)
                                            .strokeBorder(Color.black, lineWidth: 1)
                                    )
                            } else {
                                Text("INVISIBLE")
                                    .font(.system(size: 15))
                                    .foregroundStyle(DS.SemanticColor.generalText)
                                    .lineLimit(1)
                                    .padding(1)
                                    .opacity(0)
                            }
                        }
                    }
                }
            }
        }
        .opacity(windowModel.isVisible ? 0.3 : 0)
        .allowsHitTesting(false)
    }
}

fileprivate extension PrimeEventDesignation.Category {

    var backgroundColor: Color {
        switch self {
        case .natural:
            Color(hex: "77BB33")
        case .friendly:
            Color(hex: "55BB66")
        case .hierarchical(let scale):
            switch scale {
            case .boundedInPlate:
                Color(hex: "BB5566")
            case .interplate:
                Color(hex: "999955")
            case .app:
                Color(hex: "5566BB")
            }
        }
    }
}
