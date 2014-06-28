//
//  ViewController.m
//  Dodge Template
//
//  Copyright (c) 2014 Company name. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>

#define kRemoveAdsProductIdentifier @"DodgeBalls"

#define kLeaderboardIdentifier @"Dodge.Scoreboard￼￼"

#define kIDRateApp @"https://itunes.apple.com/us/app/dodge-the-red-balls/id881951204?ls=1&mt=8"


#define kGameStateMenu 1
#define kGameStateStart 2
#define kGameStateRunning 3
#define kGameStatePaused 4
#define kGameStateOver 5



@interface ViewController ()


@end

@implementation ViewController


NSInteger gameState;
int score;
NSTimer *gameTimer;
int difficulty;
SystemSoundID mySound;
int lol;

-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    speed = 1;
    
    [[MylogonAudio sharedInstance]playBackgroundMusic:@"bg.mp3"];
    
    _connecting.hidden = YES;
    [[GameCenterManager sharedManager] setDelegate:self];
#warning adUnitID here
    
    objectsArray = [NSArray arrayWithObjects:_object1,_object2,_object3,_object4,_object5, nil];
    
    //  self.banner.adUnitID = @"ca-app-pub-4527607880928611/9436906689";
    self.banner.delegate = self;
    self.banner.rootViewController = self;
    [self.banner loadRequest: [GADRequest request]];
    
    
    _scoreLabel.font = [UIFont fontWithName:@"debussy" size:35];
    _scoreLabel.textColor = [UIColor whiteColor];
    
    _finalScore.font = [UIFont fontWithName:@"debussy" size:20];
    _finalScore.textColor = [UIColor grayColor];
    
    _bestScore.font = [UIFont fontWithName:@"debussy" size:20];
    _bestScore.textColor = [UIColor blackColor];
  
    gameState = kGameStateMenu;
    
    [self menu];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - MENU
-(void)menu{
    _scoreLabel.hidden = YES;
    _instructions.hidden = NO;
    [self resetHero];
    CGRect menu;
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    if(UI_USER_INTERFACE_IDIOM() == UI_USER_INTERFACE_IDIOM()){
        if(screenSize.height >480.0f){
            menu= CGRectMake(17,79,287,270);
        }
        else{
            menu= CGRectMake(17,56,287,270);
        }
        
    }
    
    [UIView animateWithDuration: 1.0f
                     animations:^{
                         _titleView.frame = menu;
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    
}
- (IBAction)play:(id)sender {
    _instructions.hidden = YES;
    _scoreLabel.hidden = NO;
    score = 0;
    _scoreLabel.text = @"0";
    
    
    
    difficulty = 4.0;
    
    if(gameTimer)
    {
        [gameTimer invalidate];
        gameTimer = nil;
    }
    [self initObject1];
    [self initObject2];
    [self initObject3];
    [self initObject4];
    [self initObject5];
    [self resetHero];
    gameState = kGameStateRunning;
    
    CGRect menu;
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    if(UI_USER_INTERFACE_IDIOM() == UI_USER_INTERFACE_IDIOM()){
        if(screenSize.height >480.0f){
            menu= CGRectMake(17,700,287,270);
        }
        else{
            menu= CGRectMake(17,600,287,270);
        }
        
    }
    
    [UIView animateWithDuration: 1.0f
                     animations:^{
                         _titleView.frame = menu;
                     }
                     completion:^(BOOL finished){
                         gameTimer = [NSTimer scheduledTimerWithTimeInterval:0.007 target:self selector:@selector(gameLoop) userInfo:nil repeats:YES];
                         
                     }];
    
    [self performSelector:@selector(move) withObject:nil afterDelay:1];
}


- (IBAction)highscores:(id)sender {
    [self showLeaderboard];
}

- (IBAction)retry:(id)sender {
    CGRect done;
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    if(UI_USER_INTERFACE_IDIOM() == UI_USER_INTERFACE_IDIOM()){
        if(screenSize.height >480.0f){
            done = CGRectMake(16,700,280,286);
        }
        else{
            done = CGRectMake(16,600,280,286);
        }
        
    }
    
    [self performSelector:@selector(initObject1) withObject:nil afterDelay:0.5];
    [self initObject2];
    [self initObject3];
    [self initObject4];
    [self initObject5];
    
    [UIView animateWithDuration: 0.6f
                          delay: 0.3f
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _gameoverView.frame = done;
                     }
                     completion:^(BOOL finished){
                         [self play:self];
                     }];
    
    gameState = kGameStateStart;
}

- (IBAction)rate:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:kIDRateApp]]];
}

