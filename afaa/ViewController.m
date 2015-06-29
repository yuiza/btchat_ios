//
//  ViewController.m
//  BluetoothTextMessenger
//
//  Created by Cindy Crabtree on 7/20/12.
//  Copyright (c) 2012 Tap Dezign, LLC. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
- (void)sendMessage:(id)sender;
- (void)connectToDevice:(id)sender;

@end

@implementation ViewController

@synthesize messageReceivedLabel    = _messageReceivedLabel;
@synthesize messageToSendTextField  = _messageToSendTextField;
@synthesize session                 = _session;
@synthesize sendButton              = _sendButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)connectToDevice:(id)sender
{
    if (self.session == nil) {
        //create peer picker and show picker of connections
        GKPeerPickerController *peerPicker = [[GKPeerPickerController alloc] init];
        peerPicker.delegate = self;
        peerPicker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
        [peerPicker show];
    }
    
}

- (void)sendMessage:(id)sender 
{   
    //package text field text as NSData object 
    NSData *textData = [self.messageToSendTextField.text dataUsingEncoding:NSASCIIStringEncoding];
    //send data to all connected devices
    [self.session sendDataToAllPeers:textData withDataMode:GKSendDataReliable error:nil];
    
}

#pragma mark - 
#pragma mark - GKPeerPickerControllerDelegate
- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type
{
    //create ID for session
    NSString *sessionIDString = @"MTBluetoothSessionID";
    //create GKSession object
    GKSession *session = [[GKSession alloc] initWithSessionID:sessionIDString displayName:nil sessionMode:GKSessionModePeer];
    return session;
}

- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session
{
    //set session delegate and dismiss the picker
    session.delegate = self;
    self.session = session; 
    picker.delegate = nil;
    [picker dismiss];
}

#pragma mark - 
#pragma mark - GKSessionDelegate
- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
    if (state == GKPeerStateConnected){
        [session setDataReceiveHandler:self withContext:nil]; //set ViewController to receive data
        self.sendButton.enabled = YES; //enable send button when session is connected
    }
    else {
        self.sendButton.enabled = NO; //disable send button if session is disconnected
        self.session.delegate = nil; 
        self.session = nil; //allow session to reconnect if it gets disconnected
    }
}

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context
{   
    //unpackage NSData to NSString and set incoming text as label's text
    NSString *receivedString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    self.messageReceivedLabel.text = receivedString;
    
}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
