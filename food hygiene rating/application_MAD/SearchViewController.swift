//
//  SearchViewController.swift
//  application_MAD
//
//  Created by Jibin George on 13/03/2018.
//  Copyright © 2018 Jibin Kaitholil George. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var txt: UITextField!
    @IBOutlet weak var seg: UISegmentedControl!
    @IBOutlet weak var search: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var results = [raiting]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.alpha = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return results.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "searchData", sender: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CustomCell
        
        cell.lbl1.text =  results[indexPath.row].BusinessName
        
        cell.lbl2.text =  results[indexPath.row].PostCode
        
        let rating = results[indexPath.row].RatingValue
        switch(rating){
            
        case "-1":
            cell.img.image = UIImage.init(imageLiteralResourceName: "fhis_exempt.jpg")
            break
        case "1":
            cell.img.image = UIImage.init(imageLiteralResourceName: "fhrs_1_en-gb.jpg")
            break
        case "2":
            cell.img.image = UIImage.init(imageLiteralResourceName: "fhrs_2_en-gb.jpg")
            break
        case "3":
            cell.img.image = UIImage.init(imageLiteralResourceName: "fhrs_3_en-gb.jpg")
            break
        case "4":
            cell.img.image = UIImage.init(imageLiteralResourceName: "fhrs_4_en-gb.jpg")
            break
        case "5":
            cell.img.image = UIImage.init(imageLiteralResourceName: "fhrs_5_en-gb.jpg")
            break
        default:
            cell.img.image = UIImage.init(imageLiteralResourceName: "fhrs_1_en-gb.jpg")
            break
        }
        return cell
    }
    
    @IBAction func search_clicked(_ sender: Any) {
        tableView.alpha = 1
        let getText = txt.text
        let trimmedString = getText?.trimmingCharacters(in: .whitespaces)
        if seg.selectedSegmentIndex == 0 {
            getData(method: "name", data: trimmedString!)
        } else if seg.selectedSegmentIndex == 1 {
            getData(method: "postcode", data: trimmedString!)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 121.2
    }
    
    func getData(method:String,data:String){
        if method == "postcode" {
            print(data)
            let swiftyString = data.replacingOccurrences(of: " ", with: "")
            
            let url = URL(string: "http://radikaldesign.co.uk/sandbox/hygiene.php?op=s_postcode&postcode=\(swiftyString)")
            //configuering URL section
            URLSession.shared.dataTask(with:url!) { (data, response, error) in
                guard let data = data else {print("error with data"); return }
                do{
                    self.results = try JSONDecoder().decode([raiting].self, from: data);
                    //updating the table
                    DispatchQueue.main.async {
                        self.tableView.reloadData();
                    }
                } catch let err {
                    print("Error:", err)
                }
                }.resume()//start the network call
        } else if method == "name" {
        let swiftyString = data.replacingOccurrences(of: " ", with: "%20")
            let url = URL(string: "http://radikaldesign.co.uk/sandbox/hygiene.php?op=s_name&name=\(swiftyString)")
            //configuering URL section
            URLSession.shared.dataTask(with:url!) { (data, response, error) in
                guard let data = data else {print("error with data"); return }
                do{
                    self.results = try JSONDecoder().decode([raiting].self, from: data);
                    //updating the table
                    DispatchQueue.main.async {
                        self.tableView.reloadData();
                    }
                } catch let err {
                    print("Error:", err)
                }
                }.resume()//start the network call
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchData" {
            let indexPath = tableView.indexPathForSelectedRow
            let selectedRow = indexPath?.row
            let destination = segue.destination as! RaitingDetailsViewController
            destination.therating = results[selectedRow!]
        }
    }
}
