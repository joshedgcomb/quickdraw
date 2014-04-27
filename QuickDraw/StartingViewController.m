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

@interface StartingViewController ()

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
	// Do any additional setup after loading the view.
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
        NSLog(@"PLAYER NAME: %@",nameTextBox.text);
        if ([nameTextBox.text isEqualToString:@""]) {
            controller.highScoreName = @"Player";
                    NSLog(@"PASSED NAME: %@",controller.highScoreName);
        }
    }
    else if ([segue.identifier isEqualToString:@"freeDraw"]) {
        GameViewController *controller = [segue destinationViewController];
    }
}

@end
