import UIKit
import Speech
import PermissionScope

class SpeechToTextSearchViewController: UIViewController, SFSpeechRecognizerDelegate {
    let completion: ((_ text_attribute: String) -> Void)
    @IBOutlet weak var textView: UILabel!
    @IBOutlet weak var pushButtonImage: UIImageView!
    @IBOutlet weak var HoldAndRelease: UIButton!
    @IBOutlet weak var buttonBackgroundImage: UIImageView!
    private let pscope = PermissionScope()
    private let selectedImage: UIImage? = UIImage(named: "push_and_hold_selected")
    private let unselectedImage: UIImage? = UIImage(named: "push_and_hold_logo")
    private var speechRecognizer: SFSpeechRecognizer!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest!
    private var recognitionTask: SFSpeechRecognitionTask!
    private let audioEngine = AVAudioEngine()
    private var locales: [Locale]!
    private let defaultLocale = Locale(identifier: "en-US")
    private var pollOptionOne: String?
    private var pollOptionTwo: String?
    private var userSpeechString: String?
    
    
    // MARK:- Lifecycle
    init(completion: @escaping ((_ text_attribute: String) -> Void)) {
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        // english, do you speak it!?
        prepareRecognizer(locale: defaultLocale)
        pushButtonImage.image = FontAwesomeHelper.iconToImage(icon: .microphone, color: .black, width: 100, height: 100).withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        let blurBackgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blurBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(blurBackgroundView, at: 0)
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[background]|", options: [], metrics: nil, views: ["background":blurBackgroundView]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[background]|", options: [], metrics: nil, views: ["background":blurBackgroundView]))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        SFSpeechRecognizer.requestAuthorization { authStatus in }
        pscope.addPermission(MicrophonePermission(), message: "May Riskbit access your microphone?")
        pscope.show({ finished, results in
            print("got results \(results)")
        }, cancelled: { (results) -> Void in
            print("thing was cancelled")
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // [START speech recognition helper methods]
    private func prepareRecognizer(locale: Locale) {
        speechRecognizer = SFSpeechRecognizer(locale: locale)!
        speechRecognizer.delegate = self
    }
    
    private func startRecording() throws {
        
        // Cancel the previous task if it's running.
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSessionCategoryRecord)
        try audioSession.setMode(AVAudioSessionModeMeasurement)
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode else { fatalError("Audio engine has no input node") }
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to created a SFSpeechAudioBufferRecognitionRequest object") }
        
        // Configure request so that results are returned before audio recording is finished
        recognitionRequest.shouldReportPartialResults = true
        
        // A recognition task represents a speech recognition session.
        // We keep a reference to the task so that it can be cancelled.
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let strongSelf = self else { return }
            var isFinal = false
            
            if let result = result {
                strongSelf.textView.text = result.bestTranscription.formattedString.uppercased()
                strongSelf.userSpeechString = result.bestTranscription.formattedString
                isFinal = result.isFinal
                
                if(isFinal == true) {
                    guard let speechString = strongSelf.userSpeechString else { return }
                    print("user speech here \(speechString)")
                    strongSelf.dismiss(animated: true, completion: {
                        strongSelf.completion(speechString)
                    })
//                    let descriptionVC = AddTextDescriptionViewController(descriptionText: speechString, completion: strongSelf.completion)
//                    strongSelf.navigationController?.pushViewController(descriptionVC, animated: true)
                }
            }
            if error != nil || isFinal {
                strongSelf.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                strongSelf.recognitionRequest = nil
                strongSelf.recognitionTask = nil
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        try audioEngine.start()
        
        textView.text = "..."
    }
    
    @IBAction func touchDown(_ sender: Any) {
        self.buttonBackgroundImage.image = selectedImage
        try! startRecording()
    }

    
    @IBAction func touchUp(_ sender: AnyObject) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            self.buttonBackgroundImage.image = unselectedImage
        }
    }
}
