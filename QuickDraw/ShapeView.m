//
//  ShapeView.m
//  QuickDraw
//
//  Created by jarthurcs on 4/14/14.
//  Copyright (c) 2014 jverticchio. All rights reserved.
//

#import "ShapeView.h"

@implementation ShapeView


- (id)initWithFrame:(CGRect)frame shape:(int)shape;
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        currentShapeType = shape;
    }
    [self.superview bringSubviewToFront:self];
    return self;
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    switch (currentShapeType) {
        case triangleShape:
            [self drawTriange];
            break;
        case rectangleShape:
            [self drawRectangle];
            break;
        case circleShape:
            [self drawCircle];
            break;
        /*case tShape:
            [self drawT];
            break;*/
        default:
            break;
    }
}

- (void)drawTriange
{
    //1
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //2
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, 34.0, 700);
    CGContextAddLineToPoint(ctx, 700.0, 700.0);
    CGContextAddLineToPoint(ctx, 384.0f, 100.0f);
    CGContextSetLineWidth(ctx, 5);
    CGContextSetStrokeColorWithColor(ctx, [[UIColor colorWithRed:153/255.0 green:255/255.0 blue:153/255.0 alpha:1.0] CGColor]);
    //CGContextSetFillColorWithColor(ctx, [[UIColor clearColor] CGColor]);
    
    
    //3
    CGContextClosePath(ctx);
    CGContextStrokePath(ctx);
}

- (void)drawT
{
    //1
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //2
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, 50.0, 20.0);
    CGContextAddLineToPoint(ctx, 200.0, 20.0);
    CGContextMoveToPoint(ctx, 125.0, 20.0);
    CGContextAddLineToPoint(ctx, 125.0f, 220.0f);
    CGContextSetLineWidth(ctx, 3);
    
    //3
    CGContextClosePath(ctx);
    CGContextStrokePath(ctx);
}

- (void)drawRectangle
{
    CGPoint center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
    float rectangleWidth = 400.0;
    float rectangleHeight = 400.0;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //4
    CGContextAddRect(ctx, CGRectMake(center.x - (0.5 * rectangleWidth), center.y - (0.5 * rectangleHeight), rectangleWidth, rectangleHeight));
    CGContextSetLineWidth(ctx, 5);
    CGContextSetStrokeColorWithColor(ctx, [[UIColor colorWithRed:51/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] CGColor]);
    CGContextStrokePath(ctx);
    
    //5
    //CGContextSetFillColorWithColor(ctx, [[UIColor greenColor] CGColor]);
    //CGContextAddRect(ctx, CGRectMake(center.x - (0.5 * rectangleWidth), center.y - (0.5 * rectangleHeight), rectangleWidth, rectangleHeight));
    //CGContextFillPath(ctx);
}

- (void)drawCircle
{
    CGPoint center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 5);
    CGContextSetStrokeColorWithColor(ctx, [[UIColor colorWithRed:255/255.0 green:153/255.0 blue:255/255.0 alpha:1.0] CGColor]);
    CGContextBeginPath(ctx);
    
    //6 CGContextSetLineWidth(ctx, 5);
    CGContextAddArc(ctx, center.x, center.y, 300.0, 0, 2*M_PI, 0);
    CGContextStrokePath(ctx); 
}

@end
