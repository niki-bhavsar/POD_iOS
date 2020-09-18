
import UIKit

typealias AccountBlock = (_ success : Bool, _ request: Account, _ errorMessage: String) -> (Void)
class Account: NSObject ,NSCoding {
    var accountBlock: AccountBlock  = {_,_,_ in }
    
    
    var user_id : String = ""
    var name : String = ""
    var email : String = ""
    var phone : String = ""
    var gender : String = ""
    var dob : String = ""
    var profileImage : String = ""
    var termsCondition : String = ""
     var address : String = ""
    
    
    var loginToken : String = ""
    var isLoggedInWithEmail : String = ""
    
    let ENCODING_VERSION:Int = 1
    
    override init() {}
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(ENCODING_VERSION, forKey: "version")
        
        aCoder.encode(user_id, forKey: "user_id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(phone, forKey: "phone")
        aCoder.encode(gender, forKey: "gender")
        aCoder.encode(dob, forKey: "dob")
        aCoder.encode(profileImage, forKey: "profileImage")
        aCoder.encode(termsCondition, forKey: "termsCondition")
         aCoder.encode(address, forKey: "address")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        if(aDecoder.decodeInteger(forKey: "version") == ENCODING_VERSION) {
            email = aDecoder.decodeObject(forKey: "email") as! String
            phone = aDecoder.decodeObject(forKey: "phone") as! String
            user_id = aDecoder.decodeObject(forKey: "user_id") as! String
            name = aDecoder.decodeObject(forKey: "name") as! String
            gender = aDecoder.decodeObject(forKey: "gender") as! String
            dob = aDecoder.decodeObject(forKey: "dob") as! String
            profileImage = aDecoder.decodeObject(forKey: "profileImage") as! String
            termsCondition = aDecoder.decodeObject(forKey: "termsCondition") as! String
            address = aDecoder.decodeObject(forKey: "address") as! String
            
        }
    }
    
    func parseUserDict(userDict:NSDictionary, account : Account) {
        if let str = userDict.value(forKey: "Email") as? String{
            account.email = str
        }
        if let str = userDict.value(forKey: "Phone") as? String{
            account.phone = str
        }
        if let str = userDict.value(forKey: "Id") as? String{
            account.user_id = "\(str)"
        }
        if let str = userDict.value(forKey: "Name") as? String{
            account.name = str
        }
        if let str = userDict.value(forKey: "Gender") as? String{
            account.gender = str
        }
        if let str = userDict.value(forKey: "DOB") as? String{
            account.dob = str
        }
        if let str = userDict.value(forKey: "ProfileImage") as? String{
            account.profileImage = str
        }
        if let str = userDict.value(forKey: "TermsCondition") as? String{
            account.termsCondition = str
        }
        if let str = userDict.value(forKey: "Address") as? String{
            account.address = str
        }
        AccountManager.instance().activeAccount = account
    }
    
    
}
