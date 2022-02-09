import Flutter
import UIKit
import Flutter

@objc public class FLTAdInstanceManager: NSObject {

    let ads = FLTLMAdsCollection()
    var channel:FlutterMethodChannel?

    public init(messanger : FlutterBinaryMessenger) {
        super.init()
        let methodCodec = FlutterStandardMethodCodec(readerWriter: FLTLMAdsReaderWriter())
        self.channel = FlutterMethodChannel(name: "lemma_sdk", binaryMessenger: messanger, codec: methodCodec)
    }
    
    func adFor(key: AnyObject) -> FLTAd {
        return ads.objectForKey(key: key as! AnyHashable) as! FLTAd
    }
    
    func adIdFor(obj: AnyObject) -> NSNumber? {
        let keys = ads.allKeysForObject(object: obj as! AnyHashable)
        if keys.count > 0 {
            return keys.first as? NSNumber
        }
        return nil
    }
    
    func loadAd(ad : FLTAd) -> Void {
        ads.setObject(obj: ad as! AnyHashable, key: ad.adId as! AnyHashable)
        ad.manager = self
        ad.load()
    }
    
    func show(adId: NSNumber) {
        let ad : FLTAdWithoutView = self.adFor(key: adId) as! FLTAdWithoutView
        if ad == nil {
            return
        }
        ad.show()
    }

    func onAdLoadeed(ad : FLTAd) -> Void {
        self.channel?.invokeMethod("onAdEvent", arguments: [
                                    "adId" : ad.adId,
                                    "eventName" : "onAdLoaded"])
    }
 
    func onAdFailedToLoad(ad : FLTAd, err : NSError) -> Void{
        self.channel?.invokeMethod("onAdEvent", arguments: [
                                    "adId" : ad.adId,
                                    "eventName" : "onAdFailedToLoad",
                                    "loadAdError" :err])

    }
    
    func bannerWillPresent(ad : FLTAd) -> Void {
        self.channel?.invokeMethod("onAdEvent", arguments: [
                                    "adId" : ad.adId,
                                    "eventName" : "onBannerWillPresentScreen"])

    }
    
    func bannerDidDismiss(ad : FLTAd) -> Void {
        self.channel?.invokeMethod("onAdEvent", arguments: [
                                    "adId" : ad.adId,
                                    "eventName" : "onBannerDidDismissScreen"])
    }

    
    // For full screen ads
    func adWillPresent(ad : FLTAd) -> Void {
        self.channel?.invokeMethod("onAdEvent", arguments: [
                                    "adId" : ad.adId,
                                    "eventName" : "adWillPresent"])
        
    }
    
    func adDidDismiss(ad : FLTAd) -> Void {
        self.channel?.invokeMethod("onAdEvent", arguments: [
                                    "adId" : ad.adId,
                                    "eventName" : "adDidDismiss"])
    }

}
