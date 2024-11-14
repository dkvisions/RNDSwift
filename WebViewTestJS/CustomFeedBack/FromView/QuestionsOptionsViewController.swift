//
//  QuestionsOptionsViewController.swift
//  AudioVideo
//
//  Created by Rahul Vishwakarma  on 27/03/24.
//

import UIKit






///question type = userinput, both, ""
///userinput = textView
///both = tableView + textView
///"" = tableView
///
///if type == userinput ? then accessNextQuestion from main Dict : access from option dict
///
///for first Questiion , PreviousQId == 0
///for last question, NextQuestionId == 0
















struct MyOptionsModel {
    let questionName: String
    let answers: [String]
}

class QuestionsOptionsViewController: UIViewController {
    
    var feedbackQuestionModel = [CustomFeedbackRevampElement]()
    var customFeedbackResponseCcmmID = 0
    
    var currentQuestion: CustomFeedbackRevampElement?
    var qIDForNextQuestion: Int? = 0
    
    
    @IBOutlet weak var textViewAns: UITextView!
    
    var completion:((String)->()) = { _ in }
    

    @IBOutlet weak var stackViewContainer: UIStackView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableViewOptions: UITableView!
    @IBOutlet weak var labelQuestion: UILabel!
    @IBOutlet weak var buttonPre: UIButton!
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var buttonClose: UIButton!
    
    
//    private let feedBackServiceLayer = FeedbackServiceLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedbackQuestionModel = getReponseCustomFeedBack()?.customFeedback ?? []
        
