//
//  FonzyCutsViewController.swift
//  Fonzy
//
//  Created by fitmap on 2/3/18.
//  Copyright © 2018 Biocore. All rights reserved.
//

import UIKit

class FonzyCutsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var popularCutsCollectionView: UICollectionView!
    @IBOutlet weak var recentCutsCollectionView: UICollectionView!
    
    let popularCutsIdentifier = "popularCutsCell"
    let recentIdentifier = "recentCutsCell"
    
    var popularCuts = [UIImage]()
    var recentCuts = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        popularCutsCollectionView.delegate = self
        popularCutsCollectionView.dataSource = self
        
        recentCutsCollectionView.delegate = self
        recentCutsCollectionView.dataSource = self
        
        if let image = UIImage(named: "FrontBarbershop"){
            if let banner = bannerImage {
                banner.image = image
            }
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadInstagramFeed()
        loadPopularCuts()
        loadRecentCuts()
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if collectionView == self.popularCutsCollectionView {
            return popularCuts.count
        }else{
            return recentCuts.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.popularCutsCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: popularCutsIdentifier, for: indexPath) as? FonzyCutsCollectionViewCell else {
                fatalError("Oops I did it again!")
            }
            let img = popularCuts[indexPath.row]
            cell.picture.image = img
            cell.picture.layer.cornerRadius = cell.picture.bounds.size.width * 0.5
            cell.picture.clipsToBounds = true
            cell.picture.contentMode = .scaleAspectFill
            
            return cell
        }
        else{
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: recentIdentifier, for: indexPath) as? FonzyCutsCollectionViewCell else {
                fatalError("Cannot deque cell to hairdresserCell")
            }
            let img = popularCuts[indexPath.row]
            cell.picture.image = img
            cell.picture.contentMode = .scaleAspectFill
            
            return cell
        }
        
        
        
        //        let hairdresser = hairdressers[indexPath.row]
        //
        //        cell.profilePicture.image = hairdresser.profilePicture
        //        cell.name.text = hairdresser.name
        //
        //        cell.profilePicture.layer.cornerRadius = cell.profilePicture.bounds.size.width * 0.5
        //        cell.profilePicture.clipsToBounds = true
        //        cell.profilePicture.contentMode = .scaleAspectFill
        //
        //
        
        
    }
    
    
    
    func loadPopularCuts(){
        let img1 = UIImage(named: "FrontBarbershop")
        let img2 = UIImage(named: "6")
        let img3 = UIImage(named: "user")
        
        popularCuts.append(img1!)
        popularCuts.append(img2!)
        popularCuts.append(img3!)
    }
    
    func loadRecentCuts(){
        let img1 = UIImage(named: "FrontBarbershop")
        let img2 = UIImage(named: "6")
        let img3 = UIImage(named: "user")
        
        recentCuts.append(img1!)
        recentCuts.append(img2!)
        recentCuts.append(img3!)
    }
    
    
    // Load @Fonzy_App instagram pictures
    func loadInstagramFeed() {
        
        let urlString = Config.fonzyUrl + "instagram-feed"
        guard let instagramUrl = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: instagramUrl) { (data, response, err) in
            
            guard let data = data else { return }
            
            do{
                let instaFeed = try JSONDecoder().decode(InstagramFeed.self, from: data)
                
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                    
                    for image in instaFeed {
                        let imgUrl = URL(string: "\(image.images.standardResolution.url)")
                        let urlContents = try? Data(contentsOf: imgUrl!)
      
                        if let imageData = urlContents {
                            DispatchQueue.main.async {
                                if let image = UIImage(data: imageData) {
                                    self?.popularCuts.append(image)
                                    self?.popularCutsCollectionView.reloadData()
                                    self?.recentCuts.append(image)
                                    self?.recentCutsCollectionView.reloadData()
                                }
                            }
                        }
                    }
                }
            } catch let jsonErr {
                print("Error serializing JSON: ", jsonErr)
            }
        }.resume()
    }

    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
