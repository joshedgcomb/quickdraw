//
//  ViewController.m
//  WTMGlyphDemo
//
//  Created by Torin Nguyen on 5/7/12.
//  Copyright (c) 2012 torin.nguyen@2359media.com. All rights reserved.
//

#define GESTURE_SCORE_THRESHOLD         3

#import "GlyphViewController.h"
#import "WTMGlyphDetectorView.h"

@interface GlyphViewController ()
@property (nonatomic, strong) WTMGlyphDetectorView *gestureDetectorView;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (nonatomic, strong) IBOutlet UILabel *lblStatus;
@end

@implementation GlyphViewController
@synthesize gestureDetectorView;
@synthesize lblStatus;

- (void)viewDidLoad
{
  [super viewDidLoad];
    
    self->name = @"";
    gameOver = FALSE;
    
    statusString = @"";
    [self.view bringSubviewToFront:self.nextRound];
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.nextRound.hidden = TRUE;
        [self drawNext];
        self.gestureDetectorView = [[WTMGlyphDetectorView alloc] initWithFrame: CGRectMake(0, 100, 768, 850)];
        self.gestureDetectorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.gestureDetectorView.delegate = self;
        [self.gestureDetectorView loadTemplatesWithNames:@"circle", @"square", @"triangle", nil];
        [self.view addSubview:self.gestureDetectorView];
        [self.view bringSubviewToFront:self.gestureDetectorView];
        
        self->timer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                                       target:self selector:@selector(onTick)
                                                     userInfo:NULL repeats:YES];
        self.timerBar.progress = 0;
        self->startTime = [NSDate timeIntervalSinceReferenceDate];
    });
    
    
    drawCount = 0;
    totalScore = 0;
    
    /*
     ShapeView *shape1 = [[ShapeView alloc] initWithFrame: CGRectMake(20, 100, 280, 250) shape:0];
    shape1.backgroundColor = [UIColor grayColor];
    [self.view addSubview:shape1];
    
    ShapeView *shape2 = [[ShapeView alloc] initWithFrame: CGRectMake(450, 100, 280, 250) shape:1];
    shape2.backgroundColor = [UIColor grayColor];
    [self.view addSubview:shape2];
    
    ShapeView *shape3 = [[ShapeView alloc] initWithFrame: CGRectMake(20, 700, 280, 250) shape:2];
    shape3.backgroundColor = [UIColor grayColor];
    [self.view addSubview:shape3];
    
    ShapeView *shape4 = [[ShapeView alloc] initWithFrame: CGRectMake(450, 700, 280, 250) shape:3];
    shape4.backgroundColor = [UIColor grayColor];
    [self.view addSubview:shape4];
    */

}

-(void) drawNext{
    [self->shape removeFromSuperview];
    self->shape = [[ShapeView alloc] initWithFrame: CGRectMake(0, 100, 768, 850) shape:(drawCount%3)];
    [self.view bringSubviewToFront:self->shape];
    shape.backgroundColor = [UIColor colorWithWhite:0.15 alpha:1.0];
    [self.view addSubview:shape];
    //[self.view sendSubviewToBack:shape];
    
    // Change button color to match shape color
    UIColor *currentColor;
    if (drawCount%3 ==0)    {
        currentColor = [UIColor colorWithRed:153/255.0 green:255/255.0 blue:153/255.0 alpha:1.0];
        [self.nextButton setTitleColor:currentColor forState:UIControlStateNormal];
        self.timerBar.progressTintColor = currentColor;
        
    }
    else if (drawCount %3 ==1) {
        currentColor = [UIColor colorWithRed:51/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        [self.nextButton setTitleColor:currentColor forState:UIControlStateNormal];
        self.timerBar.progressTintColor = currentColor;
    }
    else    {
        currentColor = [UIColor colorWithRed:255/255.0 green:153/255.0 blue:255/255.0 alpha:1.0];
        [self.nextButton setTitleColor:currentColor forState:UIControlStateNormal];
        self.timerBar.progressTintColor = currentColor;
        
    }
    drawCount++;
    [self.view bringSubviewToFront:self.gestureDetectorView];

}

- (void) onTick {
    if (gameOver) {
        return;
    }
    double currentTime = [NSDate timeIntervalSinceReferenceDate];

    
    self.timerBar.progress = 1 - (currentTime - startTime)/3.75;
    self->lastTime = currentTime;
    NSLog(@"progress: %f", self.timerBar.progress);
    if (self.timerBar.progress == 0) {
      //      NSLog(@"PPROGRESS: %f", self.timerBar.progress);
        self->startTime = [NSDate timeIntervalSinceReferenceDate];
        self.timerBar.progress = 1;
        
        if (drawCount <= 5){
            self.nextRound.hidden = FALSE;
            self.nextRound.text = [NSString stringWithFormat:(@"Score: 0")];
            [self.view bringSubviewToFront:self.nextRound];
            tempScore = 0;
            
            double delayInSeconds = 2.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                self.nextRound.hidden = TRUE;
                [self drawNext];
                totalScore = totalScore +tempScore;
                self.timerBar.progress = 1;
                self->startTime = [NSDate timeIntervalSinceReferenceDate];
            });
            
            
        }
        else{
            gameOver =TRUE;
            [self performSegueWithIdentifier:@"toScores" sender:self];
        }
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  NSString *glyphNames = [self.gestureDetectorView getGlyphNamesString];
  if ([glyphNames length] > 0) {
    NSString *statusText = [NSString stringWithFormat:@"Start Drawing!", [self.gestureDetectorView getGlyphNamesString]];
      self.lblStatus.text = statusText;
  }
}

