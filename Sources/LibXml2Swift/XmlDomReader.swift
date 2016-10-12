//
//  XmlDomReader.swift
//  LibXml2Swift
//
//  Created by Dami on 12/10/2016.
//
//

import Foundation
import CLibxml

public class XmlDomReader {
    
    /// Read Xml document from path URL
    /// - Param path : URL of the Xml file
    /// - Returns XmlDomDocument
    /// - Throws XmlParserError
    public static func read(atPath path: URL) throws -> XmlDomDocument {
        
        // Check file exists
        guard FileManager.default.fileExists(atPath: path.path) else {
            throw XmlParserError.noFound(atUrl: path)
        }
        
        // Read document
        let doc = xmlReadFile(path.absoluteString, nil, 0)
        guard let documentPtr = doc else {
            throw XmlParserError.unknownError(msg: "Document nil")
        }
        
        return XmlDomDocument(pointer: documentPtr)
    }
}
