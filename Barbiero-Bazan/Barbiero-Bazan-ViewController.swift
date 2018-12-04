//
//  ViewController.swift
//  Barbiero-Bazan
//
//  Created by Giovanni Barbiero on 29/07/18.
//  Copyright © 2018 Giovanni Barbiero. All rights reserved.
//

import UIKit

extension UIView {
    func GetFrameInRootView(rootView: UIView) -> CGRect{
        let newOrigin = GetOriginInRootView(rootView: rootView)
        return CGRect(x: newOrigin.x, y: newOrigin.y, width: self.frame.width, height: self.frame.height)
    }
    
    func GetOriginInRootView(rootView: UIView) -> CGPoint{
        return rootView.convert(self.frame.origin, from: self.superview)
    }
    
    func GetCenterInRootView(rootView: UIView) -> CGPoint{
        return rootView.convert(self.center, from: self.superview)
    }
}

class DragNumberImageView : UIImageView {
    
    var num : Int = 0
    
    var rootView : UIView? = nil
    
    // view di origine del drag
    var originView : UIView? = nil
    
    var destinationView : UIView? = nil
    
    var currentView : UIView? = nil
    
    var isPickedUp = false
    
    var borderColor : UIColor = UIColor.white
    
    init(originView origin: UIView, destinationView dest: UIView, rootView root: UIView, value n: Int) {
        super.init(frame: .zero)
        rootView = root
        originView = origin
        destinationView = dest
        num = n
        rootView!.addSubview(self)
        rootView!.bringSubviewToFront(self)
        self.frame = originView!.frame
        isPickedUp = true
        self.contentMode = .scaleAspectFill
        self.autoresizesSubviews = true
        self.layer.cornerRadius = 40
        self.clipsToBounds = true
        self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        Move(toView: originView!, withDuration: 0, withDelay: 0)
    }
    
    convenience init(originView origin: UIView, destinationView dest: UIView, rootView root: UIView, value n: Int, color c: UIColor) {
        self.init(originView: origin, destinationView: dest, rootView: root, value: n)
        borderColor = c
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func UpdateColor() {
        self.layer.borderWidth = 3
        self.layer.borderColor = borderColor.cgColor
    }
    
    func ClearColor() {
        self.layer.borderColor = UIColor.white.cgColor
    }
    
    func Move(toView view: UIView, withDuration dur: Double, withDelay del: Double) {
        currentView = view
        UIView.animate(withDuration: dur, delay: del, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [],  animations: {
            self.center = view.GetCenterInRootView(rootView: self.rootView!)
        }) { (true) in
            self.AnimateDrop()
        }
    }
    
    func AnimatePickUp() {
        if !isPickedUp {
            self.transform = CGAffineTransform(scaleX: 0.8, y: 1.2)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [],  animations: {
                self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                self.UpdateColor()
            }) { (true) in
                self.isPickedUp = true
            }
        }
    }
    
    func AnimateDrop() {
        if isPickedUp {
            self.transform = CGAffineTransform(scaleX: 1.2, y: 1.8)
            currentView?.isHidden = true
            if currentView == originView {
                ClearColor()
            }
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [],  animations: {
                self.transform = .identity
            }){ (true) in
                self.isPickedUp = false
                self.currentView?.isHidden = false
            }
        }
    }
    
    func Duplica() -> DragNumberImageView {
        return DragNumberImageView(originView: originView!, destinationView: destinationView!, rootView: rootView!, value: num)
    }
}

class BarbieroBazan: UIViewController {
    
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
    
    /// title label
    @IBOutlet weak var lblTitolo: UILabel!
    
