//
//  OvalProcessView.m
//  circleProcessView
//
//  Created by mike yang on 11/20/13.
//  Copyright (c) 2013 mike yang. All rights reserved.
//

#import "OvalProcessView.h"
@interface OvalProcessView ()

//@property (nonatomic) NSTimer *timer;
@property (nonatomic) float currentDis;
@property (assign, nonatomic) float progress;
//@property (assign, nonatomic) CGFloat angle;//angle between two lines

@end

@implementation OvalProcessView

- (id)initWithFrame:(CGRect)frame
          backColor:(UIColor *)backColor
      progressColor:(UIColor *)progressColor
          lineWidth:(CGFloat)lineWidth
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        _backColor = backColor;
        _progressColor = progressColor;
        _lineWidth = lineWidth;
        _currentDis = 0;


    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    // =====================================================================
    // Draw background running field path
    CGFloat boundWidth = self.bounds.size.width;
    CGFloat boundHeight = self.bounds.size.height;
    CGFloat lengthOfStraightLine = boundWidth / 2;
    CGFloat radius = lengthOfStraightLine / M_PI;
    //CGPoint center = CGPointMake(boundWidth / 2.0 , boundHeight / 2.0);

    // =====================================================================
    // Caculate four points for two straight lines
    CGPoint point1 = CGPointMake(boundWidth / 4.0 , boundHeight / 4.0);
    CGPoint point2 = CGPointMake(point1.x + lengthOfStraightLine , point1.y);
    CGPoint point3 = CGPointMake(point2.x , point2.y + 2 * radius);
    CGPoint point4 = CGPointMake(point3.x - lengthOfStraightLine , point3.y);
    //NSLog(@"current bounds is: x = %f, y= %f",boundWidth,boundHeight);

    UIBezierPath *backgroundFieldPath = [UIBezierPath bezierPath];

    // =====================================================================
    // Add first straight line to path
    [backgroundFieldPath moveToPoint:point1];
    [backgroundFieldPath addLineToPoint:point2];
    // =====================================================================
    // Add first corner to path
    [backgroundFieldPath addArcWithCenter:CGPointMake(point2.x, point2.y + radius)
                         radius:radius
                     startAngle:(CGFloat) - M_PI_2
                       endAngle:(CGFloat) M_PI_2
                      clockwise:YES];
    // =====================================================================
    // Add second straight line to path
    [backgroundFieldPath moveToPoint:point3];
    [backgroundFieldPath addLineToPoint:point4];
    // =====================================================================
    // Add second corner to path
    [backgroundFieldPath addArcWithCenter:CGPointMake(point1.x, point1.y + radius)
                         radius:radius
                     startAngle:(CGFloat) M_PI_2
                       endAngle:(CGFloat) - M_PI_2
                      clockwise:YES];

    [self.backColor setStroke];
    backgroundFieldPath.lineWidth = self.lineWidth;
    [backgroundFieldPath stroke];



    // =====================================================================
    // Draw progress path
    CGPoint startPoint = CGPointMake(point1.x + lengthOfStraightLine / 2.0 , point1.y);
    UIBezierPath *processFieldPath = [UIBezierPath bezierPath];
    if (self.progress < 0.125) {
        // =====================================================================
        // Draw pertentage of first part
        float percentage = self.progress / 0.125;
        [processFieldPath moveToPoint:startPoint];
        [processFieldPath addLineToPoint:
         CGPointMake(startPoint.x + (lengthOfStraightLine/2.0 * percentage), startPoint.y)];
    }
    else if (self.progress < 0.375) {
        // =====================================================================
        // Draw of first part
        [processFieldPath moveToPoint:startPoint];
        [processFieldPath addLineToPoint:point2];

        // =====================================================================
        // Draw pertentage of second part
        float percentage = (self.progress - 0.125) / 0.25;
        [processFieldPath addArcWithCenter:CGPointMake(point2.x, point2.y + radius)
                                       radius:radius
                                   startAngle:(CGFloat) - M_PI_2
                                     endAngle:(CGFloat)(- M_PI_2 + percentage * M_PI)
                                    clockwise:YES];
    }
    else if (self.progress < 0.625) {
        // =====================================================================
        // Draw of first two parts
        [processFieldPath moveToPoint:startPoint];
        [processFieldPath addLineToPoint:point2];
        [processFieldPath addArcWithCenter:CGPointMake(point2.x, point2.y + radius)
                                    radius:radius
                                startAngle:(CGFloat) - M_PI_2
                                  endAngle:(CGFloat) M_PI_2
                                 clockwise:YES];
        // =====================================================================
        // Draw pertentage of third part
        float percentage = (self.progress - 0.375) / 0.25;
        [processFieldPath moveToPoint:point3];
        [processFieldPath addLineToPoint:
         CGPointMake(point3.x - (lengthOfStraightLine * percentage), point3.y)];
    }
    else if (self.progress < 0.875){
        // =====================================================================
        // Draw of first three parts
        [processFieldPath moveToPoint:startPoint];
        [processFieldPath addLineToPoint:point2];
        [processFieldPath addArcWithCenter:CGPointMake(point2.x, point2.y + radius)
                                    radius:radius
                                startAngle:(CGFloat) - M_PI_2
                                  endAngle:(CGFloat) M_PI_2
                                 clockwise:YES];
        [processFieldPath moveToPoint:point3];
        [processFieldPath addLineToPoint:point4];
        // =====================================================================
        // Draw pertentage of fourth part
        float percentage = (self.progress - 0.625) / 0.25;
        [processFieldPath addArcWithCenter:CGPointMake(point1.x, point1.y + radius)
                                       radius:radius
                                   startAngle:(CGFloat) M_PI_2
                                     endAngle:(CGFloat) (M_PI_2 + percentage * M_PI)
                                    clockwise:YES];
    }
    else{
        // =====================================================================
        // Draw of first fourth parts
        [processFieldPath moveToPoint:startPoint];
        [processFieldPath addLineToPoint:point2];
        [processFieldPath addArcWithCenter:CGPointMake(point2.x, point2.y + radius)
                                    radius:radius
                                startAngle:(CGFloat) - M_PI_2
                                  endAngle:(CGFloat) M_PI_2
                                 clockwise:YES];
        [processFieldPath moveToPoint:point3];
        [processFieldPath addLineToPoint:point4];
        [processFieldPath addArcWithCenter:CGPointMake(point1.x, point1.y + radius)
                                    radius:radius
                                startAngle:(CGFloat) M_PI_2
                                  endAngle:(CGFloat) -M_PI_2
                                 clockwise:YES];
        // =====================================================================
        // Draw of last part

        float percentage = (self.progress - 0.875) / 0.125;
        [processFieldPath moveToPoint:point1];
        [processFieldPath addLineToPoint:CGPointMake(point1.x + lengthOfStraightLine/2.0 * percentage, point1.y)];

    }
    [self.progressColor setStroke];
    processFieldPath.lineWidth = self.lineWidth;
    [processFieldPath stroke];

    // =====================================================================
    // Draw a end point(a group of rectangles)
    CGPoint endPoint = CGPointMake(point1.x + lengthOfStraightLine / 4.0, point1.y - self.lineWidth / 2.0);
    for (int k = 0; k < 5; k++) {
        int length = self.lineWidth / 5.0;
        for (int j = 0; j < 3; j++) {
            CGRect rect = CGRectMake (endPoint.x + j*length, endPoint.y + k*length,
                                      length,
                                      length);
            if ((k * 3 + j)%2 == 0)
                [[UIColor blackColor] setFill];
            else
                [[UIColor whiteColor] setFill];

            UIRectFill(rect);
        }
    }
}
- (void)updateProgressCircle:(float) distance{
    // =========================================================
    //update progress value
    self.progress = distance / 400;
    if (_currentDis >= 400) {
        _currentDis = 0;
    }
    // =========================================================
    //redraw back & progress circles
    [self setNeedsDisplay];
}
@end