#pragma mark - GAME
-(void)gameLoop{
    
    if (score < 10) {
        speed = 1;
    }
    if (score >= 10 && score < 20) {
        speed = 1.5;
    }
    if (score >= 20 && score < 30) {
        speed = 2;
    }
    if (score >= 30 && score < 40) {
        speed = 2.5;
    }
    if (score >= 40) {
        speed = 3;
    }
    
    
    _object1.center = CGPointMake(_object1.center.x, _object1.center.y + speed);
    _object2.center = CGPointMake(_object2.center.x, _object2.center.y + speed);
    _object3.center = CGPointMake(_object3.center.x, _object3.center.y + speed);
    _object4.center = CGPointMake(_object4.center.x, _object4.center.y + speed);
    _object5.center = CGPointMake(_object5.center.x, _object5.center.y + speed);
    
    
    if(gameState == kGameStateRunning ){
        
        //Update Asteroids and check collisions
        
        //Move the objects down
        
        //Check if the object is off the screen, if so reset the position
        
        
        if(_object1.center.y > 660){
            [self initObject1];
            
        }
        if(_object2.center.y > 660){
            gameState = kGameStateOver;
            [self gameOver];
            //if the asteroid is successfully dodged, update the score
        }
        if(_object3.center.y > 660){
            gameState = kGameStateOver;
            [self gameOver];
            //if the asteroid is successfully dodged, update the score
        }
        if(_object4.center.y > 660){
            gameState = kGameStateOver;
            [self gameOver];
        }
        if(_object5.center.y > 660){
            gameState = kGameStateOver;
            [self gameOver];
        }
        
        //check collision
        CGRect heroRect = CGRectMake(_hero.frame.origin.x, _hero.frame.origin.y, _hero.frame.size.width - 15 , _hero.frame.size.height - 50);
        
        if(CGRectIntersectsRect(heroRect, _object1.frame)){
            gameState = kGameStateOver;
            [self gameOver];
        }
        
        if(CGRectIntersectsRect(heroRect, _object2.frame)){
            [self initObject2];
            score ++;
        }
        
        if(CGRectIntersectsRect(heroRect, _object3.frame)){
            [self initObject3];
            score ++;
        }
        
        if(CGRectIntersectsRect(heroRect, _object4.frame)){
            [self initObject4];
            score ++;
        }
        
        if(CGRectIntersectsRect(heroRect, _object5.frame)){
            [self initObject5];
            score ++;
        }
        
        
        _scoreLabel.text = [NSString stringWithFormat:@"%d", score];
    }
    if(gameState == kGameStatePaused){
        //pause everything
        
    }
}


-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //moves hero
    
    UITouch *touch = [[event allTouches]anyObject];
    CGPoint location = [touch locationInView:touch.view];
    _hero.center = CGPointMake(location.x, location.y+30);
    
    [self performSelector:@selector(move) withObject:nil afterDelay:0.03];
    
    //[self touchesMoved:touches withEvent:event];
}

-(void) move{
    _hero.center = CGPointMake(-100, -100);
}

/*
 -(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
 
 if(location.x > _hero.center.x){
 _hero.image = [UIImage imageNamed:@"hero.png"];
 }
 else{
 _hero.image = [UIImage imageNamed:@"hero.png"];
 }
 _hero.center=xLocation;
 }
 */
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    _hero.center = CGPointMake(-100, -100);
}

