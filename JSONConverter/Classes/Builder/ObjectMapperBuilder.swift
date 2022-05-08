//
//  ObjectMapperBuilder.swift
//  JSONConverter
//
//  Created by DevYao on 2021/12/9.
//  Copyright © 2021 Yao. All rights reserved.
//

import Foundation

private let MAPPER_SPACE = "   "
class ObjectMapperBuilder: BuilderProtocol {
    func isMatchLang(_ lang: LangType) -> Bool {
        return lang == .ObjectMapper
    }
    
    func propertyText(_ type: PropertyType, keyName: String, strategy: PropertyStrategy, maxKeyNameLength: Int, keyTypeName: String?) -> String {
        assert(!((type == .Dictionary || type == .ArrayDictionary) && keyTypeName == nil), " Dictionary type the typeName can not be nil")
        let tempKeyName = strategy.processed(keyName)
        switch type {
        case .String, .Null:
            return "\tvar \(tempKeyName): String?\n"
        case .Int:
            return "\tvar \(tempKeyName): Int = 0\n"
        case .Float:
            return "\tvar \(tempKeyName): Float = 0.0\n"
        case .Double:
            return "\tvar \(tempKeyName): Double = 0.0\n"
        case .Bool:
            return "\tvar \(tempKeyName): Bool = false\n"
        case .Dictionary:
            return "\tvar \(tempKeyName): \(keyTypeName!)?\n"
        case .ArrayString, .ArrayNull:
            return "\tvar \(tempKeyName) = [String]()\n"
        case .ArrayInt:
            return "\tvar \(tempKeyName) = [Int]()\n"
        case .ArrayFloat:
            return "\tvar \(tempKeyName) = [Float]()\n"
        case .ArrayDouble:
            return "\tvar \(tempKeyName) = [Double]()\n"
        case .ArrayBool:
            return "\tvar \(tempKeyName) = [Bool]()\n"
        case .ArrayDictionary:
            return "\tvar \(tempKeyName) = [\(keyTypeName!)]()\n"
        }
    }
    
    func initPropertyText(_ type: PropertyType, keyName: String, strategy: PropertyStrategy, maxKeyNameLength: Int, typeName: String?) -> String {
        let tempKeyName = strategy.processed(keyName)
        let spaceText = String.numSpace(count: maxKeyNameLength - tempKeyName.count)
        return "\t\t\(tempKeyName)\(spaceText) <- map[\"\(keyName)\"]\n"
    }
    
    func contentParentClassText(_ clsText: String?) -> String {
        return StringUtils.isEmpty(clsText) ? ": Mappable" : ": \(clsText!)"
    }
    
    func contentText(_ structType: StructType, clsName: String, parentClsName: String, propertiesText: inout String, propertiesInitText: inout String?, propertiesGetterSetterText: inout String?) -> String {
        if structType == .class {
            return "\nclass \(clsName)\(parentClsName) {\n\(propertiesText)\n\trequired init?(map: Map) {}\n\n\tfunc mapping(map: Map) {\n\(propertiesInitText!)\t}\n}\n"
        } else {
            return "\nstruct \(clsName)\(parentClsName) {\n\(propertiesText)\n\tinit?(map: Map) {}\n\n\tmutating func mapping(map: Map) {\n\(propertiesInitText!)\t}\n}\n"
        }
    }
    
    func fileSuffix() -> String {
        return "swift"
    }
    
    func fileImportText(_ rootName: String, contents: [Content], strategy: PropertyStrategy, prefix: String?) -> String {
        return"\nimport Foundation\nimport ObjectMapper\n"
    }
    
    func fileExport(_ path: String, config: File, content: String, classImplContent: String?) -> [Export] {
        let filePath = "\(path)/\(config.rootName.className(withPrefix: config.prefix))"
        return [Export(path: "\(filePath).\(fileSuffix())", content: content)]
    }
}
