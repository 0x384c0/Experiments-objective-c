
//
//  PublishSubject.swift
//  yesno
//
//  Created by Andrew Ashurow on 12/9/15.
//  Copyright © 2015 0x384c0. All rights reserved.
//

import UIKit

public extension NSString {
    var isNotBlank: Bool {
        return !(stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet()).characters.count == 0)
    }
}

public extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: "")
    }
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: comment)
    }
    var trimmed: String {
        return stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet())
    }
    
    
    var isEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(self)
    }
    var isBlank: Bool {
        return stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet()).characters.count == 0
    }
    
    func getHtml(withFontSize size:CGFloat) -> String{
        //let fontSize:Int = Int(size * UIScreen.mainScreen().scale)
        
        let body = self
        var html = "<!DOCTYPE html>"
//        html += "<html lang=\"en\"><head>"
//        html += "<meta http-equiv=\"content-type\" content=\"text/html; charset=utf-8\" />"
//        html += "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\">"
        html += "<style type=\"text/css\">"
        html += "body { "
        html += "font-family:  HelveticaNeue-Light !important; font-size:\(Int(size))px !important;"
//        html += "max-width:100%; width:auto; height:auto; margin-left:0; margin-right:0; "
        html += "}"
        html += "b { font-family: HelveticaNeue-Bold;  }"
        html += "strong { font-family: HelveticaNeue-Bold;  }"
        html += "em { font-family: HelveticaNeue-LightItalic;  }"
        html += "</style>"
        html += "</head>"
        html += "<body>"
        html += body
        html += "</body>"
        html += "</html>"
        
        return html
    }
    
    
    func replaceWithRegExp(find find:String,replace:String) -> String{
        let range = NSMakeRange(0, characters.count)
        if let regex = try? NSRegularExpression(pattern: find, options: .CaseInsensitive) {
            let modString = regex.stringByReplacingMatchesInString(
                self,
                options: .WithoutAnchoringBounds,
                range: range,
                withTemplate: replace
            )
            return modString
        }
        return self
    }
    
    
    
    static func fromCString (cs: UnsafePointer<CChar>, length: Int!) -> String? {
        if length == .None { // no length given, use \0 standard variant
            return String.fromCString(cs)
        }
        
        let buflen = length + 1
        let buf    = UnsafeMutablePointer<CChar>.alloc(buflen)
        memcpy(buf, cs, length)
        buf[length] = 0 // zero terminate
        let s = String.fromCString(buf)
        buf.dealloc(buflen)
        return s
    }    
    
}

extension Int{
    var stringValue:String {
        return String(self)
    }
}