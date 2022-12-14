import Foundation

class ValidationError: Error {
    var message: String
    
    init(_ message: String) {
        self.message = message
    }
}

protocol ValidatorConvertible {
    func validated(_ value: String) -> (Bool,String)
}

enum ValidatorType {
    case email
    case password(field: String)
    case username(field: String)
    case requiredField(field: String)
    case age
    case phoneNo
}

enum VaildatorFactory {
    static func validatorFor(type: ValidatorType) -> ValidatorConvertible {
        switch type {
        case .email: return EmailValidator()
        case .password(let fieldName): return PasswordValidator(fieldName)
        case .username(let fieldName): return UserNameValidator(fieldName)
        case .requiredField(let fieldName): return RequiredFieldValidator(fieldName)
        case .age: return AgeValidator()
        case .phoneNo: return PhoneNoValidator()
        }
    }
}



class AgeValidator: ValidatorConvertible {
    func validated(_ value: String) -> (Bool, String)
    {
        guard value.count > 0 else{return (false,ValidationError("Age is required").message)}
        guard let age = Int(value) else {return (false,ValidationError("Age must be a number!").message)}
        guard value.count < 3 else {return (false,ValidationError("Invalid age number!").message)}
        guard age >= 18 else {return (false,ValidationError("You have to be over 18 years old to user our app :)").message)}
        return (true, "")
    }
}

struct RequiredFieldValidator: ValidatorConvertible {
    private let fieldName: String
    
    init(_ field: String) {
        fieldName = field
    }
    
    func validated(_ value: String) -> (Bool, String) {
        guard !value.isEmpty else {
            return (false,ValidationError("Please enter " + fieldName).message)
        }
        return (true,"Your password can’t start or end with a blank space")
    }
}
struct UserNameValidator: ValidatorConvertible {
    private let fieldName: String
    
    init(_ field: String) {
        fieldName = field
    }
    func validated(_ value: String) -> (Bool, String) {
        guard value != "" else {return (false,ValidationError("Please enter \(fieldName)").message)}
        
        guard value.count >= 3 else {
            return (false , ValidationError("\(fieldName) must contain more than three characters").message)
            //            ValidationError("Username must contain more than three characters" )
        }
        guard value.count <= 15 else {
            return (false , ValidationError("\(fieldName) shoudn't contain more than 15 characters").message)
            //            throw ValidationError("Username shoudn't conain more than 18 characters" )
        }
        
        do {
            if try NSRegularExpression(pattern: "[!\"#$%&'()*+,-./:;<=>?@\\[\\\\\\]^_`{|}~]+",  options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) != nil {
                return (false,ValidationError("Invalid \(fieldName), \(fieldName) should not contain numbers or special characters").message)
            }
        } catch {
            return (false,ValidationError("Invalid \(fieldName), \(fieldName) should not contain numbers or special characters").message)
        }
        return (true , "")
        //        return value
    }
    
    /* func validated(_ value: String) throws -> String {
     guard value.count >= 3 else {
     throw ValidationError("Username must contain more than three characters" )
     }
     guard value.count < 18 else {
     throw ValidationError("Username shoudn't conain more than 18 characters" )
     }
     
     do {
     if try NSRegularExpression(pattern: "^[a-z]{1,18}$",  options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
     throw ValidationError("Invalid username, username should not contain whitespaces, numbers or special characters")
     }
     } catch {
     throw ValidationError("Invalid username, username should not contain whitespaces,  or special characters")
     }
     return value
     } */
}
struct PasswordValidator: ValidatorConvertible {
    private let fieldName: String
    
    init(_ field: String) {
        fieldName = field
    }
    func validated(_ value: String)  -> (Bool,String) {
        guard value != "" else {return (false,ValidationError("Please enter \(fieldName)").message)}
        guard value.count >= 8 else { return (false,ValidationError("Password must have at least 8 characters").message) }
        return (CheckWhiteSpaceOnBeginToEnd(value: value))
        return (true, "")
    }
    func CheckWhiteSpaceOnBeginToEnd(value:String) -> (Bool,String)
    {
        if value.hasPrefix(" ") || value.hasSuffix(" ")
        {
            return (false,"Your password can’t start or end with a blank space")
        }
        return (true,"")
    }
}

struct EmailValidator: ValidatorConvertible {
    func validated(_ value: String)  -> (Bool,String) {
        do {
            guard value.trimmingCharacters(in: .whitespacesAndNewlines) != "" else {return (false,ValidationError("Please enter email").message)}
            if try NSRegularExpression(pattern: "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$", options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
                            return (false,ValidationError("Please enter a valid email").message)
                        }
        } catch {
            return (false,ValidationError("Please enter a valid email").message)
        }
        return (true, "")
    }
}
struct PhoneNoValidator: ValidatorConvertible {
    func validated(_ value: String) -> (Bool,String) {
        guard value != "" else {return (false,ValidationError("Please enter contact number").message)}
//        guard value.count >= 8 else { return (false,ValidationError("Please enter valid contact number").message)}
        guard value.count <= 10 else { return (false,ValidationError("Please enter valid contact number").message)}
        return (true, "")
    }
}
