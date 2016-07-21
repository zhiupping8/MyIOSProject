//
//  ViewController.m
//  Speech
//
//  Created by YongZhi on 7/21/16.
//  Copyright © 2016 eric. All rights reserved.
//

#import "ViewController.h"
#import <Speech/Speech.h>

@interface ViewController ()<SFSpeechRecognizerDelegate>
@property (strong, nonatomic) SFSpeechRecognizer *speechRecognizer;
@property (strong, nonatomic) SFSpeechURLRecognitionRequest *speechURLRecognitionRequest;
@property (strong, nonatomic) SFSpeechAudioBufferRecognitionRequest *speechAudioBufferRecognitionRequest;
@property (strong, nonatomic) SFSpeechRecognitionTask *speechRecognitionTask;
@property (strong, nonatomic) AVAudioEngine *audioEngine;

//UI Element
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;

@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.recordButton.enabled = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.speechRecognizer.delegate = self;
    
//    SFSpeechRecognizerAuthorizationStatusNotDetermined,
//    SFSpeechRecognizerAuthorizationStatusDenied,
//    SFSpeechRecognizerAuthorizationStatusRestricted,
//    SFSpeechRecognizerAuthorizationStatusAuthorized,
    
    switch ([SFSpeechRecognizer authorizationStatus]) {
        case SFSpeechRecognizerAuthorizationStatusNotDetermined:
            self.recordButton.enabled = NO;
            [self.recordButton setTitle:@"Speech recognition not yet authorized" forState:UIControlStateNormal];
            break;
        case SFSpeechRecognizerAuthorizationStatusDenied:
            self.recordButton.enabled = NO;
            [self.recordButton setTitle:@"User denied access to speech recognition" forState:UIControlStateNormal];
            break;
        case SFSpeechRecognizerAuthorizationStatusRestricted:
            self.recordButton.enabled = NO;
//            self.recordButton.setTitle("Speech recognition restricted on this device", for: .disabled)
            [self.recordButton setTitle:@"Speech recognition restricted on this device" forState:UIControlStateNormal];
            break;
        case SFSpeechRecognizerAuthorizationStatusAuthorized:
            self.recordButton.enabled = YES;
            break;
            
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startRecording {
    if(self.speechRecognitionTask) {
        [self.speechRecognitionTask cancel];
        self.speechRecognitionTask = nil;
    }
    
    AVAudioSession *audioSession = [[AVAudioSession alloc] init];
    NSError *categoryError = nil;
    [audioSession setCategory:AVAudioSessionCategoryRecord error:&categoryError];
    NSError *modeError = nil;
    [audioSession setMode:AVAudioSessionModeMeasurement error:&modeError];
    NSError *activeError = nil;
    [audioSession setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&activeError];
    
    self.speechAudioBufferRecognitionRequest = 
    
    
//    @try {
//        <#Code that can potentially throw an exception#>
//    } @catch (NSException *exception) {
//        <#Handle an exception thrown in the @try block#>
//    } @finally {
//        <#Code that gets executed whether or not an exception is thrown#>
//    }
    
}


@end
