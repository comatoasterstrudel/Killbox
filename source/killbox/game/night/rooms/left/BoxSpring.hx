package killbox.game.night.rooms.left;

class BoxSpring extends FlxSpriteGroup
{
    public var springTop:FlxSprite;
    public var springBottom:FlxSprite;
    
    public var springing:Bool = false;
    
    public function new():Void{
        super();
        
        springBottom = new FlxSprite().loadGraphic('assets/images/night/rooms/left/spring.png');
        add(springBottom);
        
        springTop = new FlxSprite(745, 230).makeGraphic(115, 20, 0xFF3C3C3C);
        add(springTop);
    }
    
    override function update(elapsed:Float):Void{
        super.update(elapsed);
        
        updateSpringPosition();
    }
    
    function updateSpringPosition():Void{
        springBottom.setGraphicSize(springBottom.width, springTop.height + (230 - springTop.y));
        springBottom.updateHitbox();
        springBottom.y = springTop.y;
        springBottom.x = springTop.x + springTop.width / 2 - springBottom.width / 2;
    }
    
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