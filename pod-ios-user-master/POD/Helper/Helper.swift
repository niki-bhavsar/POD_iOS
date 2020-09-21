//
//  Helper.swift
//  POD
//
//  Created by Apple on 29/11/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import CoreLocation
import NotificationBannerSwift
import SCLAlertView
class Constant{
    
    public static var APIKey:String = "123456789123456789"
    //private static var serverURL:String = "https://projects.seawindsolution.com/YOGDEV/POD/Webservices"
    private static var serverURL:String = "https://www.podahmedabad.com/test/Webservices"//"https://www.podahmedabad.com/Webservices"
    
    public static var loginUrl:String = Constant.serverURL+"/customerLogin"
    public static var signUpUrl:String = Constant.serverURL+"/customerRegistration"
    public static var ForgetpasswordUrl:String = Constant.serverURL+"/customerLogin"
    public static var ParentCategoryUrl:String = Constant.serverURL+"/getAllParentsCategory"
    public static var SubCategoryByIdUrl:String = Constant.serverURL+"/getCategorysById/"
    public static var getOTPURL:String = Constant.serverURL+"/customerRegistrationSendOTP"
    public static var getResendURL:String = Constant.serverURL+"/customerRegistrationSendOTP"
    public static var insertTrackingDataURL:String = Constant.serverURL+"/insertTrackingData"
    public static var forgetPassOTPURL:String = Constant.serverURL+"/customerForgotPasswordSendOTP"
    public static var forgetPasswordResend:String = Constant.serverURL+"/customerForgotPasswordReSendOTP"
    public static var ResetPasswordSubMitURL:String = Constant.serverURL+"/customerResetPassword"
    public static var ChangedPasswordURL:String = Constant.serverURL+"/changeCustomerPassword"
    public static var updateCustomerProfileURL:String = Constant.serverURL+"/updateCustomerProfile"
    public static var getCustomerProfileURL:String = Constant.serverURL+"/getCustomerProfileByCustomerId"
    public static var getHelpInfoURL:String = Constant.serverURL+"/get247SupportSettings"
    
    public static var getAddressList:String = Constant.serverURL+"/getAllCustomerAddressByCustomerId/"
    public static var editAddressURL:String = Constant.serverURL+"/editCustomerAddress"
    public static var getAddreesByIDURL:String = Constant.serverURL+"/getAllCustomerAddressByCustomerId/"
    public static var deleteAddressById:String = Constant.serverURL+"/deleteCustomerAddress"
    public static var addAddressURL:String = Constant.serverURL+"/addNewCustomerAddress"
    public static var getTrasportationChargeURL:String = Constant.serverURL+"/getTransportationCharge"
     public static var getOrdersbyIDURL:String = Constant.serverURL+"/getOrderByCustomerId/"
    public static var getOrdersbyOrderIDURL:String = Constant.serverURL+"/getOrderByOrderId/"
    public static var sendGeneralInquiry:String = Constant.serverURL+"/addGeneralQuery"
    public static var CreateOrderURL:String = Constant.serverURL+"/createOrder"
    public static var orderIssueURL:String = Constant.serverURL+"/orderIssue"
    public static var inquirySubmitURL:String = Constant.serverURL+"/BookingInquiry"
     public static var gatePageURL:String = Constant.serverURL+"/getpage/"
    
     public static var extendOrderRequestURL:String = Constant.serverURL+"/extendOrderRequest"
    public static var extendOrderPaymentURL:String = Constant.serverURL+"/extendOrderPayment"
    public static var getCityListURL:String = Constant.serverURL+"/getMasterDetails/2/3"
     public static var getLocatonListURL:String = Constant.serverURL+"/getMasterDetails"
    
    public static var getMessageURL:String = Constant.serverURL+"/getMessages/"
    
