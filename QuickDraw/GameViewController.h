//
//  GameViewController.h
//  QuickDraw
//
//  Created by jarthurcs on 2/24/14.
//  Copyright (c) 2014 jverticchio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Database.h"

@interface GameViewController : UIViewController{

    IBOutlet UIImageView *mainImage;
    IBOutlet UIImageView *tempDrawImage;

    
    CGPoint lastPoint;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat brush;
    CGFloat opacity;
    BOOL mouseSwiped;
    UILabel *label;
    NSTimer *timer;
    NSDate *startDate;
    double startTime;
    int lastTime;
    


    
}

@property (strong, nonatomic) IBOutlet UILabel *stopwatchLabel;

- (IBAction)startTimer:(id)sender;
- (IBAction)stopTimer:(id)sender;
- (void) updateTimer;

@end
