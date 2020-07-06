https://stackoverflow.com/questions/24096708/what-is-the-swift-equivalent-of-isequaltostring-in-objective-c

extension String {
     func isEqualToString(find: String) -> Bool {
        return String(format: self) == find
    }
}
