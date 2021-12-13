//
//  GameScene.m
//  BasicCarGame
//
//  Created by Shorlo on 15/3/15.
//  Copyright (c) 2015 Shorlo. All rights reserved.
//

#import "GameScene.h"
#import <GameController/GameController.h>
@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    
    self.scaleMode = SKSceneScaleModeAspectFill;
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody.categoryBitMask = 1.0;
    self.physicsWorld.gravity = CGVectorMake(0.0, 0.0);
    if (!_cargarEscena)
    {
        [self cargarEscenaConElementos];
        [self cargarEscena];
        //[self configureGameControllers];
    }
    
}

-(void)cargarEscenaConElementos
{

    self.circuito = [SKSpriteNode spriteNodeWithImageNamed:@"circuito.png"];
    _circuito.position = CGPointMake(CGRectGetMidX(self.frame) - 1000, CGRectGetMidY(self.frame));
    _circuito.scale = 2.0;
    _circuito.zPosition = 0.0;

    self.coche = [SKSpriteNode spriteNodeWithImageNamed:@"coche.png"];
    _coche.position = CGPointMake(CGRectGetMidX(self.frame) + 50, CGRectGetMidY(self.frame));
    _coche.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(25.0, 25.0)];
    _coche.physicsBody.categoryBitMask = 2.0;
    _coche.physicsBody.collisionBitMask = 1.0;
    _coche.zPosition = 1.0;
    
    self.fondoPad = [SKSpriteNode spriteNodeWithImageNamed:@"fondoPad.png"];
    _fondoPad.position = CGPointMake(CGRectGetMidX(self.frame) - 160, CGRectGetMidY(self.frame) - 280);
    _fondoPad.scale = 1.5;
    _fondoPad.zPosition = 0.0;
    
    self.pad = [SKSpriteNode spriteNodeWithImageNamed:@"pad.png"];
    _pad.position = CGPointMake(_fondoPad.position.x    , _fondoPad.position.y);
    _pad.zPosition = 0.5;
    
    [self addChild:_circuito];
    [self addChild:_fondoPad];
    [self addChild:_pad];
    [self addChild:_coche];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* Called when a touch begins */

    for (UITouch *touch in touches)
    {
        
    }
}

-(void) gameControllerDidConnect: (NSNotification *) notification
{
    GCController *controller = notification.object;
    NSLog(@"Game Controller %@ conectado!", controller);
    [self assignUnknownController: controller];
}

-(void)gameControllerDidDisconnect: (NSNotification *) notification
{

    GCController *controller = notification.object;
    _controller = nil;
    NSLog(@"Game Controller %@ desconectado!", controller);
    
}

-(void)configureConnectedGameControllers
{
    for (GCController *controller in [GCController controllers]) {
        NSInteger playerIndex = controller.playerIndex;
        if (playerIndex != GCControllerPlayerIndexUnset) {
            continue;
        }
        [self assignUnknownController: controller];
    }

}

-(void) assignUnknownController:(GCController *)controller
{
    // el continue no se puede usar si no es dentro de un for... pero creo que no es el correcto...
    for (controller in [GCController controllers] ) {
        NSInteger playerIndex = controller.playerIndex;

        if (playerIndex != GCControllerPlayerIndexUnset) {
            continue;
        }
        controller.playerIndex = playerIndex; // ojo se le vuelve a pasar el playerindex al controller?...
        [self configureController:controller];
    }

}

-(void)configureController: (GCController *)controller
{
    
    self.controller = controller;
    
    GCControllerDirectionPadValueChangedHandler dpadMoveHandler = ^(GCControllerDirectionPad *dpad, float xValue, float yValue)
    {
        float length = hypotf(xValue, yValue);
        if (length > 0.0f)
        {
            float invLength = 1.0f / length;
            _moverDireccion = CGPointMake(xValue * invLength, yValue *invLength);
        }
        else
        {
            _moverDireccion = CGPointZero;
        }
    };
    
    controller.extendedGamepad.leftThumbstick.valueChangedHandler = dpadMoveHandler;
    controller.gamepad.dpad.valueChangedHandler = dpadMoveHandler;

}

-(void)configureGameControllers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameControllerDidConnect:) name: GCControllerDidConnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameControllerDidDisconnect:) name:GCControllerDidDisconnectNotification object:nil];
    [self configureGameControllers];
    [GCController startWirelessControllerDiscoveryWithCompletionHandler:^{
        NSLog(@"Proceso acabado");
    }];
}


-(void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
}

@end