        setups()
        tableViewSetUp()
        setUpAPIObserver()
        
    }
    
    func setups() {

        let firstQArray = feedbackQuestionModel.filter { $0.previousquestion == 0 }

        if let firstQ = firstQArray.first {
        
            hideShow(forData: firstQ)
    
        }
        
        
        buttonPre.isEnabled = false
        buttonPre.addTarget(self, action: #selector(buttonPreDidTapped), for: .touchUpInside)
        buttonNext.addTarget(self, action: #selector(buttonNextDidTapped), for: .touchUpInside)
        buttonClose.addTarget(self, action: #selector(buttonCloseTapped), for: .touchUpInside)
        
        stackViewContainer.layer.cornerRadius = 20
        stackViewContainer.clipsToBounds = true
        
    }
    
    
    func hideShow(forData: CustomFeedbackRevampElement?) {
        currentQuestion = forData
        switch forData?.type?.lowercased() {
        case "userinput":
            tableViewOptions.isHidden = true
            textViewAns.isHidden = false
            break
            
        case "both":
            tableViewOptions.isHidden = false
            textViewAns.isHidden = false
            break
            
        case "":
            tableViewOptions.isHidden = false
            textViewAns.isHidden = true
            break
            
        default: break
        }
        
        //Height setUp for tableView
        if forData?.option?.count ?? 0 < 4 {
            tableViewHeight.constant = CGFloat((forData?.option?.count ?? 0) * 55)
        } else {
            tableViewHeight.constant = 210.0
        }
        tableViewOptions.reloadData()
    }
    
    
    private func setUpAPIObserver() {
        
//        feedBackServiceLayer.updateLoadingStatus = { loadingStatus in
//            DispatchQueue.main.async {
//                if loadingStatus.isLoading {
//                    self.view.showLoader()
//                } else {
//                    self.view.dismissLoader()
//                }
//            }
//        }
        
//        feedBackServiceLayer.showAlert = { alertTitle, alertType in
//            switch alertType {
//            case .nointernet:
//                self.view.dismissLoader()
//            case .failure:
//                if let msg = alertTitle.msg {
//                    self.view.makeToast(msg)
//                    self.view.dismissLoader()
//                }
//            case .success:
//                
//                self.view.makeToast(alertTitle.apiMessage)
//                self.view.dismissLoader()
//                
//            }
//        }
    }
    
    @objc private func buttonPreDidTapped() {
        
        if currentQuestion?.previousquestion == 0 {
            buttonPre.isEnabled = false
            return
        }
        
        let preQuestArray = feedbackQuestionModel.filter { $0.qid == currentQuestion?.previousquestion }

        if let preQuest = preQuestArray.first {
            qIDForNextQuestion = 0
            hideShow(forData: preQuest)
        
        }
        

        setButtonUI()
    }
    
    func setButtonUI() {
        
        if currentQuestion?.previousquestion == 0 {
            buttonPre.isEnabled = false
        } else {
            buttonPre.isEnabled = true
        }
        
        var isNextQiDZero = false
        
        if currentQuestion?.type?.lowercased() == "userinput" {
            isNextQiDZero = true
            
        } else {
            for data in currentQuestion?.option ?? [] {
                if data.nextquestion == 0 {
                    isNextQiDZero = true
                }
                
            }
        }
        
        
        if isNextQiDZero {
            buttonNext.setTitle("Submit", for: .normal)
        } else {
            buttonNext.setTitle("Next", for: .normal)
        }
    }
    
    
    @objc private func buttonNextDidTapped() {
        
       
        if buttonNext.titleLabel?.text == "Submit" {
            
            var allNotAnsewered = false
            
            for data in feedbackQuestionModel {
                
                if data.ans == "" {
                    allNotAnsewered = true
                    break
                }
            }
            
            if allNotAnsewered {
//                self.view.makeToast("Please answer all the questions")
                
            } else {
                
//                submitAnswers(questionsAnsData: feedbackQuestionModel)
            }
            
            return
        }

        
        if currentQuestion?.type == "" || currentQuestion?.type?.lowercased() == "both" {
            if qIDForNextQuestion == 0 {
                print("Please select Ans")
                return
            }
        } else {
            qIDForNextQuestion = currentQuestion?.nextquestion
        }
        
        
        //TODO: Add check condition : Is user answerder the question
        
        
        let nextQuestArray = feedbackQuestionModel.filter { $0.qid == qIDForNextQuestion }

        if let nextQuest = nextQuestArray.first {
            qIDForNextQuestion = 0
            hideShow(forData: nextQuest)
        }
        setButtonUI()
    }
    
    
    
    @objc private func buttonCloseTapped() {
        self.dismiss(animated: true)
    }
    
    
    func tableViewSetUp() {
        let nibName = UINib(nibName: QuestionsOptionsTableCell.reuseIdentifier, bundle: nil)
        tableViewOptions.register(nibName, forCellReuseIdentifier: QuestionsOptionsTableCell.reuseIdentifier)
        
        
        tableViewOptions.delegate = self
        tableViewOptions.dataSource = self
    }
    
    
    
//    func submitAnswers(questionsAnsData: [CustomFeedbackQuestionModel]) {
//        
//        
//        do {
//            let modelToData = try JSONEncoder().encode(questionsAnsData)
//            let answerJSON = String(data: modelToData, encoding: .utf8) ?? ""
//            
//            let dataNew = [
//                "CCMMId": customFeedbackResponseCcmmID,
//                "FeatureModuleName": "",
//                "AnswerJSON": answerJSON
//            ] as [String : Any]
//            
//            
//            self.feedBackServiceLayer.addCustomUserFeedback(param: dataNew) { respose in
//                
//                self.dismissViewController(message: respose.msg)
//                
//            } failure: { error in
//                print(error.localizedDescription)
//                self.dismissViewController(message: "Something went wrong")
//            }
//            
//        } catch {
//            self.dismissViewController(message: "Something went wrong")
//        }
//        
//    }
    
    func dismissViewController(message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.dismiss(animated: true) {
                self?.completion(message)
            }
        }
    }
}


extension QuestionsOptionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        currentQuestion?.option?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: QuestionsOptionsTableCell.reuseIdentifier) as? QuestionsOptionsTableCell else { return UITableViewCell() }
        
        cell.optionsData = currentQuestion?.option?[indexPath.row].option
//
//        
//        let isAnsHave = (data.ans ?? "") == (data.option?[indexPath.row] ?? "")
//        cell.viewContainer.layer.borderColor = isAnsHave ? UIColor().darkBlueColor.cgColor : UIColor.black.cgColor
//        cell.viewContainer.layer.borderWidth = isAnsHave ? 1.5
//        : 0.2
        
//        cell.labelOptions.textColor = isAnsHave ? .white : .black
        
        
//        cell.optionsData = data.option?[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        qIDForNextQuestion = currentQuestion?.option?[indexPath.row].nextquestion
        
//        if feedbackQuestionModel[currentQuestionIndex].ans == feedbackQuestionModel[currentQuestionIndex].option?[indexPath.row] {
//            feedbackQuestionModel[currentQuestionIndex].ans = ""
//            
//        } else {
////            feedbackQuestionModel[currentQuestionIndex].ans = feedbackQuestionModel[currentQuestionIndex].option?[indexPath.row]
//        }
        
        tableViewOptions.reloadData()
        
    }
}
