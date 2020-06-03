//
//  QuestionsViewController.swift
//  VirusTracker
//
//  Created by melvin asare on 29/05/2020.
//  Copyright © 2020 Neil Hiddink. All rights reserved.
//

import UIKit

class QuestionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var questionLabel: UILabel!
    
    private var collectQuestionArray = QuestionData.allQuestionDataArray()
    var currentQuestionNumber: Question?
    var questionArray = [Question]()
    var score = 0

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentQuestionNumber?.answer.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = currentQuestionNumber?.answer[indexPath.row].text
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let question = currentQuestionNumber else { return }
        let answer = question.answer[indexPath.row]
        
        if checkoutAnswer(question: question, answer: answer) {
            if let index = collectQuestionArray.firstIndex(where: { $0.text == question.text }) {
                if index < (collectQuestionArray.count - 1) {
                    let nextQuestion = collectQuestionArray[index+1]
                    print(score)
                    configureUI(question: nextQuestion)
                } else {
                    createMyAlert(title: "Score", message: "Your current score is \(score)")
                }
            }
        }
    }
    
    func createMyAlert(title: String, message: String) {
        let myAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let myAction = UIAlertAction(title: "Ok", style: .cancel) { (action) in
            self.transitionToResultsPage()
        }
        myAlert.addAction(myAction)
        present(myAlert, animated: true, completion: nil)
    }
    
    func transitionToResultsPage() {
        let vc = ResultsTableViewController()
        present(vc, animated: true, completion: nil)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    func checkoutAnswer(question: Question, answer: Answer) -> Bool {
        if question.answer.contains(where: { $0.text == answer.text }) && answer.goodAnswer == true {
            score+=2
            return true
        } else if question.answer.contains(where: { $0.text == answer.text }) && answer.badAnswer == true {
            score+=4
            return true
        } else {
            score+=1
            return question.answer.contains(where: { $0.text == answer.text }) && answer.neutralAnswer == true
        }
    }
    
    func configureUI(question: Question) {
        questionLabel.text = question.text
        print(questionLabel.text!)
        currentQuestionNumber = question
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        configureUI(question: collectQuestionArray.first!)

    }
}
