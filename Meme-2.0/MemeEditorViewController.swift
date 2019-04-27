//
//  MemeEditorViewController.swift
//  Meme-2.0
//
//  Created by Sameer Almutairi on 25/04/2019.
//  Copyright © 2019 Sameer Almutairi. All rights reserved.
//

import UIKit

// MARK: - class ViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate

class MemeEditorViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var ImagePickerView: UIImageView!
    @IBOutlet weak var camerabutton: UIBarButtonItem!
    @IBOutlet weak var navbar: UIToolbar!
    @IBOutlet weak var toolbar: UIToolbar!
    
    // TextField Configuration
    
    func configureTextField(_ textField: UITextField, _ text: String){
        textField.text = text
        textField.delegate = self
        textField.autocapitalizationType = .allCharacters
        textField.defaultTextAttributes = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth: -4
        ]
        textField.textAlignment = .center
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextField(topText, "TOP")
        configureTextField(bottomText, "BOTTOM")
        
        self.shareButton.isEnabled = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        camerabutton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    //var memedImage = UIImage()
    
    // MARK: - Meme Actions
    
    func saveMeme(memedImage:UIImage){
        // Create the meme
        let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, OriginalImage: ImagePickerView.image!, memedImage: memedImage)

        // Add meme to to the memes array on the Application Delegates
//        let object = UIApplication.shared.delegate
//        let appDelegate = object as! AppDelegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
        print("meme is")
        print(appDelegate.memes)
//        print("meme Count:")
//        print(appDelegate.memes.count)

    }

    
    @IBAction func shareImage(_ sender: Any) {
        let memedImage: UIImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        controller.completionWithItemsHandler = {
            (activity, success, items, error) in
            if success {
                self.saveMeme(memedImage:memedImage)
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        present(controller, animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        hideOrShowToolbarAndNavbar(true)
        
        // Render view to an Image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        hideOrShowToolbarAndNavbar(false)
        
        return memedImage
        
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
//        configureTextField(topText, "TOP")
//        configureTextField(bottomText, "BOTTOM")
//        ImagePickerView.image = nil
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Image Picker Actions
    
    func pickAnImage(_ source: UIImagePickerController.SourceType){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        shareButton.isEnabled = true
        pickerController.sourceType = source
        present(pickerController, animated: true, completion:  nil)
    }
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        pickAnImage(.photoLibrary)
    }
    
    @IBAction func pickImageFromCamera(_ sender: Any) {
        pickAnImage(.camera)
    }
    
    // MARK: - TextFields Delegates
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.text == "TOP" || textField.text == "BOTTOM") {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - notification
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: Keyboard Actions
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if bottomText.isFirstResponder{
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
        
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillHide(_ notification: Notification){
        view.frame.origin.y = 0
    }
    
    
    // MARK: - Toolbar and Navbar
    
    func hideOrShowToolbarAndNavbar(_ hidden: Bool){
        self.navbar.isHidden = hidden
        self.toolbar.isHidden = hidden
    }
    
}


// MARK: - extension MemeEditorViewController: UIImagePickerControllerDelegate

extension MemeEditorViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            ImagePickerView.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
