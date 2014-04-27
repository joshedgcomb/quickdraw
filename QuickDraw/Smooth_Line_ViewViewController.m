//  The MIT License (MIT)
//
//  Copyright (c) 2013 Levi Nunnink
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

//
//  Created by Levi Nunnink (@a_band) http://culturezoo.com
//  Copyright (C) Droplr Inc. All Rights Reserved
//


#import "Smooth_Line_ViewViewController.h"

#import <CoreMotion/CoreMotion.h>

@interface Smooth_Line_ViewViewController ()
@property (nonatomic) SmoothLineView * canvas;
@property (atomic) NSMutableArray *storedPath;
@property (strong, nonatomic) IBOutlet UIButton *clearAndReplay;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *clearEverything;


//Added stuff below:

@property (nonatomic, retain) CALayer *animationLayer;
@property (nonatomic, retain) CAShapeLayer *pathLayer;
@property (nonatomic, retain) CALayer *penLayer;
//end of added stuff
@end

@implementation Smooth_Line_ViewViewController

- (void)viewDidLoad
{
    SmoothLineView * smoothLineView =[[SmoothLineView alloc] initWithFrame:self.view.frame ];
//SmoothLineView * smoothLineView =[[SmoothLineView alloc] initWithFrame:self.view.bounds ];
  self.canvas = smoothLineView;
  smoothLineView.tag = 3;
  [self.view addSubview:smoothLineView];
 // [self.storedPath addObject:[SmoothLineView copyLineView:smoothLineView]];
    
  //[smoothLineView storePath:(id)self.storedPath];
    
  self.animationLayer = [CALayer layer];
  self.animationLayer.frame = CGRectMake(20.0f, 64.0f,
                                           CGRectGetWidth(self.view.layer.bounds) - 40.0f,
                                           CGRectGetHeight(self.view.layer.bounds) - 84.0f);
  //[self.view addSubview:self.clearAndReplay];
  [self.view addSubview:self.clearEverything];
}

-(BOOL)canBecomeFirstResponder {
  return YES;
}

- (IBAction)clearAndReplay:(UIButton *)sender {
    //clear
    for (UIView *subView in self.view.subviews)
    {
        if (subView.tag == 3)
        {
            [subView removeFromSuperview];
        }
    }
    //replay
    [self viewDidLoad];
}
- (IBAction)clearEverything:(UIButton *)sender {
    //store a copy
    //UIView * copy =[UIView alloc];
   // [copy init].subviews = self.view.subviews;
    //clear
    for (UIView *subView in self.view.subviews)
    {
        if (subView.tag == 3 && [subView isKindOfClass:[SmoothLineView class]])
        {
            [subView removeFromSuperview];
            double delayInSeconds = 2.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                NSLog(@"Do some work");
            });

            [self.storedPath addObject:subView];
        }
    }
    
    
    //reload
    /*[self viewDidLoad];*/
    //Use the following to prevent recursive calls
    UIView *parent = self.view.superview;
    [self.view removeFromSuperview];
    self.view = nil; // unloads the view
    [parent addSubview:self.view]; //reloads the view from the nib
    
    
    //replay
    [self.view.layer addSublayer:self.animationLayer];
    //[self setupDrawingLayer];
    //[self startAnimation];
    
    //if (self.storedPath.firstObject)
    //{
    /*if (self.pathLayer != nil) {
        [self.penLayer removeFromSuperlayer];
        [self.pathLayer removeFromSuperlayer];
        self.pathLayer = nil;
        self.penLayer = nil;
    }*/
    /* NOTHING WAS STORED IN STOREDPATH */
    for (UIView * subView in self.storedPath){
        [self.view addSubview:subView];
    }
    for (SmoothLineView* storedLineView in self.storedPath)
        {
            double delayInSeconds = 2.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                NSLog(@"Do some work");
            });
            CGRect pathRect = CGRectInset(self.animationLayer.bounds, 100.0f, 100.0f);
            
            
            UIBezierPath *path = [UIBezierPath bezierPath];
            
            //[path addLineToPoint:(CGPoint)]
            //[SmoothLineView getPath: storedLineView]];//[UIBezierPath bezierPath];
            //Just to Point
            CAShapeLayer *pathLayer = [CAShapeLayer layer]; //initialize path layer
            pathLayer.frame = self.animationLayer.bounds;
            pathLayer.bounds = pathRect;
            pathLayer.geometryFlipped = YES;
            pathLayer.path = path.CGPath;
            pathLayer.strokeColor = [[UIColor blackColor] CGColor];
            pathLayer.fillColor = nil;
            pathLayer.lineWidth = 10.0f;
            pathLayer.lineJoin = kCALineJoinBevel;
            
            [self.animationLayer addSublayer:pathLayer];
            
            self.pathLayer = pathLayer;
            
            UIImage *penImage = [UIImage imageNamed:@"noun_project_347_2.png"];
            CALayer *penLayer = [CALayer layer];
            penLayer.contents = (id)penImage.CGImage;
            penLayer.anchorPoint = CGPointZero;
            penLayer.frame = CGRectMake(0.0f, 0.0f, penImage.size.width, penImage.size.height);
            [pathLayer addSublayer:penLayer];
            
            self.penLayer = penLayer;
            [self startAnimation];
        }
    //}
    
}