    public static var SendMessageURL:String = Constant.serverURL+"/sendMessages/"
    public static var SendAdminMessageURL:String = Constant.serverURL+"/sendChatMessages/"
    public static var GetdminMessageURL:String = Constant.serverURL+"/getChatMessages"
    public static var getBannersURL:String = Constant.serverURL+"/getBanner"
    public static var getNotificationbyIDURL:String = Constant.serverURL+"/getCustomNotification/"
    public static var deleteNotificationbyIDURL:String = Constant.serverURL+"/deleteCustomNotification/"
    public static var photographOrderPaymentURL:String = Constant.serverURL+"/photographOrderPayment/"
    public static var getBookingInquiryURL:String = Constant.serverURL+"/getBookingInquiry/"
    public static var getFAQURL:String = Constant.serverURL+"/getFAQ/"
    public static var deleteAllNotification:String = Constant.serverURL+"/clearAllCustomerNotificationBycustomerId/"
    public static var deleteAllInquiry:String = Constant.serverURL+"/clearAllBookingInquiryByCustomerId/"
    public static var deleteInquiry:String = Constant.serverURL+"/clearAllBookingInquiryByCustomerIdInquieryId/"
    public static var searchAddressURL:String = Constant.serverURL+"/getMapArea/"
    public static var getUnPaidOrderByCustomerIdURL:String = Constant.serverURL+"/getUnPaidOrderByCustomerId/"
    public static var PASOrderPaymentdURL:String = Constant.serverURL+"/PASOrderPayment"
    public static var getSuccessResponseURL:String = Constant.serverURL+"/getSuccessResponse"
     public static var getAppVersionURL:String = Constant.serverURL+"/GetAppVersion/1"
    
    public static var currLat: Double = 0.0
    public static var currLng: Double = 0.0
    
    public static var deviceToken: String = ""
    public static var FirstSubcategoryId: String = ""
    public static var AllSubcategoryId: String = ""
    public static var FirstSubcategory: String = ""
    public static var AllSubcategory: String = ""
    
    public static var AllSubcategoryArr = [String]()
    public static var AllSubcategoryIdArr = [String]()
    public static var SelectedAddress = [String:Any]()
    
    public static var OrderDic = [String:Any]()
    public static var InquiryDic =  [String:Any]()
    public static var SelectedSubCategory = [String:Any]()
    
    public static var SelectedCategory = [String:Any]()
    
    
    public static var TrasportationCharges: Double = 0.0
    
    public static var mainNav:UINavigationController?
    public static var notificationCount:Int = 0
    public static var IsOpenMenu:Bool = false
    public static var homeVC:HomeViewController?
}


class Helper: NSObject {
    
    public static var ISParentCategorySelected = false
    public static var ISINquery = false
    public static var rootNavigation :  UINavigationController?
    static  var banner:FloatGrowingNotificationBanner?
    
    class func getTopViewController() -> UIViewController {
           var topController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
           
           while ((topController?.presentedViewController) != nil) {
               topController = topController?.presentedViewController
           }
           
           return topController!
       }
    
    static func SetRoundImage(img:UIImageView!,cornerRadius:Int,borderWidth:Int=1,borderColor:UIColor = UIColor.white){
        img.layer.cornerRadius = CGFloat(cornerRadius)
        img.layer.borderColor = borderColor.cgColor
        img.layer.borderWidth=CGFloat(borderWidth)
    }
    
