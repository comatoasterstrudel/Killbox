package killbox.game.night.rooms.right.parts;

class PartReceptor extends FlxSpriteGroup
{
    var topPart:KbSprite;
    public var bottomParts:Array<KbSprite> = [];
    
    public var depositHere:KbSprite;
    
    public var partCount:Int = 0;
    
    public var ready:Bool = false;
    
    public var shooting:Bool = false;
    
    var hitFunction:Void->Void;
    
    var triggered:Bool = false;
    
    public var timeLeft:Float = 0;
    
    public function new(hitFunction:Void->Void):Void{
        super();
        
        this.hitFunction = hitFunction;
        
        topPart = new KbSprite(825, -30).createColorBlock(150, 100, 0xFF3F2421);
        
        for(i in 0...GameValues.getMaxSpikePartCount()){
            var bottomPart:KbSprite = new KbSprite().createColorBlock(20, 20, FlxColor.PINK);
            bottomPart.setPosition(topPart.x + ((topPart.width / GameValues.getMaxSpikePartCount()) * i) - bottomPart.width / 2 + ((topPart.width / GameValues.getMaxSpikePartCount()) / 2), topPart.y + topPart.height);
            bottomPart.ID = i;
            add(bottomPart);
            bottomParts.push(bottomPart);
        }
        
        add(topPart);

        depositHere = new KbSprite().createColorBlock(200, Std.int(topPart.height + 60), FlxColor.RED);
        depositHere.alpha = 0;
        depositHere.x = topPart.x + topPart.width / 2 - depositHere.width / 2;
        add(depositHere);
    }
    
    override function update(elapsed:Float):Void{
        super.update(elapsed);
        
        if(!shooting){
            for(part in bottomParts){
                if(part.ID + 1 <= partCount){
                    part.alpha = 1;
                } else {
                    part.alpha = .3;
                }
            }   
        }
        
        if(partCount >= GameValues.getMaxSpikePartCount()){
            ready = true;
        } else {
            ready = false;
        }
    }
    
    public function depositPart():Bool
    {
        if(shooting) return false;
        
        if(partCount < GameValues.getMaxSpikePartCount()){
            partCount ++;
            return true;
        } else {
            return false;
        }
    }
    
    public function shoot():Void{
        ready = false;
        shooting = true;
        partCount = 0;
        triggered = false;
        
        for(i in bottomParts){
            i.alpha = 1;
            PlayState.tweenManager.tween(i, {y: FlxG.height}, GameValues.getSpikingTime() / 2, {onUpdate: function(f):Void{
                if(i.y > 300 && !triggered){
                    timeLeft = (GameValues.getSpikingTime() / 2) + (GameValues.getSpikingTime() / 2 * (1 - (f.percent)));
                    hitFunction();
                    triggered = true;
                }
            }, onComplete: function(F):Void{
                i.y = (topPart.y + topPart.height) - i.height;
                i.alpha = .3;

                PlayState.tweenManager.tween(i, {y: topPart.y + topPart.height}, GameValues.getSpikingTime() / 2, {ease: FlxEase.quartOut, onComplete: function(F):Void{
                    shooting = false;
                }});
            }});
        }
    }
    
    public function shootWrong():Void{
        ready = false;
        shooting = true;
        partCount = 0;
        
        for(i in bottomParts){
            i.alpha = 1;
            PlayState.tweenManager.tween(i, {y: i.y + FlxG.random.float(30, 150), angle: FlxG.random.float(0, 360), alpha: 0}, GameValues.getSpikingTime() / 2, {onComplete: function(F):Void{
                i.y = (topPart.y + topPart.height) - i.height;
                i.alpha = .3;
                i.angle = 0;
                PlayState.tweenManager.tween(i, {y: topPart.y + topPart.height}, GameValues.getSpikingTime() / 2, {ease: FlxEase.quartOut, onComplete: function(F):Void{
                    shooting = false;
                }});
            }});
        }
    }
}