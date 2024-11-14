//
//  CustomFeedbackRevampModel.swift
//  WebViewTestJS
//
//  Created by Rahul Vishwakarma on 21/10/24.
//

import Foundation
import UIKit


// MARK: - CustomFeedBackRevampModel
struct CustomFeedBackRevampModel: Codable {
    let customFeedback: [CustomFeedbackRevampElement]?

    enum CodingKeys: String, CodingKey {
        case customFeedback = "custom_feedback"
    }
}

struct CustomFeedbackRevampElement: Codable {
    let question: String?
    let qid: Int?
    let type: String?
    let option: [Option]?
    let ans: String?
    let previousquestion: Int?
    let nextquestion: Int?
}

struct Option: Codable {
    let option: String?
    let nextquestion: Int?
}



func getReponseCustomFeedBack() -> CustomFeedBackRevampModel? {
    
    do {
        
        let data = str.data(using: .utf8)

        
        if let data = data {
            
            do {
                
                let respo = try JSONDecoder().decode(CustomFeedBackRevampModel.self, from: data)
                return respo
                
            } catch {
                print(error.localizedDescription)
            }
            
        }
        
    }
    
    return nil
    
}


let str = """
{
  "custom_feedback": [
    {
      "question": "question 1",
      "qid":1,
      "type": "",
      "option": [
       {
         "option":"Yes",
         "nextquestion":2
       },
       {
         "option":"No",
         "nextquestion":3
       }
      ],
      "ans": "",
       "previousquestion":0,
       "nextquestion": 0
    },
    {
    "question": "question 2",
    "qid":2,
    "type": "userInput",
      "option": [],
      "ans": "",
      "previousquestion":1,
      "nextquestion": 4
    },
    {
      "question": "question 3",
      "qid":3,
      "type": "Both",
       "option": [
       {
         "option":"Yes",
         "nextquestion":4
       },
       {
         "option":"No",
         "nextquestion":0
       }
      ],
      "ans": "",
       "previousquestion":1,
       "nextquestion": 0
    },
    {
      "question": "Rahul is the best in his way",
      "qid":4,
      "type": "Both",
       "option": [
       {
         "option":"Yes",
         "nextquestion":0
       },
       {
         "option":"Definetily Yes",
         "nextquestion":0
       }
      ],
      "ans": "",
       "previousquestion":2,
       "nextquestion": 0
    }
  ]
}
"""



extension UITableViewCell {
    
    static var reuseIdentifier: String {
        return "\(self)"
    }
    
}

