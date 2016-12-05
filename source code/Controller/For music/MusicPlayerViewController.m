//
//  MusicPlayerViewController.m
//  MusicPlayer3
//
//  Created by mike yang on 11/24/13.
//  Copyright (c) 2013 mike yang. All rights reserved.
//

#import "MusicPlayerViewController.h"

@interface MusicPlayerViewController ()

@end

@implementation MusicPlayerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// ===========================================================
// When top button add is tabbed
// Go to ipod library to pick songs
- (IBAction)displayMediaPicker:(id)sender {
//     =====================================================================
//     Initialize media picker
    
//    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
//    if (mediaPicker != nil){
//
//         mediaPicker.prompt = @"Choose songs";
//         mediaPicker.allowsPickingMultipleItems = YES;
//         mediaPicker.delegate = self;
//
//        // =====================================================================
//        // Goto media picker view
//        [self presentViewController:mediaPicker animated:YES completion:NULL];
//    }
//    else {
//        NSLog(@"Could not instantiate a media picker.");
//    }
    
    
    
    MPMediaPickerController *picker = [[MPMediaPickerController alloc]     initWithMediaTypes:MPMediaTypeAnyAudio];
    
    [picker setDelegate:self];
    [picker setAllowsPickingMultipleItems:YES];
    [picker setPrompt:NSLocalizedString(@"Add songs to play","Prompt in media item picker")];
    

    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Sorry!",@"Error title")
                                    message:NSLocalizedString(@"This function is not avaiable for current version of IOS10 SDK",@"Error message when MPMediaPickerController fails to load")
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    
    

    
    
}



// =====================================================================
// When bar button pause is tabbed
// Pause or play the music player
- (IBAction)pausePlayingAudio:(id)sender {
    if (self.myMusicPlayer == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty music list"
                                                        message:@"Please pick some song from ipod library~"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    else{
        if (self.playing) {
            [self.myMusicPlayer pause];
            self.playing = false;

            // ====================================================
            // Change playbutton picture
            [self ChangePlayButtonToPlay];
        }
        else{
            [self.myMusicPlayer play];
            self.playing = true;

            // ====================================================
            // Update check mark and current playing time
            [self UpdateCheckMarkByIndexOfNowPlayingItem];

            // ====================================================
            // Change playbutton picture
            [self ChangePlayButtonToPause];
        }
    }
}



- (void) ChangePlayButtonToPause{
    [self.myToolbar setItems:[NSArray arrayWithObjects:
                              [self.myToolbar.items objectAtIndex:0],
                              [self.myToolbar.items objectAtIndex:1],
                              [self.myToolbar.items objectAtIndex:2],
                              [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(pausePlayingAudio:)],
                              [self.myToolbar.items objectAtIndex:4],
                              [self.myToolbar.items objectAtIndex:5],
                              [self.myToolbar.items objectAtIndex:6],
                              nil] animated:NO];
}
- (void) ChangePlayButtonToPlay{
    [self.myToolbar setItems:[NSArray arrayWithObjects:
                              [self.myToolbar.items objectAtIndex:0],
                              [self.myToolbar.items objectAtIndex:1],
                              [self.myToolbar.items objectAtIndex:2],
                              [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(pausePlayingAudio:)],
                              [self.myToolbar.items objectAtIndex:4],
                              [self.myToolbar.items objectAtIndex:5],
                              [self.myToolbar.items objectAtIndex:6],
                              nil] animated:NO];
}

- (void) stopTimer{
    [self.timer invalidate];
}

// ===========================================================
// When bar button stop is tabbed
// Stop the music player
- (IBAction)stopPlayingAudio:(id)sender {
    if (self.myMusicPlayer == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty music list"
                                                        message:@"Please pick some song from ipod library~"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    else{
        // ====================================================
        // Stop music player
        [self.myMusicPlayer stop];

        // ====================================================
        // Update check mark and current playing time
        [self UpdateCheckMarkByIndexOfNowPlayingItem];
    }
}

// =====================================================================
// When bar button rewind is tabbed
- (IBAction)RewindOrGoBack:(id)sender {
    self.changeBySelected = false;
    long currentPlaybackSecond = self.myMusicPlayer.currentPlaybackTime;
    if (currentPlaybackSecond < 5) {
        [self.myMusicPlayer skipToPreviousItem];
    }
    [self.myMusicPlayer skipToBeginning];
}

// ====================================================================
// When bar button forward is tabbed
- (IBAction)MovingForward:(id)sender {
    self.changeBySelected = false;
    [self.myMusicPlayer skipToNextItem];

}


// ====================================================================
// Save picked song into array and update table view
- (void) mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection{
    NSLog(@"Media Picker returned");
    // =====================================================================
    // If we have already created a music player, deallocate it
    self.myMusicPlayer = nil;
    self.myMusicPlayer = [[MPMusicPlayerController alloc] init];
    [self.myMusicPlayer beginGeneratingPlaybackNotifications];

    // =====================================================================
    // Get notified when the playing item changes
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nowPlayingItemIsChanged:) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:self.myMusicPlayer];

    // =====================================================================
    // Add new songs into picked song array
    NSArray *addingArray = mediaItemCollection.items;
    [self.pickedSongs addObjectsFromArray:addingArray];

    // =====================================================================
    // Use new pick array to set play queue
    MPMediaItemCollection *tem = [MPMediaItemCollection collectionWithItems:(NSArray *)self.pickedSongs];
    [self.myMusicPlayer setQueueWithItemCollection:tem];

    // =====================================================================
    // Update the music table
    [self.myTableView reloadData];

    // =====================================================================
    // Dismiss the media picker controller
    [mediaPicker dismissModalViewControllerAnimated:YES];
}

