//
//  ViewController.swift
//  Barbiero-Bazan
//
//  Created by Giovanni Barbiero on 29/07/18.
//  Copyright © 2018 Giovanni Barbiero. All rights reserved.
//

import UIKit

class BarbieroBazan: UIViewController {
    
    static var instance : BarbieroBazan? = nil
    
    var gameEnded = false
    var helpViewOpen = false
    
    /// array of the origin views.
    var originViews = [UIView]()
    
    /// array of de destination views.
    var destinationViews = [UIView]()
    
    /// array of the code generated number views.
    var numbersViews = [DragNumberImageView]()
    
    /// array of the `UIImageView` for **decine, unità, decimi, centesimi**.
    var images = [UIImageView]()
    
    /// array of the images of **decine, unità, decimi, centesimi**.
    let imagesImage = [UIImage(named: "Decine"), UIImage(named: "Unità"), UIImage(named: "Decimi"), UIImage(named: "Centesimi")]
    
    /// color array
    let colorDragView = [UIColor(red: 195/255, green: 62/255, blue: 31/255, alpha: 1), UIColor(red: 102/255, green: 173/255, blue: 249/255, alpha: 1), UIColor.yellow, UIColor(red: 125/255, green: 251/255, blue: 101/255, alpha: 1)]
    //let colorDragView = [UIColor.red, UIColor.blue, UIColor.yellow, UIColor.green]
    
    /// view of the `HelpViewController`
    var helpView : HelpViewController?
    
    /// help button
    @IBOutlet weak var btnHelp: UIButton!
    
    @IBOutlet weak var btnReset: UIButton!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var wrongImageView: UIImageView!
    @IBOutlet weak var rightImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BarbieroBazan.instance = self
        wrongImageView.image = UIImage(cgImage: UIImage(named: "Sbagliato")!.cgImage!, scale: CGFloat(1.0), orientation: .down)
        UpdateContainerViewArrays()
        if let controller = storyboard?.instantiateViewController(withIdentifier: "menu") as? MenuViewController {
            addChild(controller)
            self.view.addSubview(controller.view)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        return;
        Reset()
        if checkFirstTimeOpening() {
            openHelpView()
        }
        // FIXME: defaults.set(false, forKey: "FirstTime" + EsercizioKey.Uno.rawValue)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
     Checks if is the first time that the exercise has been opened
     
     - Returns: if it is the first time it has been opened
     */
    func checkFirstTimeOpening() -> Bool {
        let defaults = UserDefaults.standard
        if !defaults.bool(forKey: "FirstTime" + EsercizioKey.Uno.rawValue) {
            defaults.set(true, forKey: "FirstTime" + EsercizioKey.Uno.rawValue)
            defaults.synchronize()
            return true
        }
        return false
    }
    
    /**
     Closes the exercise.
     */
    @IBAction func backButtonClick(_ sender: Any) {
        self.dismiss(animated: true, completion: {})
    }
    
    /**
     Creates an instance of `HelpViewController` and adds it's view on front.
     
     */
    func openHelpView() {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "help") as? HelpViewController {
            helpViewOpen = true
            topView.isHidden = true
            addChild(controller)
            helpView = controller
            self.view.addSubview(controller.view)
        }
    }
    
    /**
     Closes the `helpView`
     */
    func DismissHelpView() {
        topView.isHidden = false
        helpViewOpen = false
        helpView?.working = false
        helpView?.view.removeFromSuperview()
        Reset()
    }
    
    /**
     Adds the origin, destination and images views to the respective array
     */
    func UpdateContainerViewArrays() {
        originViews.append(self.view.viewWithTag(1)!)
        originViews.append(self.view.viewWithTag(2)!)
        originViews.append(self.view.viewWithTag(3)!)
        originViews.append(self.view.viewWithTag(4)!)
        
        destinationViews.append(self.view.viewWithTag(11)!)
        destinationViews.append(self.view.viewWithTag(12)!)
        destinationViews.append(self.view.viewWithTag(13)!)
        destinationViews.append(self.view.viewWithTag(14)!)
        
        images.append(self.view.viewWithTag(21) as! UIImageView)
        images.append(self.view.viewWithTag(22) as! UIImageView)
        images.append(self.view.viewWithTag(23) as! UIImageView)
        images.append(self.view.viewWithTag(24) as! UIImageView)
    }
    
