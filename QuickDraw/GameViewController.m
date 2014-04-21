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
@property (weak, nonatomic) IBOutlet UILabel *timerDisplay;
@property (weak, nonatomic) IBOutlet UIProgressView *timerBar;


//Added stuff below:

@property (nonatomic, retain) CALayer *animationLayer;
@property (nonatomic, retain) CAShapeLayer *pathLayer;
@property (nonatomic, retain) CALayer *penLayer;
//end of added stuff

- (IBAction)replay:(id)sender;


@end

@implementation GameViewController{
    bool timerRunning;
    BOOL showingSettings;
    UIView *settingsView;
    __weak IBOutlet UIBarButtonItem *settingsButton;
    
    UILabel *redLabel;
    UISlider *redSlider;
    UILabel *blueLabel;
    UISlider *blueSlider;
    UILabel *greenLabel;
    UISlider *greenSlider;
}

- (IBAction)callToggleSettingsView:(id)sender {
    [self toggleSettingsView];
}

-(void)toggleSettingsView{
    [self.view bringSubviewToFront:settingsView];
    CGRect frame = settingsView.frame;
    if(showingSettings){
        settingsButton.title = @"Settings";
        frame.origin.y = self.view.frame.size.height;
    }else{
        settingsButton.title = @"Close";
        frame.origin.y = 44;
    }
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        settingsView.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
    
    showingSettings = !showingSettings;
}


- (void)viewDidLoad
{
    
    // hides the progress bar if in free draw mode. slightly hacky, but
    // it works
    if (self.mode == 1)  {
        [self.timerBar setHidden:true];
    }
    [self.timerDisplay setHidden:true];
    self->timer = [NSTimer scheduledTimerWithTimeInterval:0.05
                   target:self selector:@selector(onTick)
                   userInfo:NULL repeats:YES];
    self.timerBar.progress = 0;
    self->startTime = [NSDate timeIntervalSinceReferenceDate];
    //int seconds = [NSDate timeIntervalSinceReferenceDate] - startTime;
    //self.timerDisplay.text = [NSString stringWithFormat:@"%u", seconds];
    
    red = 0.0/255.0;
    green = 0.0/255.0;
    blue = 0.0/255.0;
    brush = 10.0;
    opacity = 1.0;
    
    //Smoothline View
    
    //SmoothLineView * smoothLineView =[[SmoothLineView alloc] initWithFrame:self.view.frame ];
    CGRect  viewRect = CGRectMake(0, 150, 770, 800);
    SmoothLineView * smoothLineView =[[SmoothLineView alloc] initWithFrame:viewRect];
    smoothLineView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.0];
    smoothLineView.tag = 3;
    self.canvas = smoothLineView;
    
    
    
    settingsView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-44)];
    [settingsView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.6]];
    [self.view addSubview:settingsView];
    [self buildSettings];
    
    

    CGFloat cell_width = 240;
    CGFloat cell_height = 100;
    [redLabel setText:[NSString stringWithFormat:@"Red: %i", (int)red]];
    [blueLabel setText:[NSString stringWithFormat:@"Blue: %i", (int) blue]];
    [greenLabel setText:[NSString stringWithFormat:@"X offset: %i", (int)green]];
    
    // [self.storedPath addObject:[SmoothLineView copyLineView:smoothLineView]];
    
    //[smoothLineView storePath:(id)self.storedPath];

    [self.view addSubview:smoothLineView];
    [super viewDidLoad];

}


