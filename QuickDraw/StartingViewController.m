//
//  StartingViewController.m
//  QuickDraw
//
//  Created by jarthurcs on 4/15/14.
//  Copyright (c) 2014 jverticchio. All rights reserved.
//

#import "StartingViewController.h"
#import "GameViewController.h"
#import "GlyphViewController.h"
#import "AppDelegate.h"

@interface StartingViewController ()

@property AppDelegate *myDelegate;

@end

@implementation StartingViewController  {
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    nameTextBox.delegate = self;
    self.muteBool = false;
	// Do any additional setup after loading the view.
    self.myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField{
    [textField resignFirstResponder];
    return NO;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender    {
    if ([segue.identifier isEqualToString:@"startGame"])  {
        GlyphViewController *controller = [segue destinationViewController];
        controller.highScoreName = nameTextBox.text;
        //NSLog(@"PLAYER NAME: %@",nameTextBox.text);
        if ([nameTextBox.text isEqualToString:@""]) {
            controller.highScoreName = @"Player";
          //          NSLog(@"PASSED NAME: %@",controller.highScoreName);
        }
    }
}
- (IBAction)muteButtonPressed:(id)sender {
    if (self.muteBool == false)  {
        UIImage *theImage = [UIImage imageNamed:@"mute-64.png"];
        [sender setImage:theImage forState:UIControlStateNormal];
        self.muteBool = true;
        [self.myDelegate.myAudioPlayer setVolume:0.0];
        
    }
    else    {
        UIImage *theImage = [UIImage imageNamed:@"volume-up-64.png"];
        [sender setImage:theImage forState:UIControlStateNormal];
        self.muteBool = false;
        [self.myDelegate.myAudioPlayer setVolume:1.0];
    }
}

@end
