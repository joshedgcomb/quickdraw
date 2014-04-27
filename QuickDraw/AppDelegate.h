//
//  AppDelegate.h
//  QuickDraw
//
//  Created by jarthurcs on 2/24/14.
//  Copyright (c) 2014 jverticchio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Database.h"
#import <Parse/Parse.h>
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) AVAudioPlayer *myAudioPlayer;

@end
