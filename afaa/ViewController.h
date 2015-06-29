//
//  ViewController.h
//  BluetoothTextMessenger
//
//  Created by Cindy Crabtree on 7/20/12.
//  Copyright (c) 2012 Tap Dezign, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

@interface ViewController : UIViewController <GKSessionDelegate, GKPeerPickerControllerDelegate>

@property (strong, nonatomic) UILabel           *messageReceivedLabel;
@property (strong, nonatomic) UITextField       *messageToSendTextField;
@property (strong, nonatomic) GKSession         *session;
@property (strong, nonatomic) UIButton          *sendButton; 

@end
