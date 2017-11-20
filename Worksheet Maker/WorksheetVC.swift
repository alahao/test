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
    var questionNumberArray = [0]
    
    var operationName = ""
    var docURL : URL!
    
    var cellNumber = 20
    var pageNumber = 2
    let defaultCellHeight = 36
    var cellHeight = 0
    
    var randomNumberOneArray = [0]
    var randomNumberTwoArray = [0]
    var randomNumberThreeArray = [0]
    var randomNumberFourArray = [0]
    var randomNumberAnswerOneArray = [0]
    var randomNumberAnswerTwoArray = [0]
    
    var headerCells = [0,20,40,60,80,100,120,140,160,180,200,220,240,260,280,300]

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
    
    //Pull to Refresh
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(WorksheetVC.handleRefresh(_:)), for: UIControlEvents.valueChanged)
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
        randomNumberAnswerOneArray.removeAll()
        randomNumberAnswerTwoArray.removeAll()
        questionNumberArray.removeAll()
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
        randomNumberOneArray.append(numberOne)
        randomNumberTwoArray.append(numberTwo)
        randomNumberThreeArray.append(numberThree)
        randomNumberFourArray.append(numberFour)
        randomNumberAnswerOneArray.append(numberAnswerOne)
        randomNumberAnswerTwoArray.append(numberAnswerTwo)
        questionNumberArray.append(<#T##newElement: Int##Int#>)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        worksheetTableView.delegate = self
        worksheetTableView.dataSource = self
        self.worksheetTableView.addSubview(self.refreshControl)
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

        if headerCells.contains(indexPath.row)  {
            cellHeight = 100
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath) as! TableViewCell
            headerCell.worksheetTitle.text = operationName
            return headerCell
        } else {
            cellHeight = defaultCellHeight
            let cell = tableView.dequeueReusableCell(withIdentifier: "worksheetCell", for: indexPath) as! TableViewCell
            cell.RowNumberOne.text = String(indexPath.row * 2 - 1)
            cell.RowNumberTwo.text = String(indexPath.row * 2)
            
            cell.numberOneLabel.text = String(randomNumberOneArray[indexPath.row])
            cell.numberTwoLabel.text = String(randomNumberTwoArray[indexPath.row])
            cell.numberAnswerLabel.text = String(numberAnswerOne)
            cell.numberOperationLabel.text = numberOperation
            
            cell.numberThreeLabel.text = String(randomNumberThreeArray[indexPath.row])
            cell.numberFourLabel.text = String(randomNumberFourArray[indexPath.row])
            cell.numberAnswerTwoLabel.text = String(numberAnswerTwo)
            cell.numberOperationTwoLabel.text = numberOperationTwo
        return cell
        }
    }
    
    //Save PDF
    func savePdfDataWithTableView(tableView: UITableView) {
        let priorBounds = tableView.bounds
        let paperA4 = CGRect(x: 0, y: 0, width: 612, height: 800)
        let pageWithMargin = CGRect(x: -50, y: 50, width: paperA4.width - 50, height: paperA4.height - 50)
        
        //cellNumber = 20 * pageNumber
      
        let fittedSize = tableView.sizeThatFits(CGSize(width:pageWithMargin.width, height: tableView.contentSize.height))
        print("$ tableView.contentSize.height is \(tableView.contentSize.height)")
        tableView.bounds = pageWithMargin
        let pdfData = NSMutableData()
        
        UIGraphicsBeginPDFContextToData(pdfData, paperA4, nil) //PDF BEGIN
        var pageOriginY: CGFloat = 0
        while pageOriginY < fittedSize.height {
            UIGraphicsBeginPDFPageWithInfo(CGRect(x: -25, y: 0, width: paperA4.width, height: paperA4.height), nil)
            tableView.bounds = CGRect(x: 0, y: pageOriginY, width: pageWithMargin.width, height: pageOriginY + pageWithMargin.height)
            UIGraphicsGetCurrentContext()!.saveGState()
            UIGraphicsGetCurrentContext()!.translateBy(x: 0, y: -pageOriginY)
            tableView.layer.render(in: UIGraphicsGetCurrentContext()!)
            UIGraphicsGetCurrentContext()!.restoreGState()
            print("$ pageOriginY \(pageOriginY)")
            pageOriginY = pageOriginY + paperA4.size.height
            print("$ fitsize height \(fittedSize.height)")
            print("$ new pageOriginY \(pageOriginY)")
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
