//
//  ViewController.m
//  UzysImageCropper
//
//  Created by Uzys on 11. 12. 13..
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void) cropButton
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Image Picker" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Close" otherButtonTitles:@"Camera",@"Library", nil];
    
    [actionSheet showInView:self.view];
    [actionSheet reloadInputViews];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.view setFrame:[UIScreen mainScreen].applicationFrame];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    UIButton *cropper = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cropper setFrame:CGRectMake(110, self.view.frame.size.height - 40, 100, 30)];
    [cropper setTitle:@"Crop" forState:UIControlStateNormal];
    [cropper addTarget:self action:@selector(cropButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cropper];
}

- (void)viewDidUnload
{
    self.imgCropperViewController = nil;
    self.picker = nil;
    self.resultImgView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    [_picker release];
    [_resultImgView release];
    [_imgCropperViewController release];
    [super ah_dealloc];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - UzysImageCropperDelegate

- (void)imageCropper:(UzysImageCropperViewController *)cropper didFinishCroppingWithImage:(UIImage *)image
{
    if(self.resultImgView)
        [self.resultImgView removeFromSuperview];
    
    self.resultImgView = [[[UIImageView alloc]  initWithFrame:CGRectMake(5, 5, 310, 310)] autorelease];
    self.resultImgView.image = image;
    self.resultImgView.backgroundColor = [UIColor darkGrayColor];
    self.resultImgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.resultImgView];

    NSLog(@"cropping Image Size : %@", NSStringFromCGSize(image.size));
   [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageCropperDidCancel:(UzysImageCropperViewController *)cropper
{
    [_picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIImagePickerViewController

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSLog(@"original Image Size : %@", NSStringFromCGSize(image.size));
    _imgCropperViewController = [[UzysImageCropperViewController alloc] initWithImage:image andframeSize:picker.view.frame.size andcropSize:CGSizeMake(1024, 580)];
    _imgCropperViewController.delegate = self;
    [picker presentViewController:_imgCropperViewController animated:YES completion:nil];
    [_imgCropperViewController release];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
 
    switch (buttonIndex)
    {
        case 1:
        {
#if TARGET_IPHONE_SIMULATOR
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"demo" message:@"camera not available"delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alert show];
            [alert release];
#elif TARGET_OS_IPHONE
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
            self.picker=[[[UIImagePickerController alloc]init] autorelease];
            self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            self.picker.delegate  = self;
            [self presentViewController:self.picker animated:YES completion:nil];
#endif
        }
            break;
        case 2:
        {
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
            self.picker=[[[UIImagePickerController alloc]init] autorelease];
            self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            self.picker.delegate  = self;
            [self presentViewController:self.picker animated:YES completion:nil];
        }
            break;
    }
    
}

@end
