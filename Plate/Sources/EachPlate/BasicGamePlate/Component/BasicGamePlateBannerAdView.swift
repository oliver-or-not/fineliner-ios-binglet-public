import GoogleMobileAds
import SwiftUI

struct BasicGamePlateBannerAdView: View {

    let unitId: String

    // [START add_banner_to_view]
    var body: some View {
        // Request an anchored adaptive banner with a width of 375.
        let adSize = currentOrientationAnchoredAdaptiveBanner(width: UIScreen.main.bounds.width)
        BannerViewContainer(adSize: adSize, unitId: unitId)
            .frame(width: adSize.size.width, height: adSize.size.height)
    }
    // [END add_banner_to_view]
}

struct BasicGamePlateBannerAdView_Previews: PreviewProvider {

    static var previews: some View {
        BasicGamePlateBannerAdView(unitId: "")
    }
}

// [START create_banner_view]
private struct BannerViewContainer: UIViewRepresentable {

    typealias UIViewType = BannerView
    let adSize: AdSize
    let unitId: String

    init(adSize: AdSize, unitId: String) {
        self.adSize = adSize
        self.unitId = unitId
    }

    func makeUIView(context: Context) -> BannerView {
        let banner = BannerView(adSize: adSize)
        // [START load_ad]
        banner.adUnitID = unitId
        banner.load(Request())
        // [END load_ad]
        // [START set_delegate]
        banner.delegate = context.coordinator
        // [END set_delegate]
        return banner
    }

    func updateUIView(_ uiView: BannerView, context: Context) {}

    func makeCoordinator() -> BannerCoordinator {
        return BannerCoordinator(self)
    }
    // [END create_banner_view]

    class BannerCoordinator: NSObject, BannerViewDelegate {

        let parent: BannerViewContainer

        init(_ parent: BannerViewContainer) {
            self.parent = parent
        }

        // MARK: - GADBannerViewDelegate methods

        func bannerViewDidReceiveAd(_ bannerView: BannerView) {
//            print("DID RECEIVE AD.")
        }

        func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: Error) {
//            print("FAILED TO RECEIVE AD: \(error.localizedDescription)")
        }
    }
}
