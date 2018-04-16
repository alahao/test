//
//  AnswersVC.swift
//  PaperWorksheet
//
//  Created by NANZI WANG on 3/16/18.
//  Copyright © 2018 PrettyMotion. All rights reserved.
//

import UIKit


class AnswersVC: UIViewController {
    
    var answerCodeLText = ""
    var answerCodeRText = ""
    
    @IBOutlet weak var answerCodeL: UITextField!
    
    @IBOutlet weak var answerCodeR: UITextField!
    
    @IBAction func showAnswerButton(_ sender: Any) {
        
//        cell.numberAnswerLabel.text = String(describing: question.questionArray[indexPath.row][5])
//        cell.numberAnswerTwoLabel.text = String(describing: question.questionArray[indexPath.row][6])
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        answerCodeL.text = answerCodeLText
        answerCodeR.text = answerCodeRText

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

 
}
