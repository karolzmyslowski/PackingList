

import UIKit

class ViewController: UIViewController {

 
  @IBOutlet var tableView: UITableView!
  @IBOutlet var buttonMenu: UIButton!
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var menuHeightConstraint: NSLayoutConstraint!
  @IBOutlet var buttonWeighConstraint: NSLayoutConstraint!
  
  var slider: HorizontalItemList!
  var menuIsOpen = false
  var items: [Int] = [5, 6, 7]
  
  
  @IBAction func toggleMenu(_ sender: AnyObject) {
    menuIsOpen = !menuIsOpen
    
    titleLabel.text = menuIsOpen ? "Select Item" : "Packing List"
    view.layoutIfNeeded()
    
    titleLabel.superview?.constraints.forEach { constraint in
        if constraint.identifier == "CenterX"{
            constraint.isActive = false
            
            let newConstraint = NSLayoutConstraint(
                item: titleLabel,
                attribute: .centerX ,
                relatedBy: .equal,
                  toItem: titleLabel.superview!,
                  attribute: .centerX,
                  multiplier: 1,
                  constant: menuIsOpen ? -100 : 0)
            newConstraint.identifier = "CenterX"
            newConstraint.isActive = true
        } else if constraint.identifier == "CenterY" {
             constraint.isActive = false
            
            let newConstraint2 = NSLayoutConstraint(
                item: titleLabel,
                attribute: .centerY ,
                relatedBy: .equal,
                toItem: titleLabel.superview!,
                attribute: .centerY,
                multiplier: menuIsOpen ? 0.67 : 1.0,
                constant: 5.0)
            newConstraint2.identifier = "CenterY"
            newConstraint2.isActive = true
        }

        
    }
    
    menuHeightConstraint.constant = menuIsOpen ? 200.0 : 60
    buttonWeighConstraint.constant = menuIsOpen ? 16 : 8

    
    
    
    
    
    UIView.animate(withDuration: 1.33,
                   delay: 0.0,
                   usingSpringWithDamping: 0.4,
                   initialSpringVelocity: 10,
                   options: [.allowUserInteraction],
                   animations: {
                    self.view.layoutIfNeeded()
                    let angle: CGFloat =
                    self.menuIsOpen ? .pi/4 : 0
                    self.buttonMenu.transform = CGAffineTransform(rotationAngle: angle)
    },
                   completion: nil)
    
  }
  
  func showItem(_ index: Int) {
    let imageView = makeImageView(index: index)
    view.addSubview(imageView)
    
    
    let conX = imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    let conBotton = imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: imageView.frame.height)
    let conWidth = imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.33, constant: -50.0)
    let conHeight = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
    NSLayoutConstraint.activate([conX, conBotton, conWidth, conHeight])
    view.layoutIfNeeded()
    
    UIView.animate(withDuration: 0.8,
                   delay: 0,
                   usingSpringWithDamping: 0.6,
                   initialSpringVelocity: 10,
                   options: [],
                   animations: {
        conBotton.constant = -imageView.frame.size.height / 2
        conWidth.constant = 0.0
         self.view.layoutIfNeeded()
        }, completion: nil)
    
    
    delay(seconds: 1.0) {
        UIView.transition(with: imageView,
                          duration: 1.0,
                          options: [.transitionFlipFromBottom],
                          animations: {
                            imageView.isHidden = true
        },
                          completion: { _ in
                            imageView.removeFromSuperview()
        })
    }
  }

  func transitionCloseMenu() {
    delay(seconds: 0.35, completion: {
      self.toggleMenu(self)
    })
    
    let titleBar = slider.superview!
    
    UIView.transition(with: titleBar,
                      duration: 0.5, options: [
        .curveEaseOut,
        .transitionFlipFromBottom],
                      animations: {
                        self.slider.removeFromSuperview()
    }) {_ in
        titleBar.addSubview(self.slider)
    }
    
}
}


let itemTitles = ["Icecream money", "Great weather", "Beach ball", "Swim suit for him", "Swim suit for her", "Beach games", "Ironing board", "Cocktail mood", "Sunglasses", "Flip flops"]


extension ViewController: UITableViewDelegate, UITableViewDataSource {
  func makeImageView(index: Int) -> UIImageView {
    let imageView = UIImageView(image: UIImage(named: "summericons_100px_0\(index).png"))
    imageView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
    imageView.layer.cornerRadius = 5.0
    imageView.layer.masksToBounds = true
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }
  
  func makeSlider() {
    slider = HorizontalItemList(inView: view)
    slider.didSelectItem = {index in
      self.items.append(index)
      self.tableView.reloadData()
      self.transitionCloseMenu()
    }
    self.titleLabel.superview?.addSubview(slider)
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    makeSlider()
    self.tableView?.rowHeight = 54.0
  }
  
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
    cell.accessoryType = .none
    cell.textLabel?.text = itemTitles[items[indexPath.row]]
    cell.imageView?.image = UIImage(named: "summericons_100px_0\(items[indexPath.row]).png")
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    showItem(items[indexPath.row])
  }
  
}
