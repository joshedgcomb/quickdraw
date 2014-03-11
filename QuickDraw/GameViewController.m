//
//  GameViewController.m
//  QuickDraw
//
//  Created by jarthurcs on 2/24/14.
//  Copyright (c) 2014 jverticchio. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController ()

@end

@implementation GameViewController

- (void)viewDidLoad
{
    red = 0.0/255.0;
    green = 0.0/255.0;
    blue = 0.0/255.0;
    brush = 10.0;
    opacity = 1.0;
    
    [super viewDidLoad];
}

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

- (IBAction)reset:(id)sender {
    
    self->mainImage.image = nil;
    
}

//- (IBAction)done:(id)sender {
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    int num = arc4random() % 100;
    NSNumber *score = [NSNumber numberWithInt:num];
    NSString *name = [NSString stringWithFormat:@"John"];
    
    NSData *img = [NSData dataWithData:UIImagePNGRepresentation(self->mainImage.image)];
    
    [Database saveDrawingWithImage:img];
    NSMutableArray *drawings = [Database fetchAllDrawings];
    for (Drawing *temp in drawings){
      //  NSLog(@"From DB: %d", temp.rowid);
    }

    
    PFObject *highScore = [PFObject objectWithClassName:@"NewScore"];
    highScore[@"name"] = name;
    highScore[@"score"] = score;
    [highScore saveInBackground];
    
    PFQuery *query = [[PFQuery alloc] initWithClassName:@"NewScore"];
    query.limit = 10;
    [query orderByDescending:@"score"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved %d scores.", objects.count);
            for (PFObject *object in objects) {
                NSLog(@"from Parse: %@", object);
            }
        }
        else {
            NSLog(@"Error: %@", error);
        }
    }];
}



@end
