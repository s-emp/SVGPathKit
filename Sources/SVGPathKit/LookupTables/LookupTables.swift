extension SVGPathKit {
    static let svgPathCommands: [Bool] = {
        var table = Array(repeating: false, count: 256)
        
        // Move commands
        table[77] = true   // M
        table[109] = true  // m
        
        // Line commands
        table[76] = true   // L
        table[108] = true  // l
        table[72] = true   // H
        table[104] = true  // h
        table[86] = true   // V
        table[118] = true  // v
        
        // Curve commands
        table[67] = true   // C
        table[99] = true   // c
        table[83] = true   // S
        table[115] = true  // s
        table[81] = true   // Q
        table[113] = true  // q
        table[84] = true   // T
        table[116] = true  // t
        
        // Arc command
        table[65] = true   // A
        table[97] = true   // a
        
        // Close path command
        table[90] = true   // Z
        table[122] = true  // z
        
        return table
    }()
    
    static let svgNumberStartChars: [Bool] = {
        var table = Array(repeating: false, count: 256)
        
        // Digits
        table[48] = true   // 0
        table[49] = true   // 1
        table[50] = true   // 2
        table[51] = true   // 3
        table[52] = true   // 4
        table[53] = true   // 5
        table[54] = true   // 6
        table[55] = true   // 7
        table[56] = true   // 8
        table[57] = true   // 9
        
        // Signs
        table[43] = true   // +
        table[45] = true   // -
        
        // Decimal point
        table[46] = true   // .
        
        return table
    }()
}