// updates the timer on the screen
- (void) onTick {
    double currentTime = [NSDate timeIntervalSinceReferenceDate];
    int totalHundredths = (currentTime - startTime) * 100;
    int seconds = currentTime - startTime;
    int hundredths = totalHundredths%100;
    
    self.timerBar.progress = 1 - (currentTime - startTime)/10.0;
    self->lastTime = currentTime;
    
    self.timerDisplay.text = [NSString stringWithFormat:@"%u:%02u", seconds, hundredths];
}
/* Button action for clear & replay */
- (IBAction)replay:(UIButton *)sender {
    [UIView animateWithDuration:0.75 animations:^{self.canvas.alpha = 0.0;}];
    //clear
    //[self.canvas clear];
    //replay
    [UIView animateWithDuration:0.75 animations:^{self.canvas.alpha = 1.0;}];
    [self setupDrawingLayer];
    self.animationLayer = [CALayer layer];
    self.animationLayer.frame = CGRectMake(20.0f, 64.0f,
                                           CGRectGetWidth(self.view.layer.bounds) - 40.0f,
                                           CGRectGetHeight(self.view.layer.bounds) - 84.0f);
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
    pathLayer.strokeColor = [[UIColor blueColor] CGColor];
    [[UIColor blueColor] setStroke];
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

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event   {
    
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


-(void)buildSettings{
    NSArray *viewArr = [[NSBundle mainBundle] loadNibNamed:@"iphone_settings_view" owner:self options:nil];
    UIView *innerView = [viewArr objectAtIndex:0];
    CGRect frame = innerView.frame;
    frame.origin.y = (self.view.frame.size.height/2 - frame.size.height/2)/2;
    innerView.frame = frame;
    [settingsView addSubview:innerView];
    
    redLabel = (UILabel*)[innerView viewWithTag:100];
    redSlider = (UISlider*)[innerView viewWithTag:200];
    redSlider.minimumValue = 0;
    redSlider.maximumValue = 255;
    [redSlider addTarget:self action:@selector(updateSettings) forControlEvents:UIControlEventValueChanged];
    
    blueLabel = (UILabel*)[innerView viewWithTag:101];
    blueSlider = (UISlider*)[innerView viewWithTag:201];
    blueSlider.minimumValue = 0;
    blueSlider.maximumValue = 255;
    [blueSlider addTarget:self action:@selector(updateSettings) forControlEvents:UIControlEventValueChanged];
    
    greenLabel = (UILabel*)[innerView viewWithTag:102];
    greenSlider = (UISlider*)[innerView viewWithTag:202];
    greenSlider.minimumValue = 0;
    greenSlider.maximumValue = 255;
    
    [greenSlider addTarget:self action:@selector(updateSettings) forControlEvents:UIControlEventValueChanged];
    
}

-(void)updateSettings{
    red = redSlider.value;
    blue = blueSlider.value;
    green = greenSlider.value;
    
    [redLabel setText:[NSString stringWithFormat:@"Red: %i", (int)red]];
    //[dialLayout setDialRadius:radius];
    
    [blueLabel setText:[NSString stringWithFormat:@"Blue: %i", (int)blue]];
    //[dialLayout setAngularSpacing:angularSpacing];
    
    [greenLabel setText:[NSString stringWithFormat:@"Green: %i", (int)green]];
    //[dialLayout setXOffset:xOffset];
    self.pathLayer.strokeColor = [[UIColor colorWithRed:red green:green blue:blue alpha:1] CGColor];
    
    //[dialLayout invalidateLayout];
    //[collectionView reloadData];
    //NSLog(@"updateDialSettings");
}



//- (IBAction)done:(id)sender {
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    // if in time attack mode, generate and save high score
    NSLog(@"mode is %d", self.mode);
    if (self.mode == 0)   {
        PFObject *highScore = [PFObject objectWithClassName:@"NewScore"];
        int num = 23456;
        NSNumber *score = [NSNumber numberWithInt:num];
        highScore[@"name"] = self.highScoreName;
        highScore[@"score"] = score;
        [highScore save];

        
    }
    
    
    
    
    //NSData *img = [NSData dataWithData:UIImagePNGRepresentation(self->mainImage.image)];
    //Take a 'screen' shot of the drawing canvas
    UIGraphicsBeginImageContext(self.canvas.frame.size);
    [[self.canvas layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *img =[NSData dataWithData:UIImagePNGRepresentation(screenshot)];
    [Database saveDrawingWithImage:img];
    //Do something here with the drawings
    //NSMutableArray *drawings = [Database fetchAllDrawings];
    /*for (Drawing *temp in drawings){
      //  NSLog(@"From DB: %d", temp.rowid);
    }*/ //Suspected debugging code


    

}


/*
- (IBAction)replay:(id)sender {
}*/
@end
