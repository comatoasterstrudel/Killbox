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

    var targetLerpSpeed:Float = 3;
    
    var takingPosition:FlxPoint = new FlxPoint();
    
    public function new(erisGhost:ErisGhost, playState:PlayState, parent:FlxSpriteGroup, targetGroup:FlxSpriteGroup, startPositionRange:Array<FlxPoint>, size:Float):Void{
        super(playState, parent);
        
        this.erisGhost = erisGhost;
        this.targetGroup = targetGroup;
        this.startPositionRange = startPositionRange;
        
        makeGraphic(65, 30, 0xFF7FB8B7);
        resize(size);
        lerpManager.scaleX = scale.x;
        lerpManager.scaleY = scale.y;
        scale.set(0, 0);
        this.color = this.color.getDarkened(1 - size);
        
        setPosition(FlxG.random.float(startPositionRange[0].x, startPositionRange[1].x), FlxG.random.float(startPositionRange[0].y, startPositionRange[1].y));
        
        lerpManager.targetPosition.set(x, y);
        lerpManager.lerpX = true;
        lerpManager.lerpY = true;
        lerpManager.lerpSpeed = 2;
        
        y += 200;
    }
    
    override function update(elapsed:Float):Void
    {
        super.update(elapsed); 
        
        updateMovement(elapsed);
        
        lerpManager.lerpSpeed = Utilities.lerpThing(lerpManager.lerpSpeed, targetLerpSpeed, elapsed, 1);
    }
    
    function updateMovement(elapsed:Float):Void{
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
                targetLerpSpeed = 2;
            case CHASING:
                if(curTarget == null || !targetGroup.members.contains(curTarget) || !acceptedStatuses.contains(playState.getBoxByID(curTarget.ID).status)){
                    status = IDLE;
                    curTarget = null;
                    erisGhost.targetedBoxes.remove(curTarget);
                } else {
                    lerpManager.targetPosition.set(curTarget.x + curTarget.width / 2 - width / 2, curTarget.y - (height / 2));
                    
                    var distance:Float = (1 - FlxMath.bound((FlxMath.distanceBetween(this, curTarget) / 150), 0, 1));
                    
                    targetLerpSpeed = 3 + (20 * distance);
                    
                    if(FlxG.pixelPerfectOverlap(this, curTarget)){
                        playState.getBoxByID(curTarget.ID).status = switch(playState.getBoxByID(curTarget.ID).status){
                            case MAIN_CONVEYOR: MAIN_CONVEYOR_ERIS_TAKING;
                            case LEFT_CONVEYOR:LEFT_CONVEYOR_ERIS_TAKING;
                            case LEFT_BACK_CONVEYOR:LEFT_BACK_CONVEYOR_ERIS_TAKING;
                            default: null;
                        }
                        curTarget.velocity.set(0, 0);
                        lerpManager.lerpSpeed = .25;
                        takingPosition.set(FlxG.random.float(startPositionRange[0].x, startPositionRange[1].x), -(curTarget.height + height + 5));
                        status = TAKING;
                        updateMovement(elapsed);
                    }
                }
            case TAKING:
                lerpManager.targetPosition.set(takingPosition.x, takingPosition.y);
                curTarget.setPosition(this.x + this.width / 2 - curTarget.width / 2, y + (height / 2));
                targetLerpSpeed = .5;
                
                if(curTarget.y < -curTarget.height){
                    playState.getBoxByID(curTarget.ID).status = GONE;
                    targetGroup.remove(curTarget, true);
                    curTarget.destroy();
                    status = DEAD;
                    die();
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
        if(status == TAKING){
            playState.getBoxByID(curTarget.ID).status = switch(playState.getBoxByID(curTarget.ID).status){
                case MAIN_CONVEYOR_ERIS_TAKING: MAIN_CONVEYOR_ERIS_FALLING;
                case LEFT_CONVEYOR_ERIS_TAKING:LEFT_CONVEYOR_ERIS_FALLING;
                case LEFT_BACK_CONVEYOR_ERIS_TAKING:LEFT_BACK_CONVEYOR_ERIS_FALLING;
                default: null;
            }
            curTarget.acceleration.y = 300;
        }
        status = DEAD;
        erisGhost.ghosts.remove(this);
        super.die();
    }
}