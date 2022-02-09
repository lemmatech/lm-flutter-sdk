import Flutter
import UIKit

public class FLTLMAdsCollection: NSObject {
    var dictionary = [AnyHashable: AnyHashable]()

    func setObject(obj : AnyHashable, key:AnyHashable) -> Void {
        self.dictionary[key] = obj
    }
    
    func removeObjectForKey( key:AnyHashable) -> Void {
        self.dictionary.removeValue(forKey: key)
    }

    func objectForKey( key:AnyHashable) -> Any? {
        return self.dictionary[key]
    }
    
    func allKeysForObject( object:AnyHashable) -> [Any] {
        var keys = [AnyHashable]()
        for (key, value) in self.dictionary {
            if value == object {
                keys.append(key)
            }
        }
        return keys
//        return self.dictionary.all
    }
    
    func removeAllObjects( ) -> Void {
        self.dictionary.removeAll()
    }
}
