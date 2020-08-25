//
//  SelectSubCategoryViewController.swift
//  POD
//
//  Created by Apple on 06/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class SelectSubCategoryViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,CategoryActionButtonDelegate {

    @IBOutlet var subCategoryCollection:UICollectionView?
    public var categoryId:String?
     public var categoryIndex:Int = 0;
    public var IsSelected:Bool = false;
    public  var listSubCategory:[[String:Any]] = [[String:Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
         subCategoryCollection?.isHidden = true;
        CategoryController.GetSubCategoryById(categoryID: categoryId!, vc: self)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let screenWidth = subCategoryCollection!.frame.size.width
               let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
               layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
               layout.itemSize = CGSize(width: screenWidth/2.1, height: screenWidth/2)
               layout.minimumInteritemSpacing = 0
               layout.minimumLineSpacing = 20
               subCategoryCollection!.collectionViewLayout = layout
               subCategoryCollection?.isHidden = false;
        if(IsSelected){
        if(Constant.AllSubcategoryArr.count>categoryIndex){
            Constant.AllSubcategoryArr.remove(at: categoryIndex);
            Constant.AllSubcategoryIdArr.remove(at: categoryIndex);
            IsSelected = false;
        }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(listSubCategory != nil){
            if(listSubCategory.count>0){
                collectionView.restore()
            }
            else{
                collectionView.setEmptyMessage("No Category Found")
            }
            return listSubCategory.count
        }
        else{
            collectionView.setEmptyMessage("No Category Found")
            return 0;
        }
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath as IndexPath) as! CategoryCollectionCellCollectionViewCell
        cell.indexPath = indexPath
        cell.delegate = self;
        cell.SetData(dic: listSubCategory[indexPath.row])
        return cell
    }

    // MARK: - UICollectionViewDelegate protocol
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Helper.ISParentCategorySelected = true;
        let obj  = listSubCategory[indexPath.row]
        Constant.SelectedCategory = obj as [String : AnyObject];
        print("Constant.SelectedCategory-:\(Constant.SelectedCategory)")
        
        
        if(obj["isVariable"] as! String == "1"){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "SelectSubCategoryViewController") as! SelectSubCategoryViewController
            controller.categoryId = obj["Id"] as? String
//            if(Constant.FirstSubcategoryId == ""){
//                Constant.FirstSubcategoryId =  controller.categoryId!
//            };
//            if(Constant.FirstSubcategoryId == "")
//            {
//                Constant.FirstSubcategory =  (obj["Title"] as? String)!
//            }
//            if(Constant.AllSubcategoryId == ""){
//                Constant.AllSubcategoryId =  controller.categoryId!
//                Constant.AllSubcategory =  (obj["Title"] as? String)!
//            }
//            else{
//                if Constant.AllSubcategoryId.contains(controller.categoryId!) {
//                    print("exists")
//                }
//                else{
//                    Constant.AllSubcategoryId = "\(Constant.AllSubcategoryId),\(controller.categoryId ?? "")"
//                }
//                if Constant.AllSubcategoryId.contains(((obj["Title"] as? String) ?? "")) {
//                    print("exists")
//                }
//                else{
//                    Constant.AllSubcategory = "\(Constant.AllSubcategory),\((obj["Title"] as? String) ?? "")"
//                }
//            }
//
            categoryIndex = Constant.AllSubcategoryArr.count;
            Constant.AllSubcategoryArr.append(obj["Title"] as! String)
            Constant.AllSubcategoryIdArr.append(obj["Id"] as! String)
            
            Constant.AllSubcategoryId = (Constant.AllSubcategoryIdArr.map{String($0)}).joined(separator: ",")
            Constant.AllSubcategory = (Constant.AllSubcategoryArr.map{String($0)}).joined(separator: ",")
                                          
                                          print("-----Constant.AllSubcategory-----")
                                          print(Constant.AllSubcategory)
                                          print(Constant.AllSubcategoryId)
                                          print("----Constant.AllSubcategory------")
            print("-----------")
            print(Constant.AllSubcategoryArr)
            print(Constant.AllSubcategoryIdArr)
            print("-----------")
            IsSelected = true;
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "BookingDetailViewController") as! BookingDetailViewController
//            if(Constant.FirstSubcategoryId == ""){
//                Constant.FirstSubcategoryId = obj["Id"] as! String
//                Constant.FirstSubcategory =  (obj["Title"] as? String)!
//            }
//            else{
//                if Constant.FirstSubcategory.contains(((obj["Title"] as? String) ?? "")) {
//                    print("exists")
//                }
//                else{
//                    Constant.FirstSubcategory =  "\(Constant.FirstSubcategory),\((obj["Title"] as? String) ?? "")"
//                }
//
//            }
//            if(Constant.AllSubcategoryId == ""){
//                Constant.AllSubcategoryId =  obj["Id"] as! String
//                Constant.AllSubcategory =  (obj["Title"] as? String)!
//            }
//            else{
//                if Constant.AllSubcategory.contains(((obj["Title"] as? String) ?? "")) {
//                    print("exists")
//                }
//                else{
//                    Constant.AllSubcategory = "\(Constant.AllSubcategory),\((obj["Title"] as? String) ?? "")"
//                }
//
//                if Constant.AllSubcategoryId.contains((obj["Id"] as! String)) {
//                    print("exists")
//                }
//                else{
//                    Constant.AllSubcategoryId =  "\(Constant.AllSubcategoryId),\(obj["Id"] as! String)"
//                }
//            }
//
            categoryIndex = Constant.AllSubcategoryArr.count;
            Constant.AllSubcategoryArr.append(obj["Title"] as! String)
            Constant.AllSubcategoryIdArr.append(obj["Id"] as! String)
            
            Constant.AllSubcategoryId = (Constant.AllSubcategoryIdArr.map{String($0)}).joined(separator: ",")
            Constant.AllSubcategory = (Constant.AllSubcategoryArr.map{String($0)}).joined(separator: ",")
                                          
                                          print("-----Constant.AllSubcategory-----")
                                          print(Constant.AllSubcategory)
                                          print(Constant.AllSubcategoryId)
                                          print("----Constant.AllSubcategory------")
            print("-----------")
            print(Constant.AllSubcategoryArr)
            print(Constant.AllSubcategoryIdArr)
            print("-----------")
            
            IsSelected = true;
            controller.Multiplier = obj["Multiplier"] as? String
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func InfoTapped(at index: IndexPath) {
        if(listSubCategory.count>index.row){
        let obj  = listSubCategory[index.row]
        if(obj["Content"] != nil){
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "InfoPopupViewController") as! InfoPopupViewController
            controller.desc = (obj["Content"] as! String)
            controller.modalPresentationStyle = .overCurrentContext
            controller.modalTransitionStyle = .crossDissolve
            present(controller, animated: true, completion: nil)
        }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