#pragma mark - GAME OVER
-(void)gameOver{
    _scoreLabel.hidden = YES;
    
    NSString *path  = [[NSBundle mainBundle] pathForResource:@"deadSound" ofType:@"mp3"];
    NSURL *pathURL = [NSURL fileURLWithPath : path];
    
    SystemSoundID audioEffect;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, &audioEffect);
    AudioServicesPlaySystemSound(audioEffect);
    
    CGRect heroRect;
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    if(UI_USER_INTERFACE_IDIOM() == UI_USER_INTERFACE_IDIOM()){
        if(screenSize.height >480.0f){
            heroRect = CGRectMake(_hero.frame.origin.x,700,39,48);
        }
        else{
            heroRect = CGRectMake(_hero.frame.origin.x,600,39,48);
        }
        
    }
    
    
    CGRect heroUp = CGRectMake(_hero.frame.origin.x, _hero.frame.origin.y - 30, _hero.frame.size.width, _hero.frame.size.height);
    
    [UIView animateWithDuration: 0.2f
                          delay: 0.0f
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _hero.frame = heroUp;
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration: 0.5f
                                               delay: 0.1f
                                             options: UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              _hero.frame = heroRect;
                                          }
                                          completion:^(BOOL finished){
                                              // [self gameOver];
                                          }];
                     }];
    
    
    
    
    
    _finalScore.text = [NSString stringWithFormat:@"%i", score];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults valueForKey:@"highscore"] == NULL) {
        [defaults setValue:@"0" forKey:@"highscore"];
    }
    if(score > [[defaults objectForKey:@"highscore"]intValue]){
        int x = [_finalScore.text intValue];
        [self submitToLeaderboard:x];
        [defaults setObject:_finalScore.text forKey:@"highscore"];
        [defaults synchronize];
    }
    
    _bestScore.text = [defaults objectForKey:@"highscore"];
    
    CGRect gameOver;
    
    if(UI_USER_INTERFACE_IDIOM() == UI_USER_INTERFACE_IDIOM()){
        if(screenSize.height >480.0f){
            gameOver= CGRectMake(20,88,280,286);
            
        }
        else{
            gameOver= CGRectMake(20,57,280,286);
        }
        
    }
    
    
    [UIView animateWithDuration: 1.0f
                     animations:^{
                         _gameoverView.frame = gameOver;
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    
    
    
    
}

#pragma mark - INIT OBJECTS
-(void)resetHero{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    if(UI_USER_INTERFACE_IDIOM() == UI_USER_INTERFACE_IDIOM()){
        if(screenSize.height >480.0f){
            _hero.frame = CGRectMake(141,399,39,48);
        }
        else{
            _hero.frame = CGRectMake(141,331,39,48);
        }
    }
}

-(void)initObject1{
    int steelX = arc4random_uniform(320) ;
    int steelY = -_object1.frame.size.height/2;
    
    _object1.center = CGPointMake(steelX, steelY);
    
    [self collision:_object1];

    
}

-(void)collision:(UIImageView *)IV1{

    ob1 = _object1.frame;
    ob2 = _object2.frame;
    ob3 = _object3.frame;
    ob4 = _object4.frame;
    ob5 = _object5.frame;
    
    
    [self coll1:IV1];
}

-(void)coll1:(UIImageView *)IV{
    
    if (CGRectIntersectsRect(ob1, ob2) || CGRectIntersectsRect(ob1, ob3) || CGRectIntersectsRect(ob1, ob4) || CGRectIntersectsRect(ob1, ob5)) {
        
        IV.center = CGPointMake(IV.center.x,IV.center.y -80);
        [self coll2:IV];
   
    }
}

-(void)coll2:(UIImageView *)IV2{
    
    if (CGRectIntersectsRect(ob1, ob2) || CGRectIntersectsRect(ob1, ob3) || CGRectIntersectsRect(ob1, ob4) || CGRectIntersectsRect(ob1, ob5)) {
        
        IV2.center = CGPointMake(IV2.center.x,IV2.center.y -80);
    }
}

-(void)initObject2{
    int r = arc4random_uniform(320) ;
    int h = -_object2.frame.size.height/2;
    _object2.center = CGPointMake(r, h);
    [self collision:_object2];
}

-(void)initObject3{
    int r = arc4random_uniform(320) ;
    _object3.center = CGPointMake(r, -_object3.frame.size.height/2);
    [self collision:_object3];
}

-(void)initObject4{
    int r = arc4random_uniform(320);
    _object4.center = CGPointMake(r, -_object4.frame.size.height/2);
    [self collision:_object4];
}
-(void)initObject5{
    int r = arc4random_uniform(320);
    _object5.center = CGPointMake(r, -_object5.frame.size.height/2);
    [self collision:_object5];
}



#pragma mark - AdMob Banner

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey: @"noads"] != nil &&
        [[defaults objectForKey: @"noads"] isEqualToString: @"YES"]) {
        self.banner.hidden = YES;
    }
    else {
        self.banner.hidden = NO;
    }
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError: (GADRequestError *)error {
    self.banner.hidden = YES;
}


