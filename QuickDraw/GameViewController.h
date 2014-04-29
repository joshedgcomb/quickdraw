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
#import "Smooth_Line_ViewViewController.h"

@interface GameViewController : UIViewController{

    IBOutlet UIImageView *mainImage;
    IBOutlet UIImageView *tempDrawImage;

    SmoothLineView * smoothLineView;
    
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
    NSString* name;
    


    
}

@property (strong, nonatomic) IBOutlet UILabel *stopwatchLabel;

- (IBAction)saveDrawing:(id)sender;

@end