    /// help button
    @IBOutlet weak var btnHelp: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UpdateContainerViewArrays()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        GenerateNumbersViews()
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
            lblTitolo.isHidden = true
            btnHelp.isHidden = true
            addChild(controller)
            helpView = controller
            self.view.addSubview(controller.view)
            controller.addNumView(numView: numbersViews[0].Duplica())
            controller.addNumView(numView: numbersViews[1].Duplica())
            controller.addNumView(numView: numbersViews[2].Duplica())
            controller.addNumView(numView: numbersViews[3].Duplica())
            for v in controller.numView {
                v.image = UIImage(named: "\(v.num)")
            }
            for v in numbersViews {
                v.image = nil
            }
            controller.padre = self
            UpdatePercorsi(controller: controller)
            controller.EndAnimation()
        }
    }
    
    /**
     Creates the path that `helpView.handImageView` has to follow
     
     - Parameter c: is the current instance of `HelpViewController`
     */
    func UpdatePercorsi(controller c : HelpViewController) {
        Percorso.mano = [PassaggioMano]()
        for i in 0...3 {
            UpdatePercorsiNumberView(index: i, controller: c)
        }
    }
    
    /**
     Adds the path that `helpView.handImageView` has to follow to move a number view
     
     - Parameters:
        - i: is the index to get the `DragImageView` instance from `c.numView`
        - c: is the current instance of `HelpViewController`
     */
    private func UpdatePercorsiNumberView(index i : Int, controller c : HelpViewController) {
        let originCenter = c.numView[i].originView!.GetCenterInRootView(rootView: self.view)
        let destinationCenter = c.numView[i].destinationView!.GetCenterInRootView(rootView: self.view)
        // sposta mano su numero
        var tempo = 1.5
        Percorso.mano.append(PassaggioMano(passaggio: Passaggio(destinazione: originCenter, tempo: tempo), stato: .Aperta, trasporta: nil))
        // prendi numero
        tempo = 0.2
        Percorso.mano.append(PassaggioMano(passaggio: Passaggio(destinazione: nil, tempo: tempo), stato: .Chiusa, trasporta: nil))
        // sposta numero e mano su destinazione
        tempo = 1.5
        Percorso.mano.append(PassaggioMano(passaggio: Passaggio(destinazione: destinationCenter, tempo: tempo), stato: .Chiusa, trasporta: c.numView[i]))
        // lascia numero
        tempo = 0.2
        Percorso.mano.append(PassaggioMano(passaggio: Passaggio(destinazione: nil, tempo: tempo), stato: .Aperta, trasporta: nil))
    }
    
    /**
     Closes the `helpView`
     */
    func DismissHelpView() {
        btnHelp.isHidden = false
        lblTitolo.isHidden = false
        helpView?.working = false
        helpView?.view.removeFromSuperview()
        GenerateNumbersViews()
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
                CheckIfAllDragged()
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
        // check vittoria
        if CheckCorrectPositions() {
            Win()
        }
        else {
            Loose()
        }
    }
    
    // check if destination view is already occupied
    func CheckDestination(view: DragNumberImageView) {
        for destV in destinationViews {
            if destV.GetFrameInRootView(rootView: self.view).contains(view.center) {
                for dragV in numbersViews {
                    if dragV.currentView == destV {
                        view.Move(toView: view.originView!, withDuration: 0.5, withDelay: 0)
                        return
                    }
                }
                view.Move(toView: destV, withDuration: 0.5, withDelay: 0)
                return
            }
        }
        view.Move(toView: view.originView!, withDuration: 0.5, withDelay: 0)
    }
    
    func NewPanGestureRecognizer() -> UIPanGestureRecognizer {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
        pan.maximumNumberOfTouches = 1
        
        return pan
    }
    
    func CheckCorrectPositions() -> Bool {
        for v in numbersViews {
            if (v.currentView! != v.destinationView!) {
                return false
            }
        }
        return true
    }
    
    func Win() {
        //Statistiche.aggiungiGiusto(forKey: EsercizioKey.Uno)
        let dialogMessage = UIAlertController(title: "HAI VINTO!", message: "", preferredStyle: .alert)
        let yeah = UIAlertAction(title: "Ricominciamo!", style: .cancel) { (action) -> Void in
            print("Vinto")
            self.GenerateNumbersViews()
        }
        dialogMessage.addAction(yeah)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    func Loose() {
        //Statistiche.aggiungiSbagliato(forKey: EsercizioKey.Uno)
        let dialogMessage = UIAlertController(title: "Sbagliato", message: "Non preoccuparti, ce la puoi fare.\nProva a ricontrollare se hai messo i numeri nella posizione giusta.", preferredStyle: .alert)
        let yeah = UIAlertAction(title: "OK, riproviamo!", style: .cancel) { (action) -> Void in
            print("Sbagliato")
            for i in 0...3 {
                self.numbersViews[i].Move(toView: self.numbersViews[i].originView!, withDuration: 1, withDelay: 0)
            }
        }
        dialogMessage.addAction(yeah)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    @IBAction func btnVerifica(_ sender: Any) {
        let vinto = CheckCorrectPositions()
        if vinto {
            Win()
        }
        else {
            Loose()
        }
    }
    
    @IBAction func btnReset(_ sender: Any) {
        let dialogMessage = UIAlertController(title: "Attenzione", message: "Sei sicuro di voler ricominciare la partita?", preferredStyle: .alert)
        
        let si = UIAlertAction(title: "Si", style: .default, handler: { (action) -> Void in
            print("Si")
            self.GenerateNumbersViews()
        })
        
        let annulla = UIAlertAction(title: "Annulla", style: .cancel) { (action) -> Void in
            print("Annullato")
        }
        
        dialogMessage.addAction(si)
        dialogMessage.addAction(annulla)
        
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    @IBAction func btnHelpClick(_ sender: Any) {
        openHelpView()
    }
}

