//
//  OnlinePaymentViewController.swift
//  POD
//
//  Created by Apple on 28/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import WebKit

protocol OnlinePaymentProtocal {
  //protocol definition goes here
    func GetTransactionId(transactionID:String,status:Bool);
}

class OnlinePaymentViewController: BaseViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    var salt_str = "3a405cd6b78a2c4f429edca4bb6c5c153be89364"
    var api_key_str = "dc8d1b1d-f962-41f6-a493-884ba105f51a"
    var return_url_str = "https://www.podahmedabad.com/"
    public var  totalAmount:String = "0.00"
    public var del:OnlinePaymentProtocal?
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self;
        let order_id_str = self.GenerateNumber()
        let mode_str = "LIVE"
        let amount_str = totalAmount
        let currency_str = "INR"
        let description_str = "POD"
        let name_str = Constant.OrderDic!["Name"] as! String
        let email_str = Constant.OrderDic!["Email"] as! String
        let phone_str = "8333873777"
        let address_line_1_str = "Ahmedabad"
        let address_line_2_str = "Ahmedabad"
        let city_str = "Ahmedabad"
        let country_str = "INR"
        let zip_code_str = "380002"
        
        let paymentRequestDictionary = [
            "api_key" : api_key_str,
            "order_id" : order_id_str,
            "mode" : mode_str,
            "amount" : amount_str,
            "currency" : currency_str,
            "description" : description_str,
            "name" : name_str,
            "email" : email_str,
            "phone" : phone_str,
            "address_line_1" : address_line_1_str,
            "address_line_2" : address_line_2_str,
            "city" : city_str,
            "country" : country_str,
            "zip_code" : zip_code_str,
            "state" : "Gujarat",
            "return_url" : return_url_str
        ]
        var hashData = salt_str
        var post = ""
        let paymentRequestSortedTuple = paymentRequestDictionary.sorted(by: <)
        for paymentRequestElement in paymentRequestSortedTuple {
            if !(paymentRequestElement.value == ""){
                hashData = hashData + ("|")
                hashData = hashData + (paymentRequestElement.value)
                post = post + ("\(paymentRequestElement.key)=\(paymentRequestElement.value)&")
            }
        }
        
        let hash = sha512Hex(string: hashData)
        post = post + ("hash=\(hash.uppercased())")
        let postData: Data? = post.data(using: .ascii, allowLossyConversion: true)
        let url = URL(string: "https://biz.traknpay.in/v2/paymentrequest")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("\(UInt(postData?.count ?? 0))", forHTTPHeaderField: "Content-Length")
        request.httpBody = postData
        webView.delegate = self
        webView.loadRequest(request)
        // Do any additional setup after loading the view.
    }
    
    func sha512Hex( string: String) -> String {
           var digest = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
           if let data = string.data(using: String.Encoding.utf8) {
               let value =  data as NSData
               CC_SHA512(value.bytes, CC_LONG(data.count), &digest)
               
           }
           var digestHex = ""
           for index in 0..<Int(CC_SHA512_DIGEST_LENGTH) {
               digestHex += String(format: "%02x", digest[index])
           }
           
           return digestHex
       }

       func webViewDidStartLoad(_ webView: UIWebView) {
           print("Started Page load")
       }
       
       func webViewDidFinishLoad(_ webView: UIWebView) {
           print("Finished Page load: \(webView.request?.url?.absoluteString ?? "")")
           if (webView.request?.url?.absoluteString == return_url_str) {
               let postData: Data? = webView.request?.httpBody
               var paymentResponse: String? = nil
               if let aData = postData {
                paymentResponse = String(data: aData, encoding: .utf8)
                let components = paymentResponse!.components(separatedBy: "&")
                var dictionary : [String : String] = [:]
                for component in components{
                  let pair = component.components(separatedBy: "=")
                  dictionary[pair[0]] = pair[1]
                }
                if((dictionary["response_message"]!) == "Transaction+successful"){
                    del?.GetTransactionId(transactionID: (dictionary["transaction_id"]!), status: true)
                }
                else{
                    del?.GetTransactionId(transactionID: (dictionary["transaction_id"]!), status: false)
                }
                self.navigationController?.popViewController(animated: true)
                print("Response: \(dictionary)")
            }
        }
    }
    
    func GenerateNumber() -> String{
        let baseIntA = Int(arc4random() % 65535)
        let baseIntB = Int(arc4random() % 65535)
        let str = String(format: "%06X%06X", baseIntA, baseIntB)
        return str;
    }

}
