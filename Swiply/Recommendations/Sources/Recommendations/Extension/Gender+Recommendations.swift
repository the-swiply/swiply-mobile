import SYCore

extension Gender {

    func isSutisfies(filter: ProfileGender) -> Bool {
        switch self {
        case .male:
            return filter == .male || filter == .any

        case .female:
            return filter == .female || filter == .any

        case .none:
            return false
        }
    }

}
