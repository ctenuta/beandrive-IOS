//
//  ViewController.m
//  BeanDrive
//
//  Created by Cristiano Tenuta on 18/06/17.
//  Copyright © 2017 Cristiano Tenuta. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()



@end

@implementation ViewController

BOOL isConnected;
BOOL isScanning;

@synthesize directionMotor1;
@synthesize directionMotor2;



- (void)viewDidLoad {
    [super viewDidLoad];

     self.beanManager = [[PTDBeanManager alloc] initWithDelegate:self];
    
    [self.speedMotor1 addTarget:self action:@selector(speedMotor1Changed:) forControlEvents:UIControlEventValueChanged];
    [self.speedMotor2 addTarget:self action:@selector(speedMotor2Changed:) forControlEvents:UIControlEventValueChanged];
    
}


- (void)startScanning {
    
    NSError *error;
    
    isScanning = YES;
    [self.state setText:@"Scanning..."];
    
    [self.beanManager startScanningForBeans_error:&error];
    
    if ( error != nil ) {
        NSLog(@"Error scanning for beans: %@", error );
    }
    
}

-(void) stopScanning {
    
    NSError *error;
    
    isScanning = NO;
    
    [self.state setText:@"Disconnected"];
    [self.beanManager stopScanningForBeans_error:&error];
    
    if ( error != nil ) {
        NSLog(@"Error scanning for beans: %@", error );
    }
}

-(void)beanManager:(PTDBeanManager *)beanManager didDiscoverBean:(PTDBean *)bean error:(NSError *)error {
    
    if ([bean.name isEqualToString:@"Bean+"]) {
        self.motorControl = bean;
        [self connect:self.motorControl];
    }
}

-(void)beanManager:(PTDBeanManager *)beanManager didConnectBean:(PTDBean *)bean error:(NSError *)error {
    [self stopScanning];
    [self.motorControl setDelegate:self];
    [self.state setText:@"Connected"];
    isConnected = YES;
    [self.connection setEnabled:YES];
    [self.connection setTitle:@"Disconnect" forState:UIControlStateNormal];
}

-(void)beanManager:(PTDBeanManager *)beanManager didDisconnectBean:(PTDBean *)bean error:(NSError *)error {
    [self.state setText:@"Disconnected"];
    isConnected = NO;
    [self.connection setEnabled:YES];
    [self.connection setTitle:@"Connect" forState:UIControlStateNormal];
}

-(void)beanManagerDidUpdateState:(PTDBeanManager *)beanManager {
    
    
    if (self.beanManager.state == BeanManagerState_PoweredOff) {
        
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Bluetooth Off"
                                     message:@"Turn on your bluetooth"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        
        
        UIAlertAction* okButton = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       
                                   }];
        
        
        [alert addAction:okButton];
        
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
}

- (void)connect:(PTDBean *)bean {
    
    NSError *error;
    
    [self.beanManager connectToBean:bean error:&error];
    
    if ( error != nil ) {
        NSLog(@"Error connecting to bean: %@", error );
    }
}

- (void)disconnect {
    
    NSError *error;
    
    [self.beanManager disconnectBean:self.motorControl error:&error];
    
    if ( error != nil ) {
        NSLog(@"Error disconnecting from bean: %@", error );
    }
    
}



-(IBAction)connectionClick:(id)sender {
    
    if (isConnected) {
        [self disconnect];
    } else {
        if (isScanning) {
            [self stopScanning];
            [self.connection setTitle:@"Connect" forState:UIControlStateNormal];
        } else {
            [self startScanning];
            [self.connection setTitle:@"Cancel" forState:UIControlStateNormal];
        }
    }
}

- (IBAction)speedMotor1Changed:(UISlider *)sender {

    
    int speed = sender.value;
    const unsigned char bytes[] = {0,1,speed};
    NSData *data = [NSData dataWithBytes:bytes length:sizeof(bytes)];
    [self.motorControl sendSerialData:data];

}

- (IBAction)speedMotor2Changed:(UISlider *)sender {

    int speed = sender.value;
    const unsigned char bytes[] = {0,2,speed};
    NSData *data = [NSData dataWithBytes:bytes length:sizeof(bytes)];
    [self.motorControl sendSerialData:data];

}


-(IBAction)directionMotor1Changed:(id)sender {
    
    UInt8 direction = (UInt8)directionMotor1.selectedSegmentIndex;
    const unsigned char bytes[] = {1,1,direction};
    NSData *data = [NSData dataWithBytes:bytes length:sizeof(bytes)];
    [self.motorControl sendSerialData:data];
}

-(IBAction)directionMotor2Changed:(id)sender {
    
    UInt8 direction = (UInt8)directionMotor2.selectedSegmentIndex;
    const unsigned char bytes[] = {1,2,direction};
    NSData *data = [NSData dataWithBytes:bytes length:sizeof(bytes)];
    [self.motorControl sendSerialData:data];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