    public static func ShowAlertMessage(message:String,buttonTitle:String = "OK",vc:UIViewController,title:String="",bannerStyle:BannerStyle = BannerStyle.success){

        if(banner != nil){
            banner?.dismiss()
        }
        banner = FloatGrowingNotificationBanner(title: title, subtitle: message, style: bannerStyle,colors: CustomBannerColors())
        banner!.layer.cornerRadius = 5;
       
        banner!.show(on: vc,
        cornerRadius: 8,
        shadowColor: UIColor(red: 0.431, green: 0.459, blue: 0.494, alpha: 1),
        shadowBlurRadius: 16,
        shadowEdgeInsets: UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8))
    }
    
    public static func ShowAlertMessageWithHandlesr(message:String,buttonTitle:String = "OK",title:String="",vc:UIViewController,action:@escaping () -> Void){
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "AvenirNext-Regular", size: 20)!,
            kTextFont: UIFont(name: "AvenirNext-Regular", size: 14)!,
            kButtonFont: UIFont(name: "AvenirNext-Medium", size: 14)!,
            showCloseButton: false,
            circleBackgroundColor: UIColor.init(hexString: "#FBAF40")
            )
        let alertView = SCLAlertView(appearance: appearance)
        //alertView.addButton("OK", backgroundColor: nil, textColor: nil, showTimeout: nil, action: action)
        //alertView.view.backgroundColor = UIColor.init(hexString: "#FBAF40")
        alertView.addButton("OK",backgroundColor:UIColor.init(hexString: "#FBAF40") ,action: action)
        alertView.showSuccess(title, subTitle: message)
  
    }
    
    public static func ShowAlertMessageWithHandlesr(message:String,buttonTitle:String = "OK",title:String="",vc:UIViewController,actionOK:@escaping () -> Void,actionCancel:@escaping () -> Void){
          
          let appearance = SCLAlertView.SCLAppearance(
              kTitleFont: UIFont(name: "AvenirNext-Regular", size: 20)!,
              kTextFont: UIFont(name: "AvenirNext-Regular", size: 14)!,
              kButtonFont: UIFont(name: "AvenirNext-Medium", size: 14)!,
              showCloseButton: false,
              circleBackgroundColor: UIColor.init(hexString: "#FBAF40")
              )
          let alertView = SCLAlertView(appearance: appearance)
          //alertView.addButton("OK", backgroundColor: nil, textColor: nil, showTimeout: nil, action: action)
          //alertView.view.backgroundColor = UIColor.init(hexString: "#FBAF40")
          alertView.addButton("OK",backgroundColor:UIColor.init(hexString: "#FBAF40") ,action: actionOK)
        alertView.addButton("Cancel",backgroundColor:UIColor.init(hexString: "#FBAF40") ,action: {() -> Void in
            alertView.dismiss(animated: true, completion: nil)
        })
          alertView.showSuccess(title, subTitle: message)
    
      }
    
    public static func ShowAlertWithTextViewWithHandlesr(message:String,buttonTitle:String = "OK",title:String="",vc:UIViewController,actionOK:@escaping () -> Void,actionCancel:@escaping () -> Void,result:@escaping (_ txt:String) -> Void,oldText:String){
          
          let appearance = SCLAlertView.SCLAppearance(
              kTitleFont: UIFont(name: "AvenirNext-Regular", size: 20)!,
              kTextFont: UIFont(name: "AvenirNext-Regular", size: 14)!,
              kButtonFont: UIFont(name: "AvenirNext-Medium", size: 14)!,
              showCloseButton: false,
              circleBackgroundColor: UIColor.init(hexString: "#FBAF40")
              )
          let alertView = SCLAlertView(appearance: appearance)
          let textView = alertView.addTextView()
          textView.text = oldText;
          alertView.addButton("OK",backgroundColor:UIColor.init(hexString: "#FBAF40") ,action: {() -> Void in
            result(textView.text)
            alertView.dismiss(animated: true, completion: nil)
        })
        alertView.addButton("Cancel",backgroundColor:UIColor.init(hexString: "#FBAF40") ,action: {() -> Void in
            actionCancel();
            alertView.dismiss(animated: true, completion: nil)
            
        })
        textView.becomeFirstResponder()
        alertView.showEdit(title, subTitle: message,circleIconImage: UIImage(named: "Pin"))
    
      }
    
    public static func ArchivedUserDefaultObject(obj:Any,key:String){
        
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: obj)
        UserDefaults.standard.set(encodedData, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    public static func UnArchivedUserDefaultObject(key:String) -> Any {
        var decodedTeams:(Any)?;
        let decoded  = UserDefaults.standard.object(forKey: key) as? Data
        if(decoded != nil){
            decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded!)
            return decodedTeams;
        }
        return decodedTeams
    }
    
    public static func isObjectNotNil(object:AnyObject!) -> Bool
    {
        if object is NSNull
        {
            return true
        }
        
        return false
    }
    
    static func isValidPassword(testPwd : String?) -> Bool{
        guard testPwd != nil else {
            return false
        }
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[a-z]).{6,20}$")
        return passwordPred.evaluate(with: testPwd)

    }
    
    public static func ConvertDateToTime(dateStr:String,timeFormat:String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd HH:mm:ss"
        let date = dateFormatter.date(from: dateStr)
        dateFormatter.dateFormat = timeFormat
        if(date != nil){
            return dateFormatter.string(from: date!)
        }
        else{
          return  dateStr
        }
    }
    
    public static func TimeDifference(dateStr:String,timeFormat:String) -> String{
        
        let dateFormatter = DateFormatter()
        var userCalendar = Calendar.current
        userCalendar.timeZone = TimeZone.current
        let requestedComponent: Set<Calendar.Component> = [.hour,.minute,.second]
        dateFormatter.dateFormat = timeFormat
        let startTime = Date()
        let endTime = dateFormatter.date(from: dateStr)
        let timeDifference = userCalendar.dateComponents(requestedComponent, from: endTime!, to: startTime)
        print(timeDifference)
        let date = Calendar(identifier: .gregorian).date(from: timeDifference)
        dateFormatter.dateFormat = "HH:mm"
        timeDifference.hour
        let dateString =  (timeDifference.hour!.description)+":"+(timeDifference.minute! < 0 ?"00":timeDifference.minute!.description)//dateFormatter.string(from: date!)
        return dateString
   
    }
    
    public static func GetTime(dateStr:String,timeFormat:String,min:Int) -> String{
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy-MM-dd HH:mm.ss"
        var date = dateFormatter.date(from: dateStr)
           dateFormatter.dateFormat = timeFormat
           if(date != nil){
            var dt = (date?.addTimeInterval(TimeInterval.init(min)))
            return dateFormatter.string(from: date!)
           }
           else{
             return  dateStr
           }
       }
    
    
    public static func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String,txt:UITextView) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        let lon: Double = Double("\(pdblLongitude)")!
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon

        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)

        var addressString : String = ""
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]

                if pm.count > 0 {
                    let pm = placemarks![0]
                    
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                    txt.text = addressString
                    print(addressString)
                }
        })
    }
    
    public static func GetOrderStatusName(index:Int)-> String{
        var status:String?
        if(index==1){
            status = "Pending"
        }
        else if(index==2){
            status = "Confirmed"
        }
        else if(index==3){
            status = "Reschedule"
        }
        else if(index==4){
            status = "Cancel"
        }
        else if(index==5){
            status = "Shooting"
        }
        else if(index==6){
            status = "Completed"
        }
        return status ?? "";
     
    }
    
    public static func GetPhotoGrapherStatusName(index:Int)-> String{
        var status:String?
        if(index==1){
            status = "Pending"
        }
        else if(index==2){
            status = "Sorting out"
        }
        else if(index==3){
            status = "Retouching"
        }
        else if(index==4){
            status = "Quality Check"
        }
        else if(index==5){
            status = "Uploading"
        }
        else if(index==6){
            status = "Delivered"
        }
        else if(index==7){
            status = "Downloaded"
        }
        return status ?? "";
     
    }
    
    public static func GetOrderDetailStatusName(index:Int)-> String{
           var status:String?
           if(index==1){
               status = "Placed"
           }
           else if(index==2){
               status = "Confirmed"
           }
           else if(index==3){
               status = "Reschedule"
           }
           else if(index==4){
               status = "Cancel"
           }
           else if(index==5){
               status = "OnGoing"//"Shooting"
           }
           else if(index==6){
               status = "Completed"
           }
           return status ?? "";
        
       }
    
    public static func GetPaymentStatusName(index:Int)-> String{
        var status:String?
        if(index==1){
            status = "Paid"
        }
        else if(index==2){
            status = "Unpaid"
        }
        else if(index==3){
            status = "Pending"
        }
        else if(index==4){
            status = "Refund"
        }
        return status ?? "";
    }
    
    public static func GetExtendOrderStatusName(index:Int)-> String{
        var status:String?
        if(index==1){
            status = "Request Place"
        }
        else if(index==2){
            status = "Payment Pending"
        }
        else if(index==3){
            status = "No Extend"
        }
        else if(index==4){
            status = "Extend Approve"
        }
        else if(index==5){
            status = "OnGoing"//"Shooting"
        }
        else if(index==6){
            status = "Completed"
        }
        return status ?? "";
     
    }
    
    public static func SetHTMLContent(desc:String,txtView:UITextView){
        let htmlData = NSString(string: desc).data(using: String.Encoding.unicode.rawValue)

        let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]

        let attributedString = try! NSAttributedString(data: htmlData!, options: options, documentAttributes: nil)

        txtView.attributedText = attributedString
    }
    
    public static func TimeDiff(endTime:String) -> String{

        let calendar = Calendar.current
        let h    = calendar.component(.hour, from: Date())
        let m  = calendar.component(.minute, from: Date())
        
        let newendtime = Helper.timeConversion12(time24: endTime)
        let neweCurrentTime = Helper.timeConversion12(time24: "\(h):\(m)")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mma"

        let date1 = formatter.date(from: neweCurrentTime)!
        let date2 = formatter.date(from: newendtime)!
        
        let elapsedTime = date2.timeIntervalSince(date1)

        let hours = floor(elapsedTime / 60 / 60)

        let minutes = floor((elapsedTime - (hours * 60 * 60)) / 60)
        print("DDDDDD--\(Int(hours)) hr and \(Int(minutes)) min")
        return "\(Int(hours)):\(Int(minutes))"
        //
    }
    
    static func  timeConversion12(time24: String) -> String {
        let dateAsString = time24
        let df = DateFormatter()
        df.dateFormat = "HH:mm"

        let date = df.date(from: dateAsString)
        df.dateFormat = "hh:mma"

        let time12 = df.string(from: date!)
        print(time12)
        return time12
    }
    
    

}