// =====================================================================
// The media picker was cancelled
- (void) mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker{
    NSLog(@"Media Picker was cancelled");
    [mediaPicker dismissModalViewControllerAnimated:YES];
}

// =====================================================================
// Inside code happen when rewind, next button is tabbed or the current song is finished
- (void) nowPlayingItemIsChanged:(NSNotification *)paramNotification{
    // =================================================================
    // This function is too sensitive, following code will only call when changeBySeleced is false
    if (!self.changeBySelected) {
        [self UpdateCheckMarkByIndexOfNowPlayingItem];
    }
}

// =====================================================================
// Central function: update current playing item check mark,
// Call function to update current playing time and duration of this song
- (void)UpdateCheckMarkByIndexOfNowPlayingItem{
    // =========================================================
    // Deselect all the cells
    for (int k = 0; k < [self.myTableView numberOfRowsInSection:0]; k++) {
        UITableViewCell* tem = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:k inSection:0]];
        tem.selected = FALSE;
        tem.accessoryType = UITableViewCellAccessoryNone;
    }
    //NSLog(@"Real Current playing index is %ld",self.myMusicPlayer.indexOfNowPlayingItem);
    // =========================================================
    // Select current playing cell if it has current playing
    self.currentPlayingIndex = self.myMusicPlayer.indexOfNowPlayingItem;
    if (self.currentPlayingIndex <= self.pickedSongs.count - 1) {
        UITableViewCell* cell = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentPlayingIndex inSection:0]];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;

        [self StartTimerTotrackSongDurationAndCurrentTime];
    }
    else{
        // =====================================================================
        // Stop the music player and remove observers
        if (self.myMusicPlayer != nil){
            self.playing = false;
            [self stopTimer];

            [self ChangePlayButtonToPlay];
            [self.processView setProgress:0 animated:YES];
            self.currentLabel.text = [NSString stringWithFormat:@"%02d:%02d", 0, 0 ];
            self.durationLabel.text = [NSString stringWithFormat:@"%02d:%02d", 0, 0 ];
            [self hideProcessView];
        }
    }
}

// =====================================================================
// update current playing time and duration of this song
- (void)StartTimerTotrackSongDurationAndCurrentTime{
    // =========================================================
    // Set current song's duration
    self.currentSongDuration = [[[self.myMusicPlayer nowPlayingItem] valueForProperty: @"playbackDuration"] longValue];
    int tHours = (self.currentSongDuration / 3600);
    int tMins = ((self.currentSongDuration/60) - tHours*60);
    int tSecs = (self.currentSongDuration % 60 );
    self.durationLabel.text = [NSString stringWithFormat:@"%02d:%02d", tMins, tSecs ];
    [self showProcessView];

    // =========================================================
    // Set timer to display current playing point
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:0.25]];
}

- (void)onTimer:(NSTimer *)timer{
    long currentPlaybackTime = self.myMusicPlayer.currentPlaybackTime;
    int currentHours = (currentPlaybackTime / 3600);
    int currentMinutes = ((currentPlaybackTime / 60) - currentHours*60);
    int currentSeconds = (currentPlaybackTime % 60);
    self.currentLabel.text = [NSString stringWithFormat:@"%02d:%02d", currentMinutes, currentSeconds];

    float process = currentPlaybackTime / (float)self.currentSongDuration;

    [self.processView setProgress:process animated:YES];

    if (process > 0.9) {
        self.changeBySelected = false;
    }
}

