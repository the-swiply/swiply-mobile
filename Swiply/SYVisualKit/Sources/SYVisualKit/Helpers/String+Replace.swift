// MARK: - Helpers

func replace(_ string: String, _ index: Int, _ newChar: Character) -> String {
    var chars = Array(string)
    chars[index] = newChar
    let modifiedString = String(chars)
    return modifiedString
}