class CustomBannerColors: BannerColorsProtocol {

    internal func color(for style: BannerStyle) -> UIColor {
        switch style {
        case .danger:
        return UIColor.init(hexString: "#cc3300")
        break    // Your custom .danger color
        case .info:
             return UIColor.init(hexString: "#99cc33")
            break        // Your custom .info color
        
        case .success:
            return UIColor.init(hexString: "#339900")
            break
        // Your custom .success color
        case .warning:
            return UIColor.init(hexString: "#ff9966")
            break    // Your custom .warning color
        case .none: break
            
        }
        
        return UIColor.green;
    }

}

@IBDesignable extension UITextField {
    @IBInspectable var leftSpace:CGFloat {
        set {
            leftViewMode = ViewMode.always
            leftView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: newValue, height: frame.size.height))
        }
        get{
            return 20
            
        }
    }
    
    
    
    @IBInspectable var leftImage:UIImage {
        set {
            leftViewMode = ViewMode.always
            let imgView = UIImageView.init(frame: CGRect(x: 10, y: 0, width: 30, height: 30))
            let view = UIView.init(frame: CGRect(x: 0, y: 0, width: 45, height: 30))
            imgView.image = newValue
            view.addSubview(imgView)
            leftView = view
        }
        get{
            return UIImage.init()
            
        }
    }
    
    @IBInspectable var RightImage:UIImage {
        set {
            rightViewMode = ViewMode.always
            let imgView = UIImageView.init(frame: CGRect(x: 10, y: 0, width: 30, height: 30))
            let view = UIView.init(frame: CGRect(x: 0, y: 0, width: 45, height: 30))
            imgView.image = newValue
            view.addSubview(imgView)
            rightView = view
        }
        get{
            return UIImage.init()
            
        }
    }
    
    @IBInspectable var PlaceholderColor:UIColor {
        set {
            
            self.attributedText =   NSAttributedString(string:self.placeholder ?? "",
                                                       attributes: [NSAttributedString.Key.foregroundColor: newValue])
        }
        get{
            return UIColor.lightGray
        }
    }
    
    
}