- (void) startAnimation
{
    [self.pathLayer removeAllAnimations];
    [self.penLayer removeAllAnimations];
    
    self.penLayer.hidden = NO;
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 5.0;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [self.pathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
    
    CAKeyframeAnimation *penAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    penAnimation.duration = 5.0;
    penAnimation.path = self.pathLayer.path;
    penAnimation.calculationMode = kCAAnimationPaced;
    penAnimation.delegate = self;
    [self.penLayer addAnimation:penAnimation forKey:@"position"];
}


- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    self.penLayer.hidden = YES;
}


- (void) setupDrawingLayer
{
    if (self.pathLayer != nil) {
        [self.penLayer removeFromSuperlayer];
        [self.pathLayer removeFromSuperlayer];
        self.pathLayer = nil;
        self.penLayer = nil;
    }
    
    CGRect pathRect = CGRectInset(self.animationLayer.bounds, 100.0f, 100.0f);
    CGPoint bottomLeft 	= CGPointMake(CGRectGetMinX(pathRect), CGRectGetMinY(pathRect));
    CGPoint topLeft		= CGPointMake(CGRectGetMinX(pathRect), CGRectGetMinY(pathRect) + CGRectGetHeight(pathRect) * 2.0f/3.0f);
    CGPoint bottomRight = CGPointMake(CGRectGetMaxX(pathRect), CGRectGetMinY(pathRect));
    CGPoint topRight	= CGPointMake(CGRectGetMaxX(pathRect), CGRectGetMinY(pathRect) + CGRectGetHeight(pathRect) * 2.0f/3.0f);
    CGPoint roofTip		= CGPointMake(CGRectGetMidX(pathRect), CGRectGetMaxY(pathRect));
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:bottomLeft];
    [path addLineToPoint:topLeft];
    [path addLineToPoint:roofTip];
    [path addLineToPoint:topRight];
    [path addLineToPoint:topLeft];
    [path addLineToPoint:bottomRight];
    [path addLineToPoint:topRight];
    [path addLineToPoint:bottomLeft];
    [path addLineToPoint:bottomRight];
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer]; //initialize path layer
    pathLayer.frame = self.animationLayer.bounds;
    pathLayer.bounds = pathRect;
    pathLayer.geometryFlipped = YES;
    pathLayer.path = path.CGPath;
    pathLayer.strokeColor = [[UIColor blackColor] CGColor];
    pathLayer.fillColor = nil;
    pathLayer.lineWidth = 10.0f;
    pathLayer.lineJoin = kCALineJoinBevel;
    
    [self.animationLayer addSublayer:pathLayer];
    
    self.pathLayer = pathLayer;
    
    UIImage *penImage = [UIImage imageNamed:@"noun_project_347_2.png"];
    CALayer *penLayer = [CALayer layer];
    penLayer.contents = (id)penImage.CGImage;
    penLayer.anchorPoint = CGPointZero;
    penLayer.frame = CGRectMake(0.0f, 0.0f, penImage.size.width, penImage.size.height);
    [pathLayer addSublayer:penLayer];
    
    self.penLayer = penLayer;
}



-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
  //END OF added stuff
    [self.canvas clear];
}
@end


