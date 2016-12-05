//
//  MusicPlayerViewController.h
//  MusicPlayer3
//
//  Created by mike yang on 11/24/13.
//  Copyright (c) 2013 mike yang. All rights reserved.
//


#import <MediaPlayer/MediaPlayer.h>
#import <CoreData/CoreData.h>
#import "CaloryTrack.h"
#import "AppDelegate.h"

@interface MusicPlayerViewController : UIViewController <MPMediaPickerControllerDelegate,UITableViewDelegate, UITableViewDataSource>


@property (weak, nonatomic) MPMusicPlayerController *myMusicPlayer;
@property (strong, nonatomic) NSMutableArray *pickedSongs;
@property NSInteger currentPlayingIndex;
@property long currentSongDuration;
@property(assign, nonatomic) BOOL playing; /* is it playing or not? */
@property (nonatomic) NSTimer *timer;
@property (nonatomic) BOOL changeBySelected;


@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *processView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *playOrPauseButton;
@property (weak, nonatomic) IBOutlet UIToolbar *myToolbar;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

//Get from LogInViewController and pass to CircleProcessViewController or StepCounterViewController
@property (strong,nonatomic) NSNumber* weight;

-(void) setWeight:(NSNumber *)newWeight;
@end