@IBDesignable extension UIView {
    @IBInspectable var CornerRadius:CGFloat {
        set {
            self.layer.cornerRadius = newValue
        }
        get{
            return 5
        }
    }
    
    @IBInspectable var BorderWidth:CGFloat {
        set {
            self.layer.borderWidth = newValue
        }
        get{
            return 5
        }
    }
    
    @IBInspectable var BorderColor:UIColor {
        set {
            
            self.layer.borderColor = newValue.cgColor
        }
        get{
            return UIColor.lightGray
        }
    }
    
    @IBInspectable var IsShadow:Bool {
        set {
            if(newValue == true){
//                self.layer.shadowColor = UIColor.lightGray.cgColor
//                self.layer.shadowOpacity = 1
//                self.layer.shadowOffset = .init(width: 5, height: 5)
//                self.layer.shadowRadius = 10
//                self.layer.masksToBounds = false;
//                self.clipsToBounds = true;
//

                // drop shadow
                self.layer.shadowColor = UIColor.lightGray.cgColor
                self.layer.shadowOpacity = 0.8
                self.layer.shadowRadius = 3.0
                self.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            }
            
        }
        get{
            return false
        }
    }
    
    @IBInspectable var TopBorderShadow:Bool{
        set {
            if(newValue == true){
                let bottomLayer = CALayer()
                bottomLayer.frame = CGRect(x: 0, y: 0, width: frame.width - 2, height: 1)
                bottomLayer.backgroundColor = UIColor.white.cgColor
                self.layer.addSublayer(bottomLayer)
                //For Shadow
                self.layer.shadowColor = UIColor.white.cgColor
                self.layer.shadowOffset = CGSize.init(width: 0.0, height: 2.0)
                self.layer.shadowOpacity = 1.0
                self.layer.shadowRadius = 0.0
                self.layer.masksToBounds = false
                self.layer.cornerRadius = 4.0
            }
            
        }
        get{
            return false
        }
    }
}

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}

@IBDesignable class PaddingLabel: UILabel {

    @IBInspectable var topInset: CGFloat = 5.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 7.0
    @IBInspectable var rightInset: CGFloat = 7.0

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}
extension String
{
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat
    {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
}
