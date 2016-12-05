//
//  ReviewRecentRecordsViewController.h
//  LineChart_4
//
//  Created by mike yang on 11/23/13.
//  Copyright (c) 2013 mike yang. All rights reserved.
//  Reference for using core-plot: http://www.springtiger.co.uk/2010/10/03/using-core-plot-to-draw-line-graphs/
//  Reference for adding pinch, rotate and pan gesture to view:
//  http://cs354dory.wordpress.com/code-examples/pinch-pan-and-rotate/ and
//  http://stackoverflow.com/questions/3907397/gesturerecognizer-on-uiimageview


#import "CorePlot-CocoaTouch.h"
#import "MyPoint.h"
#import <CoreData/CoreData.h>
#import "CaloryTrack.h"
#import "AppDelegate.h"
// This is for our Social (Twitter) integration
#import <Social/Social.h>

@interface ReviewRecentRecordsViewController : UIViewController <CPTPlotDataSource>

@property(nonatomic) CPTXYGraph *graph;
@property(nonatomic) NSArray *points;
@property(nonatomic, assign) int numberOfPoints;
@property(nonatomic, assign) int intYNumberOfCharacters;
@property (weak, nonatomic) IBOutlet UILabel *todayCaloryBurnLabel;
- (IBAction)postTweet:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet CPTGraphHostingView *myGraphview;
@end
