//
//  Gameplay.m
//  PeevedPenguins
//
//  Created by Stella Mao on 10/21/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"

@implementation Gameplay {
    CCPhysicsNode* _physicsNode;
    CCNode* _catapultArm;
    CCNode* _levelNode;
}

-(void) didLoadFromCCB
{
    self.userInteractionEnabled = YES;
    CCScene *level = [CCBReader loadAsScene:@"Level/Level1"];
    [_levelNode addChild:level];
}

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    [self launchPenguin];
}

-(void) launchPenguin
{
    CCNode* penguin = [CCBReader load:@"Penguin"];
    penguin.position = ccpAdd(_catapultArm.position, ccp(16, 50));
    [_physicsNode addChild:penguin];
    CGPoint launchDirection = ccp(1, 0);
    CGPoint force = ccpMult(launchDirection, 8000);
    [penguin.physicsBody applyForce:force];
    self.position = ccp(0, 0);
    CCActionFollow *follow = [CCActionFollow actionWithTarget:penguin worldBoundary:self.boundingBox];
    [self runAction:follow];
}

@end
