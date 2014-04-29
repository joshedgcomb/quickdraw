//
//  ViewController.h
//  WTMGlyphDemo
//
//  Created by Torin Nguyen on 5/7/12.
//  Copyright (c) 2012 torin.nguyen@2359media.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShapeView.h"
#import <Parse/Parse.h>

@interface GlyphViewController : UIViewController{

    NSTimer *timer;
    NSString* name;
    NSDate *startDate;
    double startTime;
    int lastTime;
    int drawCount;
    int totalScore;
    int tempScore;
    bool gameOver;
    ShapeView *shape;
    NSString *statusString;
}

@property (weak, nonatomic) IBOutlet UIProgressView *timerBar;

@property NSString *highScoreName;

- (IBAction)donePressed:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *nextRound;

@end
