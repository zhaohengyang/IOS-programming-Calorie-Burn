//
//  OvalProcessView.h
//  circleProcessView
//
//  Created by mike yang on 11/20/13.
//  Copyright (c) 2013 mike yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OvalProcessView : UIView
@property (nonatomic) UIColor *backColor;
@property (nonatomic) UIColor *progressColor;
@property (assign, nonatomic) CGFloat lineWidth;

- (id)initWithFrame:(CGRect)frame
          backColor:(UIColor *)backColor
      progressColor:(UIColor *)progressColor
          lineWidth:(CGFloat)lineWidth;
- (void)updateProgressCircle:(float) distance;
@end
