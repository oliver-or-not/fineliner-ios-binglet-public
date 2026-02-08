// MARK: - Module Dependency

import SwiftUI
import Spectrum
import Agent
import Plate

// MARK: - Body

struct PlateStackWindow: View {

    @Bindable var windowModel: PlateStackWindowModel

    var body: some View {
        GeometryReader { geo in
            ZStack {
                DS.PaletteColor.black
                    .ignoresSafeArea()
                stablePlateStack
                    .offset(
                        x: windowModel.stablePlateRelativeOffset.x * geo.size.width,
                        y: windowModel.stablePlateRelativeOffset.y * geo.size.height
                    )
                unstablePlate
                    .offset(
                        x: windowModel.unstablePlateRelativeOffset.x * geo.size.width,
                        y: windowModel.unstablePlateRelativeOffset.y * geo.size.height
                    )
            }
        }
    }

    var stablePlateStack: some View {
        ZStack {
            ForEach(windowModel.stablePlateDesignationArray.indices, id: \.self) { index in
                let designation = windowModel.stablePlateDesignationArray[index]
                PlatePlaceholder(designation: designation)
            }
        }
        .compositingGroup()
        //        .clipShape(RoundedRectangle(
        //            cornerRadius: windowModel.stablePlateCornerRadius,
        //            style: .continuous
        //        ))
        .scaleEffect(
            DS.Length.distanceFromFaceToPlate /
            (DS.Length.distanceFromFaceToPlate + windowModel.stablePlateDistance),
            anchor: .center
        )
        .opacity(windowModel.stablePlateOpacity)
    }

    var unstablePlate: some View {
        PlatePlaceholder(designation: windowModel.unstablePlateDesignation)
            .compositingGroup()
        //        .clipShape(RoundedRectangle(
        //            cornerRadius: windowModel.unstablePlateCornerRadius,
        //            style: .continuous
        //        ))
            .scaleEffect(
                DS.Length.distanceFromFaceToPlate /
                (DS.Length.distanceFromFaceToPlate + windowModel.unstablePlateDistance),
                anchor: .center
            )
            .compositingGroup()
            .opacity(windowModel.unstablePlateOpacity)
    }
}
