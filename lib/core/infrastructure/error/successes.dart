/// Generic type for a success operation, used in the
/// either tap for functional programming
class Success {}

/// Updated data in the database successfuly
class SuccessWithUpdate extends Success {}

/// Loaded data without updating it
class SuccessWithoutUpdate extends Success {}
