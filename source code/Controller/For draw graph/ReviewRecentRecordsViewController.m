//
//  ReviewRecentRecordsViewController.m
//  LineChart_4
//
//  Created by mike yang on 11/23/13.
//  Copyright (c) 2013 mike yang. All rights reserved.
//

#import "ReviewRecentRecordsViewController.h"


static int const kGraphPadding = 1.0;
static int const kSampleRate = 20;
static int const kNumberOfReadingToDisplay = 10;
static int const kPaddingForYTitle = 20;
static int const kCharacterPadding = 8;


@implementation ReviewRecentRecordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // ================================================================
    // Setup background image
    self.view.layer.contents = (id)[UIImage imageNamed:@"drawGraphBackground.jpg"].CGImage;

    // ============================================================
    // Load each point into points array
    if (self.points == nil) {
        self.points = [self loadPoints];
    }

    // ============================================================
    // Get number of points
    if (self.numberOfPoints == 0) {
        self.numberOfPoints = ([self.points count]);
    }

    // ============================================================
    // Initilize graph and place it
    self.graph = [[CPTXYGraph alloc] initWithFrame: self.view.bounds];
    [self positionGraph:self.graph];

    // ============================================================
    // Initilize host view, add this view to controller and load graph into it
    //CPTGraphHostingView *hostingView = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height - (65 + 110))];
    //[self.view addSubview:hostingView];
    //hostingView.hostedGraph = self.graph;

    self.myGraphview.hostedGraph = self.graph;

    // ============================================================
    // Apply theme to graph
    [self.graph applyTheme:[CPTTheme themeNamed:kCPTSlateTheme]];

    // ============================================================
    // Setup x,y range of the plotSpace
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.graph.defaultPlotSpace;

    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:0] length:[NSNumber numberWithFloat:[self.points count]+3]];
    // plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat([self.points count]+3)];
    NSLog(@"Top y %f",[self getYTopValueWithOffset:0]);
    NSLog(@"Top y axis %f",[self getYTopValueWithOffset:([self getYTopValueWithOffset:0]/kSampleRate)]);
    // plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat([self getYTopValueWithOffset:([self getYTopValueWithOffset:0]/kSampleRate)])];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:0] length:[NSNumber numberWithFloat:[self getYTopValueWithOffset:([self getYTopValueWithOffset:0]/kSampleRate)]]];

    // ============================================================
    // Draw label of x,y Axis of the graph
    [self configureYAxisForGraph:self.graph];
    [self configureXAxisForGraph:self.graph];


    // ============================================================
    // Setup plot
    CPTScatterPlot *plot = [[CPTScatterPlot alloc] initWithFrame:self.graph.bounds];
    plot.identifier = @"CaloriesBurnedEachDay";
    plot.dataSource = self;

    // ============================================================
    // Position plot to graph
    [self positionPlotArea:self.graph.plotAreaFrame];
    [self.graph addPlot:plot];
    [self linePropertiesForPlot:plot];

    // ============================================================
    // Update todayCaloryBurn label
    if ([self.points count] > 0) {
        MyPoint* today = [self.points lastObject];
        self.todayCaloryBurnLabel.text = [NSString stringWithFormat:@"%.1f",[today.calories floatValue]];
    }

    // =======================================================================
    // Prepare to add gesture to view
    [self.myGraphview setUserInteractionEnabled:YES];

    // create and configure the pinch gesture
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureDetected:)];
    [pinchGestureRecognizer setDelegate:self];
    [self.myGraphview addGestureRecognizer:pinchGestureRecognizer];

    // create and configure the rotation gesture
    UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationGestureDetected:)];
    [rotationGestureRecognizer setDelegate:self];
    [self.myGraphview addGestureRecognizer:rotationGestureRecognizer];

    // creat and configure the pan gesture
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureDetected:)];
    [panGestureRecognizer setDelegate:self];
    [self.myGraphview addGestureRecognizer:panGestureRecognizer];

}

- (IBAction)pinchGestureDetected:(UIPinchGestureRecognizer *)sender {
    static CGPoint center;
    static CGSize initialSize;

    if (sender.state == UIGestureRecognizerStateBegan)
        {
        center = sender.view.center;
        initialSize = sender.view.frame.size;
        }

    // scale the image
    sender.view.frame = CGRectMake(0,
                                   0,
                                   initialSize.width * sender.scale,
                                   initialSize.height * sender.scale);
    // recenter it with the new dimensions
    sender.view.center = center;
}
- (IBAction)panGestureDetected:(UIPanGestureRecognizer *)sender {
    static CGPoint initialCenter;
    if (sender.state == UIGestureRecognizerStateBegan)
        {
        initialCenter = sender.view.center;
        }
    CGPoint translation = [sender translationInView:sender.view];
    sender.view.center = CGPointMake(initialCenter.x + translation.x,
                                     initialCenter.y + translation.y);
}

