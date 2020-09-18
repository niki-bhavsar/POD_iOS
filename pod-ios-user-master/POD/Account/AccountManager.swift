
import UIKit

class AccountManager: NSObject {
    
    var kActiveUserKey:String = "EncodedActive"
    
    private var _activeAccount:Account? = nil
    
    var activeAccount:Account? {
        set(newacc){
            self._activeAccount = newacc
            self.saveAccount()
        }
        get{
            return self._activeAccount
        }
    }
    
    var savedAccounts:NSMutableDictionary = NSMutableDictionary();
    
    class func instance() -> AccountManager {
        var singleton: AccountManager? = nil
        if singleton == nil {
            singleton = AccountManager()
        }
        
        return singleton!
    }
    
    override init() {
        super.init()
        
        let accountData:NSData? = UserDefaults.standard.object(forKey: kActiveUserKey) as! NSData?
        if(accountData != nil){
            activeAccount = (NSKeyedUnarchiver.unarchiveObject(with: accountData! as Data) as! Account)
        }
        
        let path:String = accountFileName()
        if(FileManager.default.fileExists(atPath: path) == false){
            return
        }
        
        savedAccounts = NSKeyedUnarchiver.unarchiveObject(withFile: accountFileName()) as! NSMutableDictionary
        
        if (savedAccounts is ExpressibleByNilLiteral){
            self.savedAccounts = NSMutableDictionary()
        }
    }
    
    func accountFileName() -> String{
        let doc_path: NSArray = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        return (doc_path[0] as AnyObject).appendingPathComponent("Account.dat")
    }
    
    func saveAccounts() -> Void{
        NSKeyedArchiver .archiveRootObject(savedAccounts, toFile: self.accountFileName())
    }
    
    func saveAccount() -> Void{
        var data:NSData? = nil
        
        if(activeAccount != nil){
            data = NSKeyedArchiver.archivedData(withRootObject: activeAccount!) as NSData?
        }
        
        if(data != nil){
            UserDefaults.standard.set(data, forKey: kActiveUserKey)
        }else{
            UserDefaults.standard.removeObject(forKey: kActiveUserKey)
        }
        
        if(activeAccount != nil){
//            let aKey = activeAccount?.mobileNumber as NSCopying?
//            savedAccounts.setObject(activeAccount!, forKey: aKey!)
//            self.saveAccounts()
        }
    }
}
