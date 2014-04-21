//
//  StartingViewController.m
//  QuickDraw
//
//  Created by jarthurcs on 4/15/14.
//  Copyright (c) 2014 jverticchio. All rights reserved.
//

#import "StartingViewController.h"
#import "GameViewController.h"

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender    {
    if ([segue.identifier isEqualToString:@"startToDrawSegue"])  {
        GameViewController *controller = [segue destinationViewController];
        controller.highScoreName = nameTextBox.text;
        controller.mode = 0;
    }
    else if ([segue.identifier isEqualToString:@"freeDrawSegue"]) {
        GameViewController *controller = [segue destinationViewController];
        controller.mode = 1;
    }
}

@end
