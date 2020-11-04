//
//  InquerySubCategoryViewController.swift
//  POD
//
//  Created by Apple on 07/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class InquerySubCategoryViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, CategoryActionButtonDelegate {
    
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
        InqueryController.GetSubCategoryById(categoryID: categoryId!, vc: self)
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
        cell.delegate = self
        cell.SetData(dic: listSubCategory[indexPath.row])
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Helper.ISParentCategorySelected = true;
        let obj  = listSubCategory[indexPath.row]
        Constant.SelectedCategory = obj as [String : AnyObject];
        if(obj["isVariable"] as! String == "1"){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "InquerySubCategoryViewController") as! InquerySubCategoryViewController
            controller.categoryId = obj["Id"] as? String
            categoryIndex = Constant.AllSubcategoryArr.count;
            Constant.AllSubcategoryArr.append(obj["Title"] as! String)
            Constant.AllSubcategoryIdArr.append(obj["Id"] as! String)
            Constant.AllSubcategoryId = (Constant.AllSubcategoryIdArr.map{String($0)}).joined(separator: ",")
            Constant.AllSubcategory = (Constant.AllSubcategoryArr.map{String($0)}).joined(separator: ",")
            
            //            if(Constant.FirstSubcategoryId == ""){
            //                           Constant.FirstSubcategoryId =  controller.categoryId!
            //                       };
            //                       if(Constant.AllSubcategoryId == ""){
            //                           Constant.AllSubcategoryId =  controller.categoryId!
            //                       }
            //                       else{
            //                            Constant.AllSubcategoryId =  "\(Constant.AllSubcategoryId),\(controller.categoryId)"
            //                       }
            //                       print(Constant.FirstSubcategoryId)
            //                       print(Constant.AllSubcategoryId)
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "InqueryDetailViewController") as! InqueryDetailViewController
            //
            //            if(Constant.FirstSubcategoryId == ""){
            //                           Constant.FirstSubcategoryId =  obj["Id"] as! String
            //                       };
            //                       if(Constant.AllSubcategoryId == ""){
            //                           Constant.AllSubcategoryId =  obj["Id"] as! String
            //                       }
            //                       else{
            //                            Constant.AllSubcategoryId =  "\(Constant.AllSubcategoryId),\(obj["Id"] as! String)"
            //                       }
            categoryIndex = Constant.AllSubcategoryArr.count;
            Constant.AllSubcategoryArr.append(obj["Title"] as! String)
            Constant.AllSubcategoryIdArr.append(obj["Id"] as! String)
            Constant.AllSubcategoryId = (Constant.AllSubcategoryIdArr.map{String($0)}).joined(separator: ",")
            
            Constant.AllSubcategory = (Constant.AllSubcategoryArr.map{String($0)}).joined(separator: ",")
            
            Constant.InquiryDic["TypeOfShoot"] = "\(Constant.FirstSubcategoryId),\(Constant.AllSubcategoryId)"
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
    
}
