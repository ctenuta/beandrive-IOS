//
//  ViewController.h
//  BeanDrive
//
//  Created by Cristiano Tenuta on 18/06/17.
//  Copyright © 2017 Cristiano Tenuta. All rights reserved.
//

#import <UIKit/UIKit.h>

@import Bean_iOS_OSX_SDK;

@interface ViewController : UIViewController<PTDBeanManagerDelegate, PTDBeanDelegate>

@property (strong, nonatomic) PTDBeanManager *beanManager;
@property (strong, nonatomic) PTDBean *motorControl;

@property (retain, nonatomic) IBOutlet UIButton  *connection;
@property (retain, nonatomic) IBOutlet UILabel  *state;

@property (retain, nonatomic) IBOutlet UISlider  *speedMotor1;
@property (retain, nonatomic) IBOutlet UISegmentedControl  *directionMotor1;

@property (retain, nonatomic) IBOutlet UISlider  *speedMotor2;
@property (retain, nonatomic) IBOutlet UISegmentedControl  *directionMotor2;


@end

