//
//  ConcentrationThemeChooserViewController.swift
//  Set
//
//  Created by Иван Лузин on 02.07.2018.
//  Copyright © 2018 Иван Лузин. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController, UISplitViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func awakeFromNib() {
        splitViewController?.delegate = self
    }

    var themes = [
        Theme(
            name: "Animals",
            symbols: ["🐶", "🐱", "🐭", "🦊", "🐻", "🐸", "🐙", "🦁"],
            primaryColor: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1),
            secondaryColor: #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)),
        Theme(
            name: "Sports",
            symbols: ["⚽️", "🏀", "🏈", "⚾️", "🎾", "🏐", "🏉", "🎱"],
            primaryColor: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1),
            secondaryColor: #colorLiteral(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051, alpha: 1)),
        Theme(
            name: "Hearts",
            symbols: ["❤️", "🧡", "💛", "💚", "💙", "💜", "🖤", "💖"],
            primaryColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1),
            secondaryColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)),
        Theme(
            name: "Things",
            symbols: ["☎️", "📺", "💽", "🕹", "🎛", "⏰", "🔋", "💡"],
            primaryColor: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1),
            secondaryColor: #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1)),
        Theme(
            name: "Cars",
            symbols: ["🚗", "🚕", "🚙", "🚌", "🚎", "🏎", "🚓", "🚑"],
            primaryColor: #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1),
            secondaryColor: #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)),
        Theme(
            name: "Travel",
            symbols: ["🗿", "🗽", "🗼", "🏰", "🏯", "🏟", "🏝", "⛲️"],
            primaryColor: #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1),
            secondaryColor: #colorLiteral(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051, alpha: 1))
    ]

    private var splitViewDetailConcentrationViewController: ConcentrationViewController? {
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }

    //create a strong reference to view controller so it won't be dropped out from heap
    private var lastSeguedToConcentrationViewController: ConcentrationViewController?

    @IBOutlet var themeButtons: [UIButton]! {
        didSet {
            for index in themeButtons.indices {
                themeButtons[index].setTitle(themes[index].name, for: .normal)
            }
        }
    }

    @IBAction func selectTheme(sender: UIButton) {
        if let cvc = splitViewDetailConcentrationViewController {
            if let themeIndex = themeButtons.index(of: sender) {
                cvc.theme = themes[themeIndex]
            }
        } else if let cvc = lastSeguedToConcentrationViewController {
            if let themeIndex = themeButtons.index(of: sender) {
                cvc.theme = themes[themeIndex]
            }
            navigationController?.pushViewController(cvc, animated: true)
        } else {
            performSegue(withIdentifier: "Choose Theme", sender: sender)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    // preparation happens before target vc is set!
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose Theme" {
            if let button = sender as? UIButton,
                let themeIndex = themeButtons.index(of: button),
                let cvc = segue.destination as? ConcentrationViewController {
                cvc.theme = themes[themeIndex]
                lastSeguedToConcentrationViewController = cvc
            }
        }
    }
}
