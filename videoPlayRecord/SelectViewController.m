//
//  SelectViewController.m
//  videoPlayRecord
//
//  Created by Lightning on 15/4/25.
//  Copyright (c) 2015年 Lightning. All rights reserved.
//

#import "SelectViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>

@interface SelectViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
- (IBAction)playVideo:(id)sender;

@end

@implementation SelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)playVideo:(id)sender {
    [self startMediaBrowserFromViewController:self usingDelegate:self];

}


-(BOOL)startMediaBrowserFromViewController:(UIViewController*)controller usingDelegate:(id )delegate {
    // 1 - Validations
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
        || (delegate == nil)
        || (controller == nil)) {
        return NO;
    }
    // 2 - Get image picker
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    mediaUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    mediaUI.allowsEditing = YES;
    mediaUI.delegate = delegate;
    // 3 - Display image picker
    [controller presentViewController:mediaUI animated:YES completion:nil];
    return YES;
}

#pragma mark - imageDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // get media type
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    // dismiss image picker
    [self dismissViewControllerAnimated:NO completion:nil];
    
    // handle a movie capture
    if (CFStringCompare((__bridge CFStringRef)mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
        MPMoviePlayerViewController *theMoview = [[MPMoviePlayerViewController alloc] initWithContentURL:[info objectForKey:UIImagePickerControllerMediaURL]];
        
        [self presentViewController:theMoview animated:YES completion:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myMovieFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification object:theMoview];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myMovieFinishedCallback:) name:MPMoviePlayerDidExitFullscreenNotification object:theMoview];
    }
}

- (void)myMovieFinishedCallback:(NSNotification *)noti
{
    NSLog(@"%s", __func__);
    [self dismissMoviePlayerViewControllerAnimated];
    MPMoviePlayerController *theMoview = [noti object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:theMoview];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:NO completion:nil];
    NSLog(@"%s",__func__);
}


@end
