package killbox.game.night.rooms.left;

/**
 * the box spring in the left room that sends boxes to the right room
 */
class BoxSpring extends FlxSpriteGroup
{
    /**
     * sprites
     */
    public var springTop:KbSprite;
    public var springBottom:KbSprite;
    
    /**
     * is the spring currently springing?
     */
    public var springing:Bool = false;
    
    public function new():Void{
        super();
        
        springBottom = new KbSprite().createFromImage('assets/images/night/rooms/left/spring.png');
        add(springBottom);
        
        springTop = new KbSprite(745, 230).createColorBlock(115, 20, 0xFF3C3C3C);
        add(springTop);
    }
    
    override function update(elapsed:Float):Void{
        super.update(elapsed);
        
        updateSpringPosition();
    }
    
    /**
     * update the bottom sprite position according to the top sprite
     */
    function updateSpringPosition():Void{
        springBottom.setGraphicSize(springBottom.width, springTop.height + (230 - springTop.y));
        springBottom.updateHitbox();
        springBottom.y = springTop.y;
        springBottom.x = springTop.x + springTop.width / 2 - springBottom.width / 2;
    }
    
    /**
     * call this to start the spring animation
     */
    public function springUp():Void{
        springing = true;
        
        var time = GameValues.getSpringTime();
        
        PlayState.tweenManager.tween(springTop, {y: 100}, time / 5, {ease: FlxEase.quartOut, onComplete: function(f):Void{
            PlayState.tweenManager.tween(springTop, {y: 230}, (time / 5) * 2, {startDelay: (time / 5) * 2, onComplete: function(f):Void{
                springing = false;
            }});
        }});
    }
}