- (void)viewDidUnload
{
  [self.gestureDetectorView removeFromSuperview];
  self.gestureDetectorView.delegate = nil;
  self.gestureDetectorView = nil;
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return YES;
}


#pragma mark - Delegate

- (void)wtmGlyphDetectorView:(WTMGlyphDetectorView*)theView glyphDetected:(WTMGlyph *)glyph withScore:(float)score
{
  //Reject detection when quality too low
  //More info: http://britg.com/2011/07/17/complex-gesture-recognition-understanding-the-score/
  if (score < GESTURE_SCORE_THRESHOLD)
    return;
  
 statusString = @"";
  
    
  //NSString *glyphNames = [self.gestureDetectorView getGlyphNamesString];
  //if ([glyphNames length] > 0)
    //statusString = [statusString stringByAppendingFormat:@"Loaded with %@ templates.\n\n", glyphNames];
    //NSLog(@"glyph: %@\n count %i", glyph.name,drawCount);
  if(([glyph.name isEqualToString:@"triangle"] && drawCount%3 == 1) ||
    ([glyph.name isEqualToString:@"square"] && drawCount%3 == 2) ||
     ([glyph.name isEqualToString:@"circle"] && drawCount%3 == 0)){
      statusString = [statusString stringByAppendingFormat:@"%@ Score: %d", [glyph.name capitalizedString], (int)(score*self.timerBar.progress*100)];
    
    tempScore = (int)(100*score*self.timerBar.progress);
    //NSLog(@"total: %i",totalScore);
      //self.lblStatus.text = statusString;
    
      
      if (drawCount <= 5){
          self.nextRound.hidden = FALSE;
          self.nextRound.text = [NSString stringWithFormat:(@"%@", statusString)];
          [self.view bringSubviewToFront:self.nextRound];
          self.timerBar.progress = 1;
          self->startTime = [NSDate timeIntervalSinceReferenceDate];
          
          double delayInSeconds = 2.0;
          dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
          dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
              self.nextRound.hidden = TRUE;
              [self drawNext];
              totalScore = totalScore +tempScore;
              self.timerBar.progress = 1;
              self->startTime = [NSDate timeIntervalSinceReferenceDate];

          });
          
          
      }
      else{
          [self performSegueWithIdentifier:@"toScores" sender:self];
      }
      
      
  }

}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    PFObject *highScore = [PFObject objectWithClassName:@"NewScore"];
    NSNumber *score = [NSNumber numberWithInt:totalScore];
    highScore[@"name"] = self.highScoreName;
    highScore[@"score"] = score;
    [highScore save];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over!" message:[NSString stringWithFormat:@"Congratulations %@! You scored %d points!", self.highScoreName, totalScore] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
    
}

/*- (IBAction)donePressed:(id)sender {
    if (drawCount <= 5){
        self.nextRound.hidden = FALSE;
        self.nextRound.text = [NSString stringWithFormat:(@"%@", statusString)];
        [self.view bringSubviewToFront:self.nextRound];
        
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            self.nextRound.hidden = TRUE;
            [self drawNext];
            totalScore = totalScore +tempScore;
            self.timerBar.progress = 0;
            self->startTime = [NSDate timeIntervalSinceReferenceDate];
        });
        
        
    }
    else{
        [self performSegueWithIdentifier:@"toScores" sender:sender];
    }
}*/
@end
