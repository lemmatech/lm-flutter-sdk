import Flutter
import UIKit
import WebKit
import LemmaSDK

protocol FLTAd : NSObjectProtocol {
    
    var manager:FLTAdInstanceManager? { get set }
    var adId:NSNumber { get set }
    
    func load() -> Void

}

class FLTBannerAd : NSObject, FLTAd, FlutterPlatformView, LMBannerViewDelegate, LMInBannerVideoDelegate {
    
    var banner:LMBannerView!
    var request:FLTAdRequest!
    var videobanner:LMInBannerVideo!
    
    var bannerViewDelegateImpl:LMBannerViewDelegateImpl?
    var inbannerVideoDelegateImpl:LMInBannerVideoDelegateImpl?

    init(adSize: FLTAdSize,request:FLTAdRequest) {
        super.init()
        self.request = request
        
        let lmRequest = LMAdRequest()
        lmRequest.publisherId = self.request.publisherId ?? "";
        lmRequest.adunitId = self.request.adUnitId ?? "";

        if let networkTimeout = self.request?.networkTimeout {
            lmRequest.netoworkTimeout = networkTimeout.uintValue
        }

        if let urlString = self.request?.serverURL {
            lmRequest.serverUrl = urlString
        }
        
        
        let switchToVideo = request.switchToVideo
        if switchToVideo {
            videobanner = LMInBannerVideo(adRequest: lmRequest, andAdSize: adSize.size())
            videobanner.frame = CGRect(x: 0, y: 0, width: adSize.size().width, height: adSize.size().height);

            inbannerVideoDelegateImpl = LMInBannerVideoDelegateImpl(bannerAd: self)
            videobanner.delegate = inbannerVideoDelegateImpl
            videobanner.loadAd()

        }else{
            banner = LMBannerView(adRequest: lmRequest, andAdSize: adSize.size())
            banner!.frame = CGRect(x: 0, y: 0, width: adSize.size().width, height: adSize.size().height);
            
            bannerViewDelegateImpl = LMBannerViewDelegateImpl(bannerAd: self)
            
            banner!.delegate = bannerViewDelegateImpl
            
            banner.loadAd()
        }
    }
    
    func view() -> UIView {
        return self.banner!
    }

    var manager: FLTAdInstanceManager?
    
    var adId: NSNumber = 124
    
    func load() {
        self.banner?.loadAd()
    }
    
}

class  LMInBannerVideoDelegateImpl : NSObject , LMInBannerVideoDelegate {
    
    weak var bannerAd:FLTBannerAd!
    
    init(bannerAd:FLTBannerAd?) {
        super.init()
        self.bannerAd = bannerAd
    }
    
    func bannerView(_ bannerView: LMInBannerVideo, didFailToReceiveAdWithError error: Error?) {
        self.bannerAd.manager?.onAdFailedToLoad(ad: self.bannerAd, err: error as! Error as NSError)
    }

    func bannerViewDidReceiveAd(_ bannerView: LMInBannerVideo) {
        self.bannerAd.manager?.onAdLoadeed(ad: self.bannerAd)
    }

    func bannerViewWillPresentModal(_ bannerView: LMInBannerVideo) {
        self.bannerAd.manager?.bannerWillPresent(ad: self.bannerAd)
    }

    func bannerViewDidDismissModal(_ bannerView: LMInBannerVideo) {
        self.bannerAd.manager?.bannerDidDismiss(ad: self.bannerAd)
    }
}

class  LMBannerViewDelegateImpl : NSObject , LMBannerViewDelegate {
    
    weak var bannerAd:FLTBannerAd!

    init(bannerAd:FLTBannerAd?) {
        super.init()
        self.bannerAd = bannerAd
    }
    
    func bannerView(_ bannerView: LMBannerView, didFailToReceiveAdWithError error: Error?) {
        self.bannerAd.manager?.onAdFailedToLoad(ad: self.bannerAd, err: error as! Error as NSError)
    }
    
    func bannerViewDidReceiveAd(_ bannerView: LMBannerView) {
        self.bannerAd.manager?.onAdLoadeed(ad: self.bannerAd)
    }
    
    func bannerViewWillPresentModal(_ bannerView: LMBannerView) {
        self.bannerAd.manager?.bannerWillPresent(ad: self.bannerAd)
    }
    
    func bannerViewDidDismissModal(_ bannerView: LMBannerView) {
        self.bannerAd.manager?.bannerDidDismiss(ad: self.bannerAd)
    }
}

protocol FLTAdWithoutView {
    func show()
}

class FLTInterstitialAd : NSObject, FLTAd ,FLTAdWithoutView,  LMInterstitialAdDelegate {
    
    var request:FLTAdRequest!

    var interstitialAd:LMInterstitialAd?

    
    var manager: FLTAdInstanceManager?
    
    init(request:FLTAdRequest) {
        super.init()
        self.request = request
        
        let lmRequest = LMAdRequest()
        lmRequest.publisherId = self.request.publisherId ?? "";
        lmRequest.adunitId = self.request.adUnitId ?? "";
        
        if let networkTimeout = self.request?.networkTimeout {
            lmRequest.netoworkTimeout = networkTimeout.uintValue
        }
        
        if let urlString = self.request?.serverURL {
            lmRequest.serverUrl = urlString
        }
        
        self.interstitialAd = LMInterstitialAd(adRequest: lmRequest)
        
        let switchToVideo = request.switchToVideo

        // Switch to video
        self.interstitialAd?.switchToVideo = switchToVideo
        
        self.interstitialAd?.delegate = self

    }
    
    var adId: NSNumber = 0.0
    
    func load() {
        self.interstitialAd?.load()
    }
    
    func show() {
        let rootController = LemmaSdkPlugin.rootVC()
        self.interstitialAd?.show(from: rootController!)
    }
    
    func interstitialDidReceive(_ interstitial: LMInterstitialAd) {
        manager?.onAdLoadeed(ad: self)
    }
    
    func interstitial(_ interstitial: LMInterstitialAd, didFailToReceiveAdWithError error: Error?) {
        manager?.onAdFailedToLoad(ad: self, err: error as! Error as NSError)
    }
    
    func interstitialWillPresent(_ interstitial: LMInterstitialAd) {
        manager?.adWillPresent(ad: self)
    }
    
    func interstitialDidDismiss(_ interstitial: LMInterstitialAd) {
        manager?.adDidDismiss(ad: self)
    }

}

class FLTAdRequest: NSObject {
    var publisherId: String?
    var adUnitId: String?
    var serverURL: String?
    var networkTimeout: NSNumber?
    var switchToVideo: Bool = false
}

class FLTAdSize: NSObject {
    var width:NSNumber?
    var height:NSNumber?
    
    func size() -> CGSize {
        return CGSize(width: CGFloat(width?.floatValue ?? 0), height: CGFloat(height?.floatValue ?? 0))
    }
}

class FLTLocationParams: NSObject {
   
    var accuracy:NSNumber?
    var longitude:NSNumber!
    var latitude:NSNumber!

    init(latitude:NSNumber,longitude:NSNumber,accuracy:NSNumber?) {
        super.init()
        
        self.accuracy = accuracy
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func location() -> CLLocation {
        return CLLocation(latitude: CLLocationDegrees(exactly: latitude)!, longitude: CLLocationDegrees(exactly: longitude)!)
    }
}
