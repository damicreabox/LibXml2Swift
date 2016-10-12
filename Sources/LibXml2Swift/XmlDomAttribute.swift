//
//  XmlDomAttribute.swift
//  LibXml2Swift
//
//  Created by Dami on 12/10/2016.
//
//

import Foundation
import CLibxml

public class XmlDomAttribute {
    
    internal let attr: xmlAttrPtr
    
    public lazy var name : String = {
        return String(cString: self.attr.pointee.name)
    } ()
    
    public lazy var value : String = {
        
        // Find attr
        if let content = self.attr.pointee.children {
            return String(cString: content.pointee.content)
        }
        
        return ""
    } ()
    
    init(attr: xmlAttrPtr) {
        self.attr = attr
    }
}
