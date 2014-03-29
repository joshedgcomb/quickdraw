//
//  GameViewController.m
//  QuickDraw
//
//  Created by jarthurcs on 2/24/14.
//  Copyright (c) 2014 jverticchio. All rights reserved.
//

#import "GameViewController.h"
//Added stuff below
#import "Smooth_Line_ViewViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface GameViewController ()

//From original smoothlineviewvc
@property (nonatomic) SmoothLineView * canvas;
@property (atomic) NSMutableArray *storedPath;
@property (strong, nonatomic) IBOutlet UIButton *clearAndReplay;
//@property (unsafe_unretained, nonatomic) IBOutlet UIButton *clearEverything;


//Added stuff below:

@property (nonatomic, retain) CALayer *animationLayer;
@property (nonatomic, retain) CAShapeLayer *pathLayer;
@property (nonatomic, retain) CALayer *penLayer;
//end of added stuff


- (IBAction)replay:(id)sender;


@end

@implementation GameViewController

- (void)viewDidLoad
{
    red = 0.0/255.0;
    green = 0.0/255.0;
    blue = 0.0/255.0;
    brush = 10.0;
    opacity = 1.0;
    
    //Smoothline View
    //SmoothLineView * smoothLineView =[[SmoothLineView alloc] initWithFrame:self.view.frame ];
    CGRect  viewRect = CGRectMake(0, 150, 770, 800);
    SmoothLineView * smoothLineView =[[SmoothLineView alloc] initWithFrame:viewRect ];
    smoothLineView.backgroundColor = [UIColor colorWithWhite:0.8000 alpha:0.2];
    smoothLineView.tag = 3;
    self.canvas = smoothLineView;
    [self.view addSubview:smoothLineView];
    // [self.storedPath addObject:[SmoothLineView copyLineView:smoothLineView]];
    
    //[smoothLineView storePath:(id)self.storedPath];
   /*
    self.animationLayer = [CALayer layer];
    self.animationLayer.frame = CGRectMake(20.0f, 64.0f,
                                           CGRectGetWidth(self.view.layer.bounds) - 40.0f,
                                           CGRectGetHeight(self.view.layer.bounds) - 84.0f);
    [self.view addSubview:self.clearAndReplay];
    //[self.view addSubview:self.clearEverything];
    */
    [super viewDidLoad];

}
/* Button action for clear & replay */
- (IBAction)replay:(UIButton *)sender {
    //clear
    [self.canvas clear];
    //replay
    [self startAnimation];
    [self viewDidLoad];
}
/* Animation things */
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

/*Drawings */

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
/* end of smoothline drawing stuff */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    mouseSwiped = NO;
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:self.view];
}
/*
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    mouseSwiped = YES;
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [self->tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush );
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self->tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    [self->tempDrawImage setAlpha:opacity];
    UIGraphicsEndImageContext();
    
    lastPoint = currentPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(!mouseSwiped) {
        UIGraphicsBeginImageContext(self.view.frame.size);
        [self->tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, opacity);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        self->tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    UIGraphicsBeginImageContext(self->mainImage.frame.size);
    [self->mainImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    [self->tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:opacity];
    self->mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
    self->tempDrawImage.image = nil;
    UIGraphicsEndImageContext();
}
*/

- (IBAction)reset:(id)sender {
    
    //self->mainImage.image = nil;//old code
    
    
    //clear for smoothlineview
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

//- (IBAction)done:(id)sender {
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    int num = arc4random() % 100;
    NSNumber *score = [NSNumber numberWithInt:num];
    NSString *name = [NSString stringWithFormat:@"John"];
    
    
    NSData *img = [NSData dataWithData:UIImagePNGRepresentation(self->mainImage.image)];
    
    
    [Database saveDrawingWithImage:img];
    //Do something here with the drawings
    //NSMutableArray *drawings = [Database fetchAllDrawings];
    /*for (Drawing *temp in drawings){
      //  NSLog(@"From DB: %d", temp.rowid);
    }*/ //Suspected debugging code

    
    PFObject *highScore = [PFObject objectWithClassName:@"NewScore"];
    highScore[@"name"] = name;
    highScore[@"score"] = score;
    [highScore saveInBackground];
    

}


/*
- (IBAction)replay:(id)sender {
}*/
@end