- (IBAction)rotationGestureDetected:(UIRotationGestureRecognizer *)sender {
    UIGestureRecognizerState state = [sender state];

    static CGFloat initialRotation;
    if (sender.state == UIGestureRecognizerStateBegan)
        {
        initialRotation = atan2f(sender.view.transform.b, sender.view.transform.a);
        }
    CGFloat newRotation = initialRotation + sender.rotation;
    sender.view.transform = CGAffineTransformMakeRotation(newRotation);
}


/*
 @method Fills the points array with values
 */
-(NSArray*)loadPoints{
    // ============================================================
    // Open Coredata context
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"CaloryTrack" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *requestError = nil;
    NSArray *caloryTracks =
    [managedObjectContext executeFetchRequest:fetchRequest error:&requestError];

    // ============================================================
    // Load each point from coreData and return the array
    if ([caloryTracks count] > 0){
        NSMutableArray *myPoints = [[NSMutableArray alloc]init];
        // =================================================================
        // Print out each track
        NSUInteger counter = 1;
        for (CaloryTrack *thisTrack in caloryTracks){
            MyPoint* tem = [[MyPoint alloc]init];
            tem.calories = thisTrack.calories;
            tem.myDate = thisTrack.date;

            [myPoints addObject:tem];
            counter++;
        }
        return myPoints;
    }
    return nil;
}

/*
 @method sets the properties of the line
 */
-(void)linePropertiesForPlot:(CPTScatterPlot*)plot{

    CPTMutableLineStyle *lineStyle = [plot.dataLineStyle mutableCopy];
    lineStyle.lineWidth  = 2.0f;
    lineStyle.lineColor  = [CPTColor blackColor];

    CPTColor *topColour = [CPTColor colorWithComponentRed:(247.0/255.0) green:(209.0/255.0) blue:(23.0/255.0) alpha:0.85];
    CPTColor *bottomColour = [CPTColor colorWithComponentRed:(247.0/255.0) green:(209.0/255.0) blue:(23.0/255.0) alpha:0.85];

    CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:bottomColour endingColor:topColour];
    areaGradient.angle = 90.0f;
    CPTFill *areaGradientFill = [CPTFill fillWithGradient:areaGradient];
    plot.areaFill = areaGradientFill;
    // plot.areaBaseValue = CPTDecimalFromFloat([self getYBottomValueWithOffset:0]);
    plot.areaBaseValue = [NSNumber numberWithFloat:[self getYBottomValueWithOffset:0]];
}



/*
 @method returns the top value in the value array with an offset
 */
-(float)getYTopValueWithOffset:(float)offset{
    if (self.points == nil) {
        self.points = [self loadPoints];
    }

    float value = 0;

    for (int x = 0; x < self.numberOfPoints; x++) {
        float compareValue = ((MyPoint*)[self.points objectAtIndex:(x)]).getCalories.floatValue;
        value = value > compareValue ? value : compareValue;
    }
    return (value + offset);
}

/*
 @method returns the bottom value in the value array with an offset
 */
-(float)getYBottomValueWithOffset:(float)offset{
    return 0.0;
}


/*
 @method controls the position of the graph on the view
 */
-(void)positionGraph:(CPTXYGraph*)graphPosition{
    // ============================================================
    // setup graph area padding
    graphPosition.paddingBottom = kGraphPadding;
    graphPosition.paddingTop = kGraphPadding;
    graphPosition.paddingLeft = kGraphPadding;
    graphPosition.paddingRight = kGraphPadding;
}


/*
 @method controls the position of the plot with the graph
 */
-(void)positionPlotArea:(CPTPlotAreaFrame*)plotArea{
    // ============================================================
    // Setup plot area padding
    plotArea.paddingLeft = (kCharacterPadding*self.intYNumberOfCharacters) + kPaddingForYTitle;
    plotArea.paddingRight = 3;
    plotArea.paddingBottom = 80;
    plotArea.paddingTop = 25;
}


/*
 @method Sets up the X axis on a graph
 */
