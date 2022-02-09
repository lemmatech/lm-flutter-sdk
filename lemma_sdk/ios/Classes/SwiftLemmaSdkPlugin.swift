import Flutter
import UIKit
import LemmaSDK

public class SwiftLemmaSdkPlugin: NSObject, FlutterPlugin {
    
    var manager:FLTAdInstanceManager?
    
    public init(messenger: FlutterBinaryMessenger) {
        super.init()
        self.manager = FLTAdInstanceManager(messanger: messenger);
    }
    
    static var _channel:FlutterMethodChannel?;
    public static func register(with registrar: FlutterPluginRegistrar) {
        
        
        let instance = SwiftLemmaSdkPlugin(messenger: registrar.messenger())
        
        let readerWriter = FLTLMAdsReaderWriter()
        let codec = FlutterStandardMethodCodec(readerWriter:
                                                readerWriter)
        
        let channel = FlutterMethodChannel(name: "lemma_sdk", binaryMessenger: registrar.messenger(),codec: codec)
        
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        let viewFactory =  FLTLMAdsViewFactory(manager: instance.manager!)
        
        registrar.register(viewFactory, withId: "plugins.flutter.io/lemma_sdk/ad_widget")
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        if call.method == "loadBannerAd" {
            if let dict = call.arguments as? Dictionary<String, AnyObject> {
                let ad = FLTBannerAd(adSize:  dict["size"] as! FLTAdSize, request: dict["request"] as! FLTAdRequest)
                
                ad.adId = dict["adId"] as! NSNumber
                self.manager?.loadAd(ad: ad)
            }
            result("na")
        }else if call.method == "loadInterstitialAd" {
            if let dict = call.arguments as? Dictionary<String, AnyObject> {
                let ad = FLTInterstitialAd(request: dict["request"] as! FLTAdRequest)
                
                ad.adId = dict["adId"] as! NSNumber
                self.manager?.loadAd(ad: ad)
            }
            result(nil)
        }else if call.method == "showAdWithoutView" {
            if let dict = call.arguments as? Dictionary<String, AnyObject> {
                self.manager?.show(adId: dict["adId"] as! NSNumber)
            }
            result(nil)
        }else if call.method == "LemmaSDK#version" {
            result(LemmaSDK.version());
        }else if call.method == "LemmaSDK#enableLogs" {
            if let dict = call.arguments as? Dictionary<String, AnyObject> {
                if dict["enable"] as! Bool == true {
                    LemmaSDK.setLevel(.all)
                }
            }
            result(nil)
        }else if call.method == "LemmaSDK#setAppDomain" {
            if let dict = call.arguments as? Dictionary<String, AnyObject> {
                LemmaSDK.shared().appDomain = dict["appDomain"] as! String
            }
            result(nil)
        }else if call.method == "LemmaSDK#setStoreURL" {
            if let dict = call.arguments as? Dictionary<String, AnyObject> {
                
                if let storeURLstr = dict["storeURL"] as? String {
                    LemmaSDK.shared().storeURL = URL(string: storeURLstr)
                }
            }
            result(nil)
        }else if call.method == "LemmaSDK#setAppCategories" {
            if let dict = call.arguments as? Dictionary<String, AnyObject> {
                LemmaSDK.shared().appCategories = dict["appCategories"] as! String
            }
            result(nil)
        }else if call.method == "LemmaSDK#setAppKeywords" {
            if let dict = call.arguments as? Dictionary<String, AnyObject> {
                LemmaSDK.shared().appkeywords = dict["appKeywords"] as! String
            }
            result(nil)
        }else if call.method == "LemmaSDK#setUserKeywords" {
            if let dict = call.arguments as? Dictionary<String, AnyObject> {
                LemmaSDK.shared().userKeywords = dict["userKeywords"] as! String
            }
            result(nil)
        }else if call.method == "LemmaSDK#setCoppa" {
            if let dict = call.arguments as? Dictionary<String, AnyObject> {
                LemmaSDK.shared().coppa = dict["coppa"] as! Bool
            }
            result(nil)
        }else if call.method == "LemmaSDK#setGDPR" {
            if let dict = call.arguments as? Dictionary<String, AnyObject> {
                LemmaSDK.shared().gdpr = dict["gdpr"] as! Bool
            }
            result(nil)
        }else if call.method == "LemmaSDK#setGDPRConsent" {
            if let dict = call.arguments as? Dictionary<String, AnyObject> {
                LemmaSDK.shared().appCategories = dict["gdprConsent"] as! String
            }
            result(nil)
        }else if call.method == "LemmaSDK#setLocationParams" {
            if let dict = call.arguments as? Dictionary<String, AnyObject> {
                
                if let location = dict["LocationParams"] as? FLTLocationParams  {
                    
                    LemmaSDK.shared().location = location.location()
                    }
            }
            result(nil)
        }
        else{
            result("iOS " + UIDevice.current.systemVersion)
        }
    }

}
