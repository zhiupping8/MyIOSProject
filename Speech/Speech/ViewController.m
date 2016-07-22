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
    
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
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
                    [self.recordButton setTitle:@"Speech recognition restricted on this device" forState:UIControlStateNormal];
                    break;
                case SFSpeechRecognizerAuthorizationStatusAuthorized:
                    self.recordButton.enabled = YES;
                    break;
            }

        }];
        [[NSOperationQueue mainQueue] addOperation:operation];
    }];
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
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *categoryError = nil;
    [audioSession setCategory:AVAudioSessionCategoryRecord error:&categoryError];
    if (categoryError) {
        NSLog(@"categoryError:%@", categoryError);
    }
    
    NSError *modeError = nil;
    [audioSession setMode:AVAudioSessionModeMeasurement error:&modeError];
    if (modeError) {
        NSLog(@"modeError:%@", modeError);
    }
    
    NSError *activeError = nil;
    [audioSession setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&activeError];
    if (activeError) {
        NSLog(@"activeError:%@", activeError);
    }
    
    self.speechAudioBufferRecognitionRequest = [SFSpeechAudioBufferRecognitionRequest new];
    
    if (nil == self.audioEngine.inputNode) {
        NSLog(@"Audio engine has no input node");
    }
    
    if (nil == self.speechAudioBufferRecognitionRequest) {
        NSLog(@"Unable to created a SFSpeechAudioBufferRecognitionRequest object");
    }
    
    self.speechAudioBufferRecognitionRequest.shouldReportPartialResults = YES;
    
    self.speechRecognitionTask = [self.speechRecognizer recognitionTaskWithRequest:self.speechAudioBufferRecognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        BOOL isFinal = NO;
        if (result) {
            self.textView.text = result.bestTranscription.formattedString;
            isFinal = result.isFinal;
        }
        
        if (error != nil || isFinal) {
            [self.audioEngine stop];
//            inputNode.removeTap(onBus: 0)
            [self.audioEngine.inputNode removeTapOnBus:0];
            self.speechAudioBufferRecognitionRequest = nil;
            self.speechRecognitionTask = nil;
            
            self.recordButton.enabled = YES;
            [self.recordButton setTitle:@"Start Recording" forState:UIControlStateNormal];
        }
    }];
    
//    let recordingFormat = inputNode.outputFormat(forBus: 0)
//    inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
//        self.recognitionRequest?.append(buffer)
//    }
    
    AVAudioFormat *recordFormat = [self.audioEngine.inputNode outputFormatForBus:0];
    [self.audioEngine.inputNode installTapOnBus:0 bufferSize:1024 format:recordFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        [self.speechAudioBufferRecognitionRequest appendAudioPCMBuffer:buffer];
    }];
    [self.audioEngine prepare];
    NSError *startError = nil;
    [self.audioEngine startAndReturnError:&startError];
//    textView.text = "(Go ahead, I'm listening)"
    self.textView.text = @"(Go ahead, I'm listening)";
    
}

- (void)speechRecognizer:(SFSpeechRecognizer *)speechRecognizer availabilityDidChange:(BOOL)available {
    
    if (available) {
        self.recordButton.enabled = YES;
        [self.recordButton setTitle:@"Start Recording" forState:UIControlStateNormal];
    } else {
        self.recordButton.enabled = NO;
        [self.recordButton setTitle:@"Recognition not available" forState:UIControlStateDisabled];
    }
    
}

- (IBAction)touchRecordButton:(id)sender {
    if (self.audioEngine.isRunning) {
        [self.audioEngine stop];
        [self.speechAudioBufferRecognitionRequest endAudio];
        self.recordButton.enabled = NO;
        [self.recordButton setTitle:@"Stopping" forState:UIControlStateDisabled];
    } else {
        [self startRecording];
        [self.recordButton setTitle:@"Stop recording" forState:UIControlStateNormal];
    }
}

@end