-(void)configureXAxisForGraph:(CPTXYGraph*)graphForAxis{
    // ============================================================
    // Setup xAxis place and style
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graphForAxis.axisSet;
    CPTXYAxis *x = axisSet.xAxis;
    x.minorTicksPerInterval = 0;
    x.labelOffset = 0.0f;
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    //set the starting position of the y-axis

    // x.orthogonalCoordinateDecimal = CPTDecimalFromFloat(0);
    x.orthogonalPosition = [NSNumber numberWithFloat:0];
    x.title = NSLocalizedString(@"DATE", @"");
    x.titleOffset = 60.0;

    // ============================================================
    // Initialize an array to setup majorTickLocations
    NSMutableArray *customTickLocations = [[NSMutableArray alloc] initWithCapacity:self.numberOfPoints];

    for (int i = 0; i < self.numberOfPoints; i++) {
        [customTickLocations addObject:[NSNumber numberWithInt:i]];
    }
    x.majorTickLocations =  [NSSet setWithArray:customTickLocations];

    // ============================================================
    // Initialize an array to setup xAxis labels
    NSMutableArray *customLabels = [[NSMutableArray alloc] initWithCapacity: self.numberOfPoints];

    for (int i = 0; i < self.numberOfPoints; i++) {
        // ============================================================
        // Read date from points and transform into string
        MyPoint *reading = (MyPoint*)[self.points objectAtIndex:(i)];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd/MM/YY"];
        NSString *date = [formatter stringFromDate:reading.getMyDate];

        // ============================================================
        // Use that string to create a label
        CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText:date textStyle:x.labelTextStyle];

        // ============================================================
        // Place label at location and rotate it
        NSNumber *tickLocation = [NSNumber numberWithInt:i];
        newLabel.tickLocation = tickLocation;
        // newLabel.tickLocation = [tickLocation decimalValue];
        newLabel.offset = x.labelOffset + x.majorTickLength;
        newLabel.rotation = M_PI/4;

        // ============================================================
        // Add the label into array
        [customLabels addObject:newLabel];
    }
    x.axisLabels =  [NSSet setWithArray:customLabels];
    x.masksToBorder = YES;
}

/*
 @method Sets up the X axis on a graph
 */
-(void)configureYAxisForGraph:(CPTXYGraph*)graphForAxis{
    // ============================================================
    // Setup yAxis place and style
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graphForAxis.axisSet;
    CPTXYAxis *y = axisSet.yAxis;
    y.minorTicksPerInterval = 0;
    y.labelOffset = 0.0f;
    y.labelingPolicy = CPTAxisLabelingPolicyNone;
    //set the starting position of the x-axis
    // y.orthogonalPosition = CPTDecimalFromString(@"0");
    y.orthogonalPosition = 0;
    y.title = NSLocalizedString(@"Calories Burned", @"");

    int yRange = [self getYTopValueWithOffset:0] - [self getYBottomValueWithOffset:0];

    // ============================================================
    // Setup label location which is every other sample rate
    NSMutableArray *customTickLocations = [[NSMutableArray alloc] initWithCapacity:yRange];

    float sample = ([self getYTopValueWithOffset:0] - [self getYBottomValueWithOffset:0])/kSampleRate;

    for (int x = 0; x < (kSampleRate + 1); x++) {
        [customTickLocations addObject:[NSNumber numberWithFloat:((x*sample) +  [self getYBottomValueWithOffset:0])]];
    }
    y.majorTickLocations =  [NSSet setWithArray:customTickLocations];

    // ============================================================
    // Setup labels of yAxis
    NSMutableArray *customLabels = [[NSMutableArray alloc] initWithCapacity: customTickLocations.count];

    for (int i = 0; i < [customTickLocations count]; i++) {
        NSNumber *tickLocation = [customTickLocations objectAtIndex:i];

        //only show every second label
        if (i % 2 == 0) {
            NSString* formattedNumber = [NSString stringWithFormat:@"%d", [tickLocation intValue]];

            CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText:formattedNumber textStyle:y.labelTextStyle];

            //newLabel.tickLocation = [tickLocation decimalValue];
            newLabel.tickLocation = tickLocation;
            newLabel.offset = y.labelOffset + y.majorTickLength;
            [customLabels addObject:newLabel];
        }
    }

    // ============================================================
    // Setup labels of yAxis
    float number = [[customTickLocations objectAtIndex:([customTickLocations count] -1)] floatValue];
    NSString *strRepresentation = [NSString stringWithFormat:@"%.01f", number];
    self.intYNumberOfCharacters = [strRepresentation length];

    y.titleOffset = (kCharacterPadding*self.intYNumberOfCharacters);
    y.alternatingBandFills = [NSArray arrayWithObjects:[[CPTColor whiteColor] colorWithAlphaComponent:0.2], [NSNull null], nil];
    y.axisLabels =  [NSSet setWithArray:customLabels];
    y.masksToBorder = YES;
}




- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    // ============================================================
    // Return number of points
    if (self.points == nil) {
        self.points = [self loadPoints];
    }

    return self.numberOfPoints;
}

- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    // ============================================================
    // Return the x or y values of a point
    NSNumber* returnValue = nil;

    if (fieldEnum == CPTScatterPlotFieldX) {
        returnValue = [NSNumber numberWithInt:index];
    }else {
        MyPoint* tem = [self.points objectAtIndex:index];
        returnValue = tem.getCalories;
    }

    return returnValue;
}

- (IBAction)postTweet:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]){
        SLComposeViewController *tweet;
        tweet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        if ([self.points count] > 0) {
            MyPoint* today = [self.points lastObject];
            float todayCalory = [today.calories floatValue];
            [tweet setInitialText:[NSString stringWithFormat: @"My today's calory burn is %.1f",todayCalory]];
            [self presentViewController:tweet animated:YES completion:nil];
        }

    }
}

- (IBAction)didSwipeRight:(UISwipeGestureRecognizer *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
