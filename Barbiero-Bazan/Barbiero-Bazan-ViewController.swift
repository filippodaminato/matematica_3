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
    
    init(originView origin: UIView, destinationView dest: UIView, rootView root: UIView, value n: Int) {
        super.init(frame: .zero)
        rootView = root
        originView = origin
        destinationView = dest
        num = n
        rootView!.addSubview(self)
        rootView!.bringSubviewToFront(self)
        //self.translatesAutoresizingMaskIntoConstraints = false
        self.frame = originView!.frame
        isPickedUp = true
        self.contentMode = .scaleAspectFill
        self.autoresizesSubviews = true
        self.layer.cornerRadius = 40
        self.clipsToBounds = true
        self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        Move(toView: originView!, withDuration: 0, withDelay: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
            }) { (true) in
                self.isPickedUp = true
            }
            
        }
    }
    
    func AnimateDrop() {
        if isPickedUp {
            self.transform = CGAffineTransform(scaleX: 1.2, y: 1.8)
            currentView?.isHidden = true
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
    
    var originViews = [UIView]()
    var destinationViews = [UIView]()
    
    var numbersViews = [DragNumberImageView]()
    
    var images = [UIImageView]()
    
    let imagesImage = [UIImage(named: "Decine"), UIImage(named: "Unità"), UIImage(named: "Decimi"), UIImage(named: "Centesimi")]
    
    var helpView : HelpViewController?
    
    @IBOutlet weak var lblTitolo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UpdateContainerViewArrays()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        GenerateNumbersViews()
        let defaults = UserDefaults.standard
        if !defaults.bool(forKey: "FirstTime" + EsercizioKey.Uno.rawValue) {
            defaults.set(true, forKey: "FirstTime" + EsercizioKey.Uno.rawValue)
            defaults.synchronize()
            openHelpView()
        }
        // REMOVE
        //defaults.set(false, forKey: "FirstTime" + EsercizioKey.Uno.rawValue)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backButtonClick(_ sender: Any) {
        self.dismiss(animated: true, completion: {})
    }
    
    func openHelpView() {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "help") as? HelpViewController {
            lblTitolo.isHidden = true
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
    
    func UpdatePercorsi(controller c : HelpViewController) {
        Percorso.mano = [PassaggioMano]()
        for i in 0...3 {
            UpdatePercorsiNumberView(index: i, controller: c)
        }
    }
    
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
    
    func DismissHelpView() {
        lblTitolo.isHidden = false
        helpView?.working = false
        helpView?.view.removeFromSuperview()
        GenerateNumbersViews()
    }
    
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
            let val = Int((String)(random[random.index(random.startIndex, offsetBy: i) ]))!
            print(val)
            numbersViews.append(DragNumberImageView(originView: originViews[order[i]], destinationView: destinationViews[i], rootView: self.view, value: val))
            numbersViews[i].isUserInteractionEnabled = true
            numbersViews[i].addGestureRecognizer(NewPanGestureRecognizer())
            //numbersViews[i].backgroundColor = UIColor.red
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
                //view.Move(toView: view.originView!, withDuration: 0.5, withDelay: 0)
                CheckDestination(view: view)
            }
        }
        recognizer.setTranslation(CGPoint.zero, in: self.view)
    }
    
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
    
    @IBAction func btnVerifica(_ sender: Any) {
        let vinto = CheckCorrectPositions()
        if vinto {
            //Statistiche.aggiungiGiusto(forKey: EsercizioKey.Uno)
            let dialogMessage = UIAlertController(title: "HAI VINTO!", message: "", preferredStyle: .alert)
            let yeah = UIAlertAction(title: "Ricominciamo!", style: .cancel) { (action) -> Void in
                print("Vinto")
                self.GenerateNumbersViews()
            }
            dialogMessage.addAction(yeah)
            self.present(dialogMessage, animated: true, completion: nil)
        }
        else {
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

