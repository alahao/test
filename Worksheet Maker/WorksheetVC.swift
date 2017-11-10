//
//  WorksheetVC.swift
//  Worksheet Maker
//
//  Created by NANZI WANG on 11/5/17.
//  Copyright © 2017 PrettyMotion. All rights reserved.
//

import UIKit

class WorksheetVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var worksheetTableView: UITableView!
    
    var numberOne = 0
    var numberTwo = 0
    var numberAnswer = 0
    var numberOperation = ""
    var numberThree = 0
    var numberFour = 0
    var numberAnswerTwo = 0
    var numberOperationTwo = ""
    
    var docURL : URL!
    
    //Load PDF
    func loadPDFAndShare() {
        print("Load PDF URL: \(docURL)")
        let fileManager = FileManager.default

        if fileManager.fileExists(atPath: docURL.path){
           
            let activityViewController = UIActivityViewController (activityItems: [docURL], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            present(activityViewController, animated: true, completion: nil)
        }
        else {
            print("Document was not found")
        }
    }
    
    //Save PDF
    func savePdfDataWithTableView(tableView: UITableView) {
        let priorBounds = tableView.bounds
        let fittedSize = tableView.sizeThatFits(CGSize(width:priorBounds.size.width, height:tableView.contentSize.height))
        tableView.bounds = CGRect(x:0, y:0, width:fittedSize.width, height:fittedSize.height)
        let pdfPageBounds = CGRect(x:0, y:0, width:tableView.frame.width, height:self.view.frame.height)
        let pdfData = NSMutableData()
        
        UIGraphicsBeginPDFContextToData(pdfData, pdfPageBounds,nil)
        var pageOriginY: CGFloat = 0
        
        while pageOriginY < fittedSize.height {
            UIGraphicsBeginPDFPageWithInfo(pdfPageBounds, nil)
            UIGraphicsGetCurrentContext()!.saveGState()
            UIGraphicsGetCurrentContext()!.translateBy(x: 0, y: -pageOriginY)
            tableView.layer.render(in: UIGraphicsGetCurrentContext()!)
            UIGraphicsGetCurrentContext()!.restoreGState()
            pageOriginY += pdfPageBounds.size.height
        }
        
        UIGraphicsEndPDFContext()
        
        tableView.bounds = priorBounds
        docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
        docURL = docURL.appendingPathComponent("myDocument.pdf")
        pdfData.write(to: docURL as URL, atomically: true)
        print("Save PDF URL: \(docURL)")
    }
    
    //Print Button Pressed
    @IBAction func sendToPrint(_ sender: UIButton) {
        savePdfDataWithTableView(tableView: worksheetTableView)
        loadPDFAndShare()
    }
    
    //Operations
    func OperationPlus() {
        numberOne = Int(arc4random_uniform(51) + 50)
        numberTwo = Int(arc4random_uniform(51) + 50)
        numberAnswer = numberOne + numberTwo
        numberThree = Int(arc4random_uniform(51) + 50)
        numberFour = Int(arc4random_uniform(51) + 50)
        numberAnswer = numberOne + numberTwo
    }
    
    func OperationMinus() {
        numberOne = Int(arc4random_uniform(51) + 50)
        numberTwo = Int(arc4random_uniform(51) + 50)
        numberAnswer = numberOne - numberTwo
        numberThree = Int(arc4random_uniform(51) + 50)
        numberFour = Int(arc4random_uniform(51) + 50)
        numberAnswer = numberOne - numberTwo
    }
    
    func OperationMul() {
        numberOne = Int(arc4random_uniform(51) + 50)
        numberTwo = Int(arc4random_uniform(10))
        numberAnswer = numberOne * numberTwo
        
        numberThree = Int(arc4random_uniform(51) + 50)
        numberFour = Int(arc4random_uniform(10))
        numberAnswerTwo = numberThree * numberFour
    }
    
    func OperationDivision() {
        numberOne = Int(arc4random_uniform(51) + 50)
        numberTwo = Int(arc4random_uniform(51) + 50)
        numberAnswer = numberOne / numberTwo
        numberThree = Int(arc4random_uniform(51) + 50)
        numberFour = Int(arc4random_uniform(51) + 50)
        numberAnswer = numberOne / numberTwo
    }
    
    
    //Pull to Refresh
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(WorksheetVC.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        self.worksheetTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        worksheetTableView.delegate = self
        worksheetTableView.dataSource = self
        self.worksheetTableView.addSubview(self.refreshControl)
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 32
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "worksheetCell", for: indexPath) as! TableViewCell
        
        if numberOperation == "+" {
        OperationPlus()
        } else if numberOperation == "-" {
        OperationMinus()
        } else if numberOperation == "X" {
        OperationMul()
        } else if numberOperation == "/" {
        OperationDivision()
        }
        
        
        cell.numberOneLabel.text = String(numberOne)
        cell.numberTwoLabel.text = String(numberTwo)
        cell.numberAnswerLabel.text = String(numberAnswer)
        cell.numberOperationLabel.text = numberOperation
        
        cell.numberThreeLabel.text = String(numberThree)
        cell.numberFourLabel.text = String(numberFour)
        cell.numberAnswerTwoLabel.text = String(numberAnswerTwo)
        cell.numberOperationTwoLabel.text = numberOperationTwo
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
