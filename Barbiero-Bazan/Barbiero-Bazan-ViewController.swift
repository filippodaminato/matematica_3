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
    var allenamento = false
    var maxNumTentativi = 2
    var tentativi = 0
    
    var giusti = 0
    var sbagliati = 0
    
    var defaultGameTime = 120
    var gameTime = 0
    
    var timer : Timer? = nil
    
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
    
    var menuView : MenuViewController?
    
    /// help button
    @IBOutlet weak var btnHelp: UIButton!
    
    @IBOutlet weak var btnReset: UIButton!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var wrongImageView: UIImageView!
    @IBOutlet weak var rightImageView: UIImageView!
    
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var lblSbagliati: UILabel!
    @IBOutlet weak var lblGiusti: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BarbieroBazan.instance = self
        wrongImageView.image = UIImage(cgImage: UIImage(named: "Sbagliato")!.cgImage!, scale: CGFloat(1.0), orientation: .down)
        UpdateContainerViewArrays()
        OpenMenu()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func OpenMenu() {
        if menuView == nil {
            if let controller = storyboard?.instantiateViewController(withIdentifier: "menu") as? MenuViewController {
                menuView = controller
            }
        }
        if let menu = menuView {
            addChild(menu)
            self.view.addSubview(menu.view)
            //self.view.bringSubviewToFront(menu.view)
        }
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
        timer?.invalidate()
        OpenMenu()
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
            }
        }
        recognizer.setTranslation(CGPoint.zero, in: self.view)
    }
    
    func CheckIfAllDragged() {
        for v in numbersViews {
            if v.currentView == v.originView || v.isPickedUp {
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
        giusti += 1
        if allenamento {
            self.view.AnimateTextWithImage(text: "Bravo!", image: UIImage(), time: 2.5)
        }
        AnimateWin(0)
        //Statistiche.aggiungiGiusto(forKey: EsercizioKey.Uno)
        lblGiusti.text = String(giusti)
    }
    
    func Loose() {
        sbagliati += 1
        if allenamento {
            self.view.AnimateTextWithImage(text: "Hai sbagliato", image: UIImage(), time: 2.5)
        }
        AnimateLoose(0)
        //Statistiche.aggiungiSbagliato(forKey: EsercizioKey.Uno)
        lblSbagliati.text = String(sbagliati)
    }
    
    private func AnimateWin(_ i : Int) {
        UIView.animate(withDuration: 0.3, animations: {
            self.rightImageView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (true) in
            UIView.animate(withDuration: 0.3, animations: {
                self.rightImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }) { (true) in
                if i < 3 {
                    self.AnimateWin(i + 1)
                }
            }
        }
        
    }
    
    private func AnimateLoose(_ i : Int) {
        UIView.animate(withDuration: 0.3, animations: {
            self.wrongImageView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (true) in
            UIView.animate(withDuration: 0.3, animations: {
                self.wrongImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }) { (true) in
                if i < 3 {
                    self.AnimateLoose(i + 1)
                }
            }
        }
    }
    
    private func AnimateReset(delay d : Double) {
        UIView.animate(withDuration: 0.5, delay: d, options: [.curveEaseIn, .allowUserInteraction], animations: {
            self.btnReset.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }) { (true) in
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut, .allowUserInteraction], animations: {
                self.btnReset.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * 2))
            }, completion: { (true) in
                self.btnReset.transform = CGAffineTransform(rotationAngle: 0)
                if self.gameEnded {
                    self.AnimateReset(delay: 1)
                }
            })
        }
    }
    
    private func AnimateHelp(delay d : Double) {
        UIView.animate(withDuration: 0.5, delay: d, options: [.curveEaseIn, .allowUserInteraction], animations: {
            self.btnHelp.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }) { (true) in
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut, .allowUserInteraction], animations: {
                self.btnHelp.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: { (true) in
                if self.gameEnded {
                    self.AnimateHelp(delay: 1)
                }
            })
        }
    }
    
    func dismissMenu(allenamento a : Bool) {
        if let menu = menuView {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                menu.view.alpha = 0
            }) { (true) in
                menu.view.removeFromSuperview()
                menu.view.alpha = 1
            }
        }
        giusti = 0
        sbagliati = 0
        lblGiusti.text = "0"
        lblSbagliati.text = "0"
        if a {
            StartAllenamento()
        }
        else {
            StartSfida()
        }
    }
    
    func StartAllenamento() {
        allenamento = true
        lblTimer.isHidden = true
        Reset()
    }
    
    func StartSfida() {
        allenamento = false
        lblTimer.isHidden = false
        Reset()
        StartTimer()
    }
    
    func Reset() {
        if allenamento {
            btnHelp.isHidden = false
            lblTimer.isHidden = true
            btnHelp.setImage(UIImage(named: "Help"), for: .normal)
        }
        else {
            btnHelp.isHidden = true
            lblTimer.isHidden = false
            giusti = 0
            sbagliati = 0
            lblGiusti.text = "0"
            lblSbagliati.text = "0"
            lblTimer.text = "02:00"
        }
        btnReset.isHidden = true
        gameEnded = false
        tentativi = 0
        GenerateNumbersViews()
    }
    
    func StartTimer() {
        gameTime = defaultGameTime
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: true)
    }
    
    @objc func handleTimer() {
        gameTime -= 1
        lblTimer.text = timeString(time: TimeInterval(gameTime))
        if gameTime <= 0 {
            timer?.invalidate()
            AnimateReset(delay: 3)
            btnReset.isHidden = false
            gameEnded = true
        }
    }
    
    func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
    
    func EndGame(vinto: Bool) {
        if vinto {
            tentativi = 0
            Win()
            btnHelp.isHidden = true
            if !allenamento {
                Reset()
                return
            }
        }
        else {
            if allenamento {
                tentativi += 1
                if tentativi < maxNumTentativi {
                    self.view.AnimateTextWithImage(text: "Ritenta!", image: UIImage(), time: 1.5)
                    AnimateLoose(5)
                    return
                }
                btnHelp.setImage(UIImage(named: "Idea"), for: .normal)
                AnimateHelp(delay: 3)
            }
            else {
                Reset()
                Loose()
                return
            }
            Loose()
            tentativi = 0
        }
        AnimateReset(delay: 3)
        btnReset.isHidden = false
        gameEnded = true
    }
    
    @IBAction func btnReset(_ sender: Any) {
        if !allenamento {
            StartTimer()
        }
        Reset()
    }
    
    @IBAction func btnHelpClick(_ sender: Any) {
        openHelpView()
    }
    
}

