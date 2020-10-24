//
//  SelectGategoryViewController.swift
//  POD
//
//  Created by Apple on 05/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class SelectGategoryViewController : BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    public  var listCategory:[[String:Any]] = [[String:Any]]()
    public var categoryIndex:Int = 0;
    public var IsSelected:Bool = false;
    @IBOutlet var categoryCollection:UICollectionView?
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        categoryCollection?.isHidden = true;
        CategoryController.GetCategory(vc: self)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let screenWidth = categoryCollection!.frame.size.width
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: screenWidth/2.1, height: screenWidth/2)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 20
        categoryCollection!.collectionViewLayout = layout
        
        //categoryCollection?.reloadData()
        Helper.ISParentCategorySelected = false;
        categoryCollection?.isHidden = false;
        if(IsSelected){
        if(Constant.AllSubcategoryArr.count>categoryIndex){
            Constant.AllSubcategoryArr.remove(at: categoryIndex);
             Constant.AllSubcategoryIdArr.remove(at: categoryIndex);
            IsSelected = false;
        }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(listCategory != nil){
            if(listCategory.count>0){
                collectionView.restore()
            }
            else{
                collectionView.setEmptyMessage("No Category Found")
            }
            return listCategory.count
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
//        cell.delegate = self
        cell.SetData(dic: listCategory[indexPath.row])
        return cell
    }

    // MARK: - UICollectionViewDelegate protocol
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        Helper.ISParentCategorySelected = true
        let obj  = listCategory[indexPath.row]
        if(obj["isVariable"] as! String == "1"){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "SelectSubCategoryViewController") as! SelectSubCategoryViewController
            controller.categoryId = obj["Id"] as? String
            Constant.SelectedCategory = obj as [String : AnyObject];
            Constant.FirstSubcategory = obj["Title"] as! String
            categoryIndex = Constant.AllSubcategoryArr.count;
            Constant.AllSubcategoryArr.append(obj["Title"] as! String)
            Constant.AllSubcategoryIdArr.append(obj["Id"] as! String)
            print("-----------")
            print(Constant.AllSubcategoryArr)
            print(Constant.AllSubcategoryIdArr)
            print("-----------")
            Constant.AllSubcategoryId = (Constant.AllSubcategoryIdArr.map{String($0)}).joined(separator: ",")
            
            Constant.AllSubcategory = (Constant.AllSubcategoryArr.map{String($0)}).joined(separator: ",")
            
            print("-----Constant.AllSubcategory-----")
                       print(Constant.AllSubcategory)
                       print(Constant.AllSubcategoryId)
                       print("----Constant.AllSubcategory------")
            IsSelected = true;
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else{
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "BookingDetailViewController") as! BookingDetailViewController
            Constant.SelectedCategory = obj as [String : AnyObject];
            controller.Multiplier = obj["Multiplier"] as? String
//            
//            if(Constant.FirstSubcategoryId == ""){
//                Constant.FirstSubcategoryId =  obj["Id"] as! String
//                Constant.FirstSubcategory = obj["Title"] as! String
//            };
//            if(Constant.AllSubcategoryId == ""){
//                Constant.AllSubcategoryId =  obj["Id"] as! String
//                Constant.AllSubcategory = obj["Title"] as! String
//                
//            }
//            else{
//                
//                
//                
//                if Constant.AllSubcategoryId.contains((obj["Id"] as! String)) {
//                    print("exists")
//                }
//                else{
//                    Constant.AllSubcategoryId =  "\(Constant.AllSubcategoryId),\(obj["Id"] as! String)"
//                }
//                if Constant.AllSubcategory.contains(((obj["Title"] as? String) ?? "")) {
//                    print("exists")
//                }
//                else{
//                    Constant.AllSubcategory = "\(Constant.AllSubcategory),\(obj["Title"] as! String)"
//                }
//            }
//            
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
            IsSelected = true;
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    
    
    
//    func InfoTapped(at index: IndexPath) {
//        if(listCategory.count>index.row){
//        let obj  = listCategory[index.row]
//        if(obj["Content"] != nil){
//
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let controller = storyboard.instantiateViewController(withIdentifier: "InfoPopupViewController") as! InfoPopupViewController
//            controller.desc = (obj["Content"] as! String)
//            self.navigationController?.pushViewController(controller, animated: true)
////            controller.modalPresentationStyle = .overCurrentContext
////            controller.modalTransitionStyle = .crossDissolve
////            present(controller, animated: true, completion: nil)
//        }
//        }
//
//    }
    

}

