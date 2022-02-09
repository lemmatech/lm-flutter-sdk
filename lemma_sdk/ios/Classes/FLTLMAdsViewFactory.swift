import Flutter
import UIKit
import Flutter

public class FLTLMAdsViewFactory: NSObject,FlutterPlatformViewFactory {
    public func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        
//        let arid:NSNumber = args as? NSNumber ?? 1
//        let id:NSNumber = 0
//        if let view:FlutterPlatformView = manager.adFor(key:id ) as? FlutterPlatformView {
//            return view;
//        }else{
//            return UIView() as! FlutterPlatformView
//        }

        if let adId = args as? NSNumber {
            if let view:FlutterPlatformView = manager.adFor(key: adId) as? FlutterPlatformView {
                return view;
            }else{
                return UIView() as! FlutterPlatformView
            }
        }else{
            return UIView() as! FlutterPlatformView
        }
    }
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }

    var manager:FLTAdInstanceManager!
    public init(manager : FLTAdInstanceManager) {
        super.init()
        self.manager = manager
    }
}
