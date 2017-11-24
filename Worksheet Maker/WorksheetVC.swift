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
    var numberAnswerOne = 0
    var numberOperation = ""
    var numberThree = 0
    var numberFour = 0
    var numberAnswerTwo = 0
    var numberOperationTwo = ""
    
    var operationName = ""
    var docURL : URL!
    
    var cellNumber = 20
    var pageNumber = 2
    let defaultCellHeight = 40
    var cellHeight = 40

    var headerCells = [21,42,63,84,100,120,140,160,180,200,220,240,260,280,300]
    
    var questionNumber = 0
    var questionDic = [0: [0,0,0,0,0,0]]

    //Load PDF
    func loadPDFAndShare() {
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
    
    //Print Button Pressed
    @IBAction func sendToPrint(_ sender: UIButton) {
        print("# Button Pressed")
        savePdfDataWithTableView(tableView: worksheetTableView)
        loadPDFAndShare()
    }
    
//    //Pull to Refresh
//    lazy var refreshControl: UIRefreshControl = {
//        let refreshControl = UIRefreshControl()
//        refreshControl.addTarget(self, action:
//            #selector(WorksheetVC.handleRefresh(_:)), for: UIControlEvents.valueChanged)
//        return refreshControl
//    }()
//
//    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
//        removeAllArray()
//        self.worksheetTableView.reloadData()
//        refreshControl.endRefreshing()
//    }
//
    func removeAllArray() {
        questionDic.removeAll()
    }
    
    func generatingRandomNumber(numberAFrom: UInt32, numberATo: UInt32, numberBFrom: UInt32, numberBTo: UInt32, operation: String) {
        if operation == "plus" {
            numberOne = Int(arc4random_uniform(numberATo - numberAFrom) + numberAFrom)
            numberTwo = Int(arc4random_uniform(numberBTo - numberBFrom) + numberBFrom)
            numberThree = Int(arc4random_uniform(numberATo - numberAFrom) + numberAFrom)
            numberFour = Int(arc4random_uniform(numberBTo - numberBFrom) + numberBFrom)
            numberAnswerOne = numberOne + numberTwo
            numberAnswerTwo = numberThree + numberFour
        } else if operation == "minus" {
            numberOne = Int(arc4random_uniform(numberATo - numberAFrom) + numberAFrom)
            numberTwo = Int(arc4random_uniform(UInt32(numberOne) - numberBFrom) + numberBFrom)
            numberThree = Int(arc4random_uniform(numberATo - numberAFrom) + numberAFrom)
            numberFour = Int(arc4random_uniform(UInt32(numberThree) - numberBFrom) + numberBFrom)
            numberAnswerOne = numberOne - numberTwo
            numberAnswerTwo = numberThree - numberFour
        } else if operation == "multiplication" {
            numberOne = Int(arc4random_uniform(numberATo - numberAFrom) + numberAFrom)
            numberTwo = Int(arc4random_uniform(numberBTo - numberBFrom) + numberBFrom)
            numberThree = Int(arc4random_uniform(numberATo - numberAFrom) + numberAFrom)
            numberFour = Int(arc4random_uniform(numberBTo - numberBFrom) + numberBFrom)
            numberAnswerOne = numberOne * numberTwo
            numberAnswerTwo = numberThree * numberFour
        } else if operation == "division" {
            numberTwo = Int(arc4random_uniform(numberATo - numberAFrom) + numberAFrom)
            numberAnswerOne = Int(arc4random_uniform(numberBTo - numberBFrom) + numberBFrom)
            numberFour = Int(arc4random_uniform(numberATo - numberAFrom) + numberAFrom)
            numberAnswerTwo = Int(arc4random_uniform(numberBTo - numberBFrom) + numberBFrom)
            numberOne = numberAnswerOne * numberTwo
            numberThree = numberAnswerTwo * numberFour
        }
      
        let questionArray = [numberOne, numberTwo, numberAnswerOne, numberThree, numberFour, numberAnswerTwo]
        questionDic.updateValue(questionArray, forKey: questionNumber)
        questionNumber = questionNumber + 1
    }
    
    //Operations
    func OperationPlus() {
        // A+B=C
        generatingRandomNumber(numberAFrom: 11, numberATo: 99, numberBFrom: 11, numberBTo: 99, operation: "plus")
    }

    func OperationMinus() {
        // A-B=C
        generatingRandomNumber(numberAFrom: 11, numberATo: 99, numberBFrom: 11, numberBTo: 99, operation: "minus")
    }
    
    func OperationMul() {
        // A*B=C
        generatingRandomNumber(numberAFrom: 11, numberATo: 99, numberBFrom: 11, numberBTo: 99, operation: "multiplication")
    }
    
    func OperationDivision() {
        // C/A=B
        generatingRandomNumber(numberAFrom: 2, numberATo: 9, numberBFrom: 2, numberBTo: 9, operation: "division")
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
    
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let label = UILabel()
//        label.textAlignment = NSTextAlignment.center
//        label.text = "Dividion Worksheet"
//        return label
//    }
    
//    private func tableView (tableView:UITableView , heightForHeaderInSection section:Int)->Float
//    {
//        return 40.0
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        worksheetTableView.delegate = self
        worksheetTableView.dataSource = self
//        self.worksheetTableView.addSubview(self.refreshControl)
        removeAllArray()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(cellHeight)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellNumber = 20 * pageNumber
        return cellNumber
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        operationType()

            let cell = tableView.dequeueReusableCell(withIdentifier: "worksheetCell", for: indexPath) as! TableViewCell
            let questionArray = questionDic[indexPath.row]
            
            cell.RowNumber.text = String(indexPath.row * 2 + 1)
            cell.RowNumberTwo.text = String(indexPath.row * 2 + 2)
            
            cell.numberOneLabel.text = String(describing: questionArray![0])
            cell.numberTwoLabel.text = String(describing: questionArray![1])
            cell.numberAnswerLabel.text = String(describing: questionArray![2])
            cell.numberOperationLabel.text = numberOperation
            
            cell.numberThreeLabel.text = String(describing: questionArray![3])
            cell.numberFourLabel.text = String(describing: questionArray![4])
            cell.numberAnswerTwoLabel.text = String(describing: questionArray![5])
            cell.numberOperationTwoLabel.text = numberOperationTwo
        return cell

    }
    
    //Save PDF
    func savePdfDataWithTableView(tableView: UITableView) {
        let priorBounds = tableView.bounds
        let paperA4 = CGRect(x: 0, y: 0, width: 612, height: 800)
        let pageWithMargin = CGRect(x: 0, y: 0, width: paperA4.width, height: paperA4.height)
        let fittedSize = tableView.sizeThatFits(CGSize(width:pageWithMargin.width, height: tableView.contentSize.height))
       
        tableView.bounds = CGRect(x: 0, y: 0, width: paperA4.width, height: fittedSize.height)
        let pdfData = NSMutableData()
        
        UIGraphicsBeginPDFContextToData(pdfData, paperA4, nil) //PDF BEGIN
        var pageOriginY: CGFloat = 0
        while pageOriginY < fittedSize.height - 790 {
            UIGraphicsBeginPDFPageWithInfo(paperA4, nil)
            UIGraphicsGetCurrentContext()!.saveGState()
            UIGraphicsGetCurrentContext()!.translateBy(x: 0, y: -pageOriginY)
            tableView.layer.render(in: UIGraphicsGetCurrentContext()!)
            UIGraphicsGetCurrentContext()!.restoreGState()
            
            print("$ fittedSize.height is \(fittedSize.height)")
            print("$ old pageOriginY is \(pageOriginY)")
            pageOriginY = pageOriginY + paperA4.size.height
            print("$ new pageOriginY is \(pageOriginY)")
        }
        UIGraphicsEndPDFContext() //PDF End
        tableView.bounds = priorBounds // Reset the tableView
        docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
        docURL = docURL.appendingPathComponent("myDocument.pdf")
        pdfData.write(to: docURL as URL, atomically: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
