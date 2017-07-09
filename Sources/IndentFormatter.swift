

/**
 Multiply string
 
 - parameter string: To increase string
 - parameter count: For increase number
 
 - returns: Increased new string value
 */
infix operator *
func * (string: String, count: Int) -> String {
    return stride(from: 0, to: count, by: 1).reduce("") { (result, _) in
        return result + string
    }
}

/**
 Configuration for IndentFormattable 
 
 - If you customize indent you can set `indent` property
*/
public struct IndentConfig {
    // Default 4 space
    public static var indent: String = "    "
    
    // Prepare for first `Indent`
    // First indent is none space
    public static var startIndentCount = -1
}

/**
 protocol for generate code with indent
 
 - parameter count: number of indent
 
 - returns: Generated code with indent
 */
public protocol IndentFormattable {
    func generate(for count: Int) -> String
}

/**
 Indent is to increase indent for contents 
 
 When create content for generate code, 
 you should init for Indent 
 
 When want to increase more indent,
 you can wrap Indent into parent Indent 
 
 */
public struct Indent: IndentFormattable {
    public var contents: [IndentFormattable]
    
    public init(
        _ contents: IndentFormattable...
        ) {
        self.contents = contents
    }
    
    public func generate(for count: Int = IndentConfig.startIndentCount) -> String {
        return contents.generate(for: count + 1)
    }
}

extension String: IndentFormattable {
    public func generate(for count: Int) -> String {
        let indent = IndentConfig.indent * count
        return indent + self + "\n"
    }
}

fileprivate extension Array where Element == IndentFormattable {
    func generate(for count: Int) -> String {
        return reduce("") { (result, indentable) -> String in
            return result + indentable.generate(for: count)
        }
    }
}