    func GenerateNumbersViews() {
        ClearNumbersArray()
        ClearImages()
        let random = (String)(Int.random(in: 1000..<10000))
        print(random)
        let order = [0, 1, 2, 3].shuffled()
        for i in 0...3 {
            let val = Int((String)(random[random.index(random.startIndex, offsetBy: i)]))!
            print(val)
            let color = colorDragView[i]
            numbersViews.append(DragNumberImageView(originView: originViews[order[i]], destinationView: destinationViews[i], rootView: self.view, value: val, color: color))
            numbersViews[i].isUserInteractionEnabled = true
            numbersViews[i].addGestureRecognizer(NewPanGestureRecognizer())
            numbersViews[i].image = UIImage(named: "\(val)")
            images[order[i]].image = imagesImage[i]
        }
    }
    
    func ClearImages() {
        for i in 0...3 {
            images[i].image = nil
        }
    }
    
    func ClearNumbersArray() {
        if numbersViews.count != 0 {
            for item in numbersViews {
                item.removeFromSuperview()
            }
            numbersViews.removeAll()
        }
    }
    
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        if gameEnded {
            return
        }
        if let view = recognizer.view as? DragNumberImageView{
            view.superview?.bringSubviewToFront(view)
            if recognizer.state == .began {
                view.AnimatePickUp()
                view.center = recognizer.location(in: self.view)
            }
            if recognizer.state == .changed {
                let translation = recognizer.translation(in: self.view)
                view.center = CGPoint(x:view.center.x + translation.x,y:view.center.y + translation.y)
            }
            if recognizer.state == .ended {
                CheckDestination(view: view)
                //CheckIfAllDragged()
            }
        }
        recognizer.setTranslation(CGPoint.zero, in: self.view)
    }
    
    func CheckIfAllDragged() {
        for v in numbersViews {
            if v.currentView == v.originView {
                return
            }
        }
        // tutti posizionati
        EndGame(vinto: CheckCorrectPositions())
    }
    
    // check if destination view is already occupied
    func CheckDestination(view: DragNumberImageView) {
        for destV in destinationViews {
            if destV.GetFrameInRootView(rootView: self.view).contains(view.center) {
                for dragV in numbersViews {
                    if dragV.currentView == destV {
                        view.Move(toView: view.originView, withDuration: 0.5, withDelay: 0)
                        return
                    }
                }
                view.Move(toView: destV, withDuration: 0.5, withDelay: 0)
                return
            }
        }
        view.Move(toView: view.originView, withDuration: 0.5, withDelay: 0)
    }
    
    func NewPanGestureRecognizer() -> UIPanGestureRecognizer {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
        pan.maximumNumberOfTouches = 1
        
        return pan
    }
    
    func CheckCorrectPositions() -> Bool {
        for v in numbersViews {
            if (v.currentView! != v.destinationView) {
                return false
            }
        }
        return true
    }
    
    func Win() {
        //Statistiche.aggiungiGiusto(forKey: EsercizioKey.Uno)
        // DO WIN ANIMATION AND RIGHT HAND ANIMATION
        let dialogMessage = UIAlertController(title: "HAI VINTO!", message: "", preferredStyle: .alert)
        let yeah = UIAlertAction(title: "Ricominciamo!", style: .cancel) { (action) -> Void in
            print("Vinto")
        }
        dialogMessage.addAction(yeah)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    func Loose() {
        //Statistiche.aggiungiSbagliato(forKey: EsercizioKey.Uno)
        // DO LOOSE ANIMATION AND LEFT HAND ANIMATION
        let dialogMessage = UIAlertController(title: "Sbagliato", message: "Non preoccuparti, ce la puoi fare.", preferredStyle: .alert)
        let yeah = UIAlertAction(title: "OK, riproviamo!", style: .cancel) { (action) -> Void in
            print("Sbagliato")
        }
        dialogMessage.addAction(yeah)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    func Reset() {
        btnReset.isHidden = true
        gameEnded = false
        btnHelp.isHidden = false
        btnHelp.setImage(UIImage(named: "Help"), for: .normal)
        GenerateNumbersViews()
    }
    
    func EndGame(vinto: Bool) {
        if vinto {
            Win()
            btnHelp.isHidden = true
        }
        else {
            Loose()
            btnHelp.setImage(UIImage(named: "Idea"), for: .normal)
        }
        btnReset.isHidden = false
        gameEnded = true
    }
    
    @IBAction func btnReset(_ sender: Any) {
        Reset()
    }
    
    @IBAction func btnHelpClick(_ sender: Any) {
        openHelpView()
    }
}

