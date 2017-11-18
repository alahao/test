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
    
    var cellNumber = 20
    var pageNumber = 2
    var cellHeight = 40
    
    var randomNumberOneArray = [0]
    var randomNumberTwoArray = [0]
    var randomNumberThreeArray = [0]
    var randomNumberFourArray = [0]

 
    
    //Load PDF
    func loadPDFAndShare() {
//        print("$Load PDF URL: \(docURL)")
        let fileManager = FileManager.default

        if fileManager.fileExists(atPath: docURL.path){
           
            let activityViewController = UIActivityViewController (activityItems: [docURL], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            present(activityViewController, animated: true, completion: nil)
        }
        else {
            print("# Document was not found")
        }
    }
    
    //Save PDF
    func savePdfDataWithTableView(tableView: UITableView) {
        let priorBounds = tableView.bounds
        let paperA4 = CGRect(x: 0, y: 0, width: 612, height: 800)
        let pageWithMargin = CGRect(x: 0, y: 0, width: paperA4.width, height: paperA4.height)
        
//        cellNumber = 20 * pageNumber
//
        let fittedSize = tableView.sizeThatFits(CGSize(width:pageWithMargin.width, height: tableView.contentSize.height))
         print("$ tableView.contentSize.height is \(tableView.contentSize.height)")
        tableView.bounds = CGRect(x: 0, y: 0, width: fittedSize.width, height: fittedSize.height)
        let pdfData = NSMutableData()
      
        UIGraphicsBeginPDFContextToData(pdfData, paperA4, nil)
        var pageOriginY: CGFloat = 0
        
        while pageOriginY < fittedSize.height {

            UIGraphicsBeginPDFPageWithInfo(paperA4, nil)
            UIGraphicsGetCurrentContext()!.saveGState()
            UIGraphicsGetCurrentContext()!.translateBy(x: 0, y: -pageOriginY)

            tableView.layer.render(in: UIGraphicsGetCurrentContext()!)
            UIGraphicsGetCurrentContext()!.restoreGState()
            print("$ pageOriginY \(pageOriginY)")
            pageOriginY = pageOriginY + paperA4.size.height
            print("$ fitsize height \(fittedSize.height)")
            print("$ new pageOriginY \(pageOriginY)")
        }
        UIGraphicsEndPDFContext()
        //PDF End
        tableView.bounds = priorBounds // Reset the tableView
        docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
        docURL = docURL.appendingPathComponent("myDocument.pdf")
        pdfData.write(to: docURL as URL, atomically: true)

    }
    
    //Print Button Pressed
    @IBAction func sendToPrint(_ sender: UIButton) {
        print("# Button Pressed")
        savePdfDataWithTableView(tableView: worksheetTableView)
        loadPDFAndShare()
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
        removeAllArray()
        self.worksheetTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func removeAllArray() {
        randomNumberOneArray.removeAll()
        randomNumberTwoArray.removeAll()
        randomNumberThreeArray.removeAll()
        randomNumberFourArray.removeAll()
    }
    
    //Operations
    func OperationPlus() {
        numberOne = Int(arc4random_uniform(51) + 50)
        numberTwo = Int(arc4random_uniform(51) + 50)
        numberAnswer = numberOne + numberTwo
        numberThree = Int(arc4random_uniform(51) + 50)
        numberFour = Int(arc4random_uniform(51) + 50)
        numberAnswerTwo = numberThree + numberFour
        
        randomNumberOneArray.append(numberOne)
        randomNumberTwoArray.append(numberTwo)
        randomNumberThreeArray.append(numberThree)
        randomNumberFourArray.append(numberFour)
    }

    func OperationMinus() {
        numberOne = Int(arc4random_uniform(51) + 50)
        numberTwo = Int(arc4random_uniform(51) + 50)
        numberAnswer = numberOne - numberTwo
        numberThree = Int(arc4random_uniform(51) + 50)
        numberFour = Int(arc4random_uniform(51) + 50)
        numberAnswerTwo = numberThree - numberFour
        
        randomNumberOneArray.append(numberOne)
        randomNumberTwoArray.append(numberTwo)
        randomNumberThreeArray.append(numberThree)
        randomNumberFourArray.append(numberFour)
    }
    
    func OperationMul() {
        numberOne = Int(arc4random_uniform(51) + 50)
        numberTwo = Int(arc4random_uniform(10))
        numberAnswer = numberOne * numberTwo
        
        numberThree = Int(arc4random_uniform(51) + 50)
        numberFour = Int(arc4random_uniform(10))
        numberAnswerTwo = numberThree * numberFour
        
        randomNumberOneArray.append(numberOne)
        randomNumberTwoArray.append(numberTwo)
        randomNumberThreeArray.append(numberThree)
        randomNumberFourArray.append(numberFour)
    }
    
    func OperationDivision() {
        numberOne = Int(arc4random_uniform(51) + 50)
        numberTwo = Int(arc4random_uniform(51) + 50)
        numberAnswer = numberOne / numberTwo
        numberThree = Int(arc4random_uniform(51) + 50)
        numberFour = Int(arc4random_uniform(51) + 50)
        numberAnswerTwo = numberThree / numberFour
        
        randomNumberOneArray.append(numberOne)
        randomNumberTwoArray.append(numberTwo)
        randomNumberThreeArray.append(numberThree)
        randomNumberFourArray.append(numberFour)
    }
    
    func operationType() {
        if numberOperation == "+" {
            OperationPlus()
        } else if numberOperation == "-" {
            OperationMinus()
        } else if numberOperation == "X" {
            OperationMul()
        } else if numberOperation == "/" {
            OperationDivision()
        }
    }
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        worksheetTableView.delegate = self
        worksheetTableView.dataSource = self
        self.worksheetTableView.addSubview(self.refreshControl)
        removeAllArray()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(cellHeight)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellNumber = 20 * pageNumber
        return cellNumber
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "worksheetCell", for: indexPath) as! TableViewCell
        
        operationType()
        
        cell.RowNumber.text = String(indexPath.row * 2 + 1)
        cell.RowNumberTwo.text = String(indexPath.row * 2 + 2)
        
        cell.numberOneLabel.text = String(randomNumberOneArray[indexPath.row])
        cell.numberTwoLabel.text = String(randomNumberTwoArray[indexPath.row])
        cell.numberAnswerLabel.text = String(numberAnswer)
        cell.numberOperationLabel.text = numberOperation
        
        cell.numberThreeLabel.text = String(randomNumberThreeArray[indexPath.row])
        cell.numberFourLabel.text = String(randomNumberFourArray[indexPath.row])
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
