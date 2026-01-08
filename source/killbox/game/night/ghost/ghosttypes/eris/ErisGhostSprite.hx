package killbox.game.night.ghost.ghosttypes.eris;

class ErisGhostSprite extends GhostSprite
{
    var erisGhost:ErisGhost;
    
    var startPositionRange:Array<FlxPoint> = [];
    
    var curTarget:FlxSprite;
    
    var movementTimer:Float = 0;
    var maxMovementTimer:Float = 2;
    
    var status:ErisStatus = IDLE;
    
    var targetGroup:FlxSpriteGroup;
    
    var acceptedStatuses:Array<BoxStatus> = [MAIN_CONVEYOR, LEFT_CONVEYOR, LEFT_BACK_CONVEYOR];

    public function new(erisGhost:ErisGhost, playState:PlayState, parent:FlxSpriteGroup, targetGroup:FlxSpriteGroup, startPositionRange:Array<FlxPoint>, size:Float):Void{
        super(playState, parent);
        
        this.erisGhost = erisGhost;
        this.targetGroup = targetGroup;
        this.startPositionRange = startPositionRange;
        
        resize(size);
        this.color = this.color.getDarkened(1 - size);
        
        setPosition(FlxG.random.float(startPositionRange[0].x, startPositionRange[1].x), FlxG.random.float(startPositionRange[0].y, startPositionRange[1].y));
        
        lerpManager.targetPosition.set(x, y);
        lerpManager.lerpX = true;
        lerpManager.lerpY = true;
        lerpManager.lerpSpeed = 3;
        
        y += 200;
    }
    
    override function update(elapsed:Float):Void
    {
        super.update(elapsed); 
        
        switch(status){
            case IDLE:
                movementTimer += elapsed;
    
                if(movementTimer >= FlxG.random.float(.8, 1.2)){ //move
                    movementTimer = 0;
                    searchForTarget();
                    
                    if(curTarget == null){
                        lerpManager.targetPosition.set(FlxMath.bound(lerpManager.targetPosition.x + FlxG.random.float(-30, 30), startPositionRange[0].x, startPositionRange[1].x), FlxMath.bound(lerpManager.targetPosition.y + FlxG.random.float(-30, 30), startPositionRange[0].y, startPositionRange[1].y));
                    } else {
                        status = CHASING;
                    }
                }
            case CHASING:
                if(curTarget == null || !acceptedStatuses.contains(playState.getBoxByID(curTarget.ID).status)){
                    status = IDLE;
                    curTarget = null;
                    erisGhost.targetedBoxes.remove(curTarget);
                } else {
                    lerpManager.targetPosition.set(curTarget.x + curTarget.width / 2 - width / 2, curTarget.y - 30);
                }
            default:
                //
        }
    }
    
    function searchForTarget():Void{        
        for(i in targetGroup){
            if(acceptedStatuses.contains(playState.getBoxByID(i.ID).status) && !erisGhost.targetedBoxes.contains(i)){
                curTarget = i; 
                erisGhost.targetedBoxes.push(curTarget);
                return;
            }
        }
    }
    
    override function die():Void{
        erisGhost.ghosts.remove(this);
        super.die();
    }
}