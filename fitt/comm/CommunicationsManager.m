//
//  CommunicationsManager.m
//  fitt
//
//  Created by Nico Blodow on 02/11/16.
//  Copyright © 2016 Nico Blodow. All rights reserved.
//

#import "CommunicationsManager.h"

#import <CoreBluetooth/CoreBluetooth.h>

@interface CommunicationsManager () <CBCentralManagerDelegate>

@property (nonatomic, strong) CBCentralManager* manager;
@property (nonatomic) BOOL startedScan;

@end

@implementation CommunicationsManager

+ (instancetype)sharedManager
{
    static CommunicationsManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        _heartRateSensor = [[HeartRateSensor alloc] init];
    }
    return self;
}

- (void)connect
{
    self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    if ([self isLECapableHardware]) {
        self.startedScan = YES;
        [self startScan];
    }
}

- (void)disconnect
{
    if (self.heartRateSensor.peripheral) {
        [self.manager cancelPeripheralConnection:self.heartRateSensor.peripheral];
    }
}

- (void)startScan
{
    [self.manager scanForPeripheralsWithServices:[NSArray arrayWithObject:[CBUUID UUIDWithString:@"180D"]] options:nil];
}

- (void) stopScan
{
    [self.manager stopScan];
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if ([self isLECapableHardware] && !self.startedScan) {
        [self startScan];
    }
}

- (void) centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)aPeripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSArray<CBPeripheral*>* peripherals = [self.manager retrievePeripheralsWithIdentifiers:@[aPeripheral.identifier]];
    if (peripherals && peripherals.count > 0) {
        CBPeripheral* peripheral = peripherals[0];
        NSLog(@"Discovered %@", peripheral);
        [self.manager connectPeripheral:peripheral options:@{CBConnectPeripheralOptionNotifyOnDisconnectionKey: @YES,
                                                             CBConnectPeripheralOptionNotifyOnConnectionKey: @YES}];
        NSLog(@"Discovered %@", peripheral);
        self.heartRateSensor.peripheral = peripheral;
    }
}
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"Connected");
    [peripheral setDelegate:self.heartRateSensor];
    [peripheral discoverServices:nil];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Not connected");
    if (self.heartRateSensor.peripheral == peripheral) {
        [self.heartRateSensor.peripheral setDelegate:nil];
        self.heartRateSensor.peripheral = nil;
    }
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Fail to connect to peripheral: %@ with error = %@", peripheral, [error localizedDescription]);
    if (self.heartRateSensor.peripheral == peripheral) {
        [self.heartRateSensor.peripheral setDelegate:nil];
        self.heartRateSensor.peripheral = nil;
    }
}

- (BOOL) isLECapableHardware
{
    NSString * state = nil;
    
    switch ([self.manager state]) {
        case CBCentralManagerStateUnsupported:
            state = @"The platform/hardware doesn't support Bluetooth Low Energy.";
            break;
        case CBCentralManagerStateUnauthorized:
            state = @"The app is not authorized to use Bluetooth Low Energy.";
            break;
        case CBCentralManagerStatePoweredOff:
            state = @"Bluetooth is currently powered off.";
            break;
        case CBCentralManagerStatePoweredOn:
            return TRUE;
        case CBCentralManagerStateUnknown:
        default:
            return FALSE;
    }
    
    NSLog(@"Central manager state: %@", state);
    
    /*
    NSAlert *alert = [[[NSAlert alloc] init] autorelease];
    [alert setMessageText:state];
    [alert addButtonWithTitle:@"OK"];
    [alert setIcon:[[[NSImage alloc] initWithContentsOfFile:@"AppIcon"] autorelease]];
    [alert beginSheetModalForWindow:[self window] modalDelegate:self didEndSelector:nil contextInfo:nil];
     */
    NSLog(@"%@", state);
    return FALSE;
}
@end
