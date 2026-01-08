package killbox.game.night.ghost.ghosttypes.eris;

class ErisGhost extends Ghost
{
    var maxEntities:Int = 7;
    
    public var ghosts:Array<ErisGhostSprite> = [];
    
    public var targetedBoxes:Array<FlxSprite> = [];
    
    public function new(playState:PlayState):Void{
        super(playState, 'eris', 2);        
    }
    
    override function move():Void{
        if(ghosts.length >= maxEntities) return;
        
        var target = FlxG.random.int(1,3); //1 = main room, 2 = left room front, 3 = left room back
        
        var ghost:ErisGhostSprite = null;
        
        switch(target){
            case 1:
                ghost = new ErisGhostSprite(this, playState, playState.roomMain.erisGhostGroup, playState.roomMain.boxSprites, [new FlxPoint(160, 100), new FlxPoint(400, 130)], .67);
                playState.roomMain.erisGhostGroup.add(ghost);
            case 2:
                ghost = new ErisGhostSprite(this, playState, playState.roomLeft.erisGhostGroupFront, playState.roomLeft.boxFrontConveyorSprites, [new FlxPoint(50, 100), new FlxPoint(1000, 250)], 1);
                playState.roomLeft.erisGhostGroupFront.add(ghost);
            case 3:
                ghost = new ErisGhostSprite(this, playState, playState.roomLeft.erisGhostGroupBack, playState.roomLeft.boxBackConveyorSprites, [new FlxPoint(50, 10), new FlxPoint(1000, 50)], .7);
                playState.roomLeft.erisGhostGroupBack.add(ghost);
        }
        
        ghosts.push(ghost);
    }
    
    override function update(elapsed:Float):Void{
        super.update(elapsed);
        
        var removeThese:Array<ErisGhostSprite> = [];
        
        for(i in ghosts){
            if(i == null) removeThese.push(i);
        }
        
        for(i in removeThese){
            ghosts.remove(i);
        }
    }
}