// =====================================================================
// Initialize table view and each property when the view is load
- (void)viewDidLoad
{
    [super viewDidLoad];
    // ================================================================
    // Setup background image
    self.view.layer.contents = (id)[UIImage imageNamed:@"musicPlayerBackground.jpg"].CGImage;
	// =================================================================
    // Set table view set a subview in the center of current view

    self.myTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;

    // ================================================================
    // Set tableview transparent
    self.myTableView.backgroundColor = nil;


    // =================================================================
    // Initalize each properties
    self.pickedSongs = [[NSMutableArray alloc] init];
    self.currentPlayingIndex = 0;
    self.currentSongDuration = 0;
    self.changeBySelected = true;
    self.myMusicPlayer = nil;
    self.playing = false;
    self.currentLabel.text = [NSString stringWithFormat:@"%02d:%02d", 0, 0 ];
    self.durationLabel.text = [NSString stringWithFormat:@"%02d:%02d", 0, 0 ];
    [self.processView setProgress:0];

    // ================================================================
    // Set lable and process view transparent
    [self hideProcessView];
}

-(void) hideProcessView{
    self.processView.hidden = YES;
    self.currentLabel.hidden = YES;
    self.durationLabel.hidden = YES;
}

-(void) showProcessView{
    self.processView.hidden = NO;
    self.currentLabel.hidden = NO;
    self.durationLabel.hidden = NO;
}

// =====================================================================
// Close the music play before view controller dismissed
- (void)viewDidDisappear:(BOOL)animated
{
    if (self.parentViewController == nil) {
        NSLog(@"MusicPlayer view pops up");
        //release stuff here
        [self.myMusicPlayer stop];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:self.myMusicPlayer];
    } else {
        NSLog(@"MusicPlayer view just hidden");
    }
}

// ###################################################################
// Table view data source

// =================================================================
// Initalize number of sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

// =================================================================
// Initalize number of cell in each section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.pickedSongs.count;
}

// =================================================================
// Set title for a row
-(NSString *) titleForRow:(NSUInteger)row{
    // =================================================================
    // Set song's name as title
    MPMediaItem *currentSong = (MPMediaItem*)self.pickedSongs[row];
    return [currentSong valueForProperty:MPMediaItemPropertyTitle];
}

// =================================================================
// Create each cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // =================================================================
    // Update each cells
    UITableViewCell *result = nil;
    static NSString *CellIdentifier = @"NumbersCellIdentifier";


    result = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (result == nil){
        result = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:CellIdentifier];
    }
    result.textLabel.text = [self titleForRow:indexPath.row];
    result.backgroundColor = nil;
    return result;
}

// =================================================================
// When user tabbed one cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.changeBySelected = true;
    [self.myMusicPlayer stop];
    // =================================================================
    // Set the queue by the pick song array
    MPMediaItemCollection *tem = [MPMediaItemCollection collectionWithItems:(NSArray *)self.pickedSongs];
    [self.myMusicPlayer setQueueWithItemCollection:tem];

    // =================================================================
    // Set play pause at the first song
    [self.myMusicPlayer play];
    [self.myMusicPlayer pause];

    // =================================================================
    // Go to the index of selected song and play
    for(int k = 0; k < indexPath.row; k++){
        [self.myMusicPlayer skipToNextItem];
    }
    NSLog(@"Current playing index is %ld",indexPath.row);
    [self.myMusicPlayer play];
    self.playing = true;
    // =================================================================
    // Set the index of the cell for later drawing check mark
    self.currentPlayingIndex = indexPath.row;

    // =================================================================
    // set pause button to play
    [self ChangePlayButtonToPause];


    // =================================================================
    // Deselect all the cells
    for (int k = 0; k < [self.myTableView numberOfRowsInSection:0]; k++) {
        UITableViewCell* tem = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:k inSection:0]];
        tem.selected = FALSE;
        tem.accessoryType = UITableViewCellAccessoryNone;
    }
    // =================================================================
    // Select current playing cell
    UITableViewCell* cell = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentPlayingIndex inSection:0]];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    // =================================================================
    // Set current song's duration
    self.currentSongDuration = [[[self.pickedSongs objectAtIndex:indexPath.row] valueForProperty: @"playbackDuration"] longValue];
    int tHours = (self.currentSongDuration / 3600);
    int tMins = ((self.currentSongDuration/60) - tHours*60);
    int tSecs = (self.currentSongDuration % 60 );
    self.durationLabel.text = [NSString stringWithFormat:@"%02d:%02d", tMins, tSecs ];
    [self showProcessView];
    
    // =================================================================
    // Set timer to display current playing point
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:0.25]];

}


// Table view data source
// ###################################################################

-(void) setWeight:(NSNumber *)newWeight{
    _weight = newWeight;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"prepareForSegue called");
    NSLog(@"In music view, weight is:%.1f",[self.weight floatValue]);

    if ([segue.destinationViewController respondsToSelector:@selector(setWeight:)]){
        [segue.destinationViewController performSelector:@selector(setWeight:) withObject:self.weight];
    }

}

- (IBAction)didSwipeRight:(UISwipeGestureRecognizer *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