#pragma mark - inApp PURCHASE
- (void) failedTransaction: (SKPaymentTransaction *)transaction{
    if (transaction.error.code != SKErrorPaymentCancelled){
        // Display an error here.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Purchase Unsuccessful"
                                                        message:@"Your purchase failed. Please try again."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    _connecting.hidden = YES;
    // Finally, remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}
-(void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"%@",error);
    _connecting.hidden = YES;
    
}
- (IBAction)noAds:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"noads"] != nil){
        if([[defaults objectForKey:@"noads"]isEqualToString:@"YES"]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops."
                                                            message:@"You've already bought this."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }else{
        if([SKPaymentQueue canMakePayments]){
            NSLog(@"User can make payments");
            SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:kRemoveAdsProductIdentifier]];
            productsRequest.delegate = self;
            [productsRequest start];
            _connecting.hidden = NO;
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops."
                                                            message:@"I don't think you are allowed to make in-app purchases."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            //this is called the user cannot make payments, most likely due to parental controls
        }
        
    }
}
- (IBAction)restore:(id)sender {
    //this is called when the user restores purchases, you should hook this up to a button
    _connecting.hidden = NO;
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    SKProduct *validProduct = nil;
    int count = (int)[response.products count];
    if(count > 0){
        validProduct = [response.products objectAtIndex:0];
        NSLog(@"Products Available!");
        [self purchase:validProduct];
    }
    else if(!validProduct){
        NSLog(@"No products available");
        _connecting.hidden = YES;
        //this is called if your product id is not valid, this shouldn't be called unless that happens.
    }
}

- (void)purchase:(SKProduct *)product{
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSLog(@"received restored transactions: %i",(int) queue.transactions.count);
    for (SKPaymentTransaction *transaction in queue.transactions)
    {
        if(SKPaymentTransactionStateRestored){
            NSLog(@"Transaction state -> Restored");
            //called when the user successfully restores a purchase
            [self doRemoveAds];
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            break;
        }
        
    }
    _connecting.hidden = YES;
    
}
-(void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    NSLog(@"%@",error);
    _connecting.hidden = YES;
}
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    for(SKPaymentTransaction *transaction in transactions){
        switch (transaction.transactionState){
            case SKPaymentTransactionStatePurchasing: NSLog(@"Transaction state -> Purchasing");
                //called when the user is in the process of purchasing, do not add any of your own code here.
                break;
            case SKPaymentTransactionStatePurchased:
                //this is called when the user has successfully purchased the package (Cha-Ching!)
                [self doRemoveAds]; //you can add your code for what you want to happen when the user buys the purchase here, for this tutorial we use removing ads
                _connecting.hidden = YES;
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                NSLog(@"Transaction state -> Purchased");
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"Transaction state -> Restored");
                //add the same code as you did from SKPaymentTransactionStatePurchased here
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                _connecting.hidden = YES;
                break;
            case SKPaymentTransactionStateFailed:
                //called when the transaction does not finnish
                if(transaction.error.code != SKErrorPaymentCancelled){
                    NSLog(@"Transaction state -> Cancelled");
                    //the user cancelled the payment ;(
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                _connecting.hidden = YES;
                break;
        }
    }
    
}
-(void)doRemoveAds{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"YES"forKey:@"noads"];
    [defaults synchronize];
    self.banner.hidden = YES;
}

#pragma mark - GAME CENTER
- (void)gameCenterManager:(GameCenterManager *)manager authenticateUser:(UIViewController *)gameCenterLoginController{
    [self presentViewController:gameCenterLoginController animated:YES completion:^{
        //You can comment this line, it's simply so we know that we are currently authenticating the user and presenting the controller
        // NSLog(@"Finished Presenting Authentication Controller");
        
    }];
}
- (void) showLeaderboard{
    BOOL isAvailable = [[GameCenterManager sharedManager] checkGameCenterAvailability];
    
    if(isAvailable){
        [[GameCenterManager sharedManager] presentLeaderboardsOnViewController:self];
        
    }else{
        //Showing an alert message that Game Center is unavailable
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Highscore" message: @"Game Center is currently unavailable. Make sure you are logged in." delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alert show];
    }
}
//Submitting to leaderboard - the GameCenterManager framework takes care of submitting the score
-(void)submitToLeaderboard: (int)score{
    //Is Game Center available?
    BOOL isAvailable = [[GameCenterManager sharedManager] checkGameCenterAvailability];
    
    if(isAvailable){
        [[GameCenterManager sharedManager] saveAndReportScore:score leaderboard:kLeaderboardIdentifier sortOrder:GameCenterSortOrderHighToLow];
    }
}
-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
