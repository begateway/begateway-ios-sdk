//
// Project «InputMask»
// Created by Jeorge Taflanidi
//


import Foundation


/**
 ### RTLMask

 A right-to-left ```Mask``` subclass. Applies format from the string end.
 */
class RTLMask: Mask {
    private static var cache: [String: RTLMask] = [:]
    
    required init(format: String, customNotations: [Notation] = []) throws {
        try super.init(format: format.reversedFormat(), customNotations: customNotations)
    }
    
    override class func getOrCreate(withFormat format: String, customNotations: [Notation] = []) throws -> RTLMask {
        if let cachedMask: RTLMask = cache[format.reversedFormat()] {
            return cachedMask
        } else {
            let mask: RTLMask = try RTLMask(format: format, customNotations: customNotations)
            cache[format.reversedFormat()] = mask
            return mask
        }
    }

    override func apply(toText text: CaretString, autocomplete: Bool = false) -> Result {
        return super.apply(toText: text.reversed(), autocomplete: autocomplete).reversed()
    }
    
    override func makeIterator(forText text: CaretString) -> CaretStringIterator {
        return RTLCaretStringIterator(caretString: text)
    }
}
