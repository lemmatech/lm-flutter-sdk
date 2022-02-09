import UIKit
import Flutter

let FLTLMFieldAdSize:UInt8 = 128
let FLTLMFieldAdRequest:UInt8 = 129
let FLTLMFieldLoadError:UInt8 = 133
let FLTLMFieldLocation:UInt8 = 147

class FLTLMAdsReaderWriter : FlutterStandardReaderWriter  {
    
    override func reader(with data: Data) -> FlutterStandardReader {
        return FLTLMMobileAdsReader(data: data)
    }
    
    override func writer(with data: NSMutableData) -> FlutterStandardWriter {
        return FLTLMMobileAdsWriter(data: data)
    }
}

class FLTLMMobileAdsReader : FlutterStandardReader  {

    override func readValue(ofType type: UInt8) -> Any? {
        
        let field = type;
        switch (field) {
        case FLTLMFieldAdSize:
            let size = FLTAdSize()
            size.width = self.readValue(ofType: self.readByte()) as? NSNumber
            size.height = self.readValue(ofType: self.readByte()) as? NSNumber
            return size
            
        case FLTLMFieldAdRequest:
            let request = FLTAdRequest()
            request.publisherId = self.readValue(ofType: self.readByte()) as? String
            request.adUnitId = self.readValue(ofType: self.readByte()) as? String
            request.serverURL = self.readValue(ofType: self.readByte()) as? String
            request.networkTimeout = self.readValue(ofType: self.readByte()) as? NSNumber
            request.switchToVideo = self.readValue(ofType: self.readByte()) as? Bool ?? false
            return request
            
        case FLTLMFieldLocation:
            let location = FLTLocationParams(latitude:self.readValue(ofType: self.readByte()) as! NSNumber,
                longitude: self.readValue(ofType: self.readByte()) as! NSNumber,
                accuracy: self.readValue(ofType: self.readByte()) as? NSNumber)
            return location
            
        case FLTLMFieldLoadError:
            let code = self.readValue(ofType: self.readByte()) as? NSNumber
            let domain = self.readValue(ofType: self.readByte()) as? String ?? ""
            let message = self.readValue(ofType: self.readByte()) as? NSString ?? ""
            let loadAdError = NSError(domain: domain, code:code?.intValue ?? 0 , userInfo: [NSLocalizedDescriptionKey:message])
            return loadAdError;
            
        default:
            return super.readValue(ofType:type)
        }
    }
}

class FLTLMMobileAdsWriter :  FlutterStandardWriter {

    override func writeValue(_ value: Any) {

        if (value is FLTAdSize) {
            self.writeByte(FLTLMFieldAdSize)
            if let value = value as? FLTAdSize {
                self.writeValue(value.width)
                self.writeValue(value.height)
            }
        }else if (value is FLTAdRequest) {
            self.writeByte(FLTLMFieldAdRequest)
            if let value = value as? FLTAdRequest{
                self.writeValue(value.publisherId)
                self.writeValue(value.adUnitId)
                self.writeValue(value.serverURL)
                self.writeValue(value.networkTimeout)
                self.writeValue(value.switchToVideo)
            }
        }else if (value is NSError) {
            self.writeByte(FLTLMFieldLoadError)
            if let value = value as? NSError{
                self.writeValue(value.code)
                self.writeValue(value.domain)
                self.writeValue(value.description)
            }
        }else if (value is FLTLocationParams) {
            self.writeByte(FLTLMFieldLocation)
            if let value = value as? FLTLocationParams{
                self.writeValue(value.latitude)
                self.writeValue(value.longitude)
                self.writeValue(value.accuracy)
            }
        }else{
            super.writeValue(value)
        }
    }
}


