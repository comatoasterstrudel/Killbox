package killbox.game.night.rooms.right;

class BoxVacuum extends FlxSpriteGroup
{
    var pipe:FlxSprite;
    var particleGroup1:FlxSpriteGroup;
    public var boxGroup:FlxSpriteGroup;
    var particleGroup2:FlxSpriteGroup;
    
    public var sucking:Bool = false;
    
    var boxCounter:BoxCounter;
    
    public function new(room:Room):Void{
        super();
        
        particleGroup2 = new FlxSpriteGroup();
        add(particleGroup2);
        
        boxGroup = new FlxSpriteGroup();
        add(boxGroup);
        
        boxCounter = new BoxCounter(room, boxGroup, 30);
		add(boxCounter);
        
        particleGroup1 = new FlxSpriteGroup();
        add(particleGroup1);
        
        pipe = new FlxSprite().loadGraphic('assets/images/night/rooms/right/vaccuum.png');
        add(pipe);
    }
    
    override function update(elapsed:Float):Void{
        super.update(elapsed);
        
        pipe.scrollFactor.set(0.75, 0.75);
        particleGroup1.scrollFactor.set(0.5, 0.5);
        boxGroup.scrollFactor.set(0.6, 0.6);
        boxCounter.scrollFactor.set(0.6, 0.6);
        particleGroup2.scrollFactor.set(0.85, 0.85);
        
        if(boxGroup.members.length > 0){
            sucking = true;
        } else {
            sucking = false;
        }
        
        #if suckmeoffuntilimfuckingdead
        sucking = true;
        #end 
        
        if(sucking){
            if(FlxG.random.bool(25)){
                summonParticle();
            }
        }
    }
    
    function summonParticle():Void{        
        var back:Bool = FlxG.random.bool(50);
        var time = FlxG.random.float(.2, .8);
        
        var particle = new FlxSprite().loadGraphic('assets/images/night/rooms/right/vacuumParticle.png');
        particle.alpha = 0;
        particle.scale.set(FlxG.random.float(.8, 1.2), FlxG.random.float(0.8, 1.2));
        particle.setPosition(FlxG.random.float(900,1050), FlxG.random.float(100, 300));
        particle.angle = FlxAngle.angleBetween(particle, new FlxSprite(FlxG.width, 0), true);
        if(back) {
            particleGroup2.add(particle); 
            particle.color = FlxColor.GRAY;
        } else particleGroup1.add(particle);
        
        FlxTween.tween(particle.scale, {x: particle.scale.x + .2, y: particle.scale.y - .2}, time - 0.1, {ease: FlxEase.quartIn});
        FlxTween.tween(particle, {y: -particle.height, x: FlxG.width, alpha: FlxG.random.float(.4, .9)}, time, {ease: FlxEase.quartIn, onComplete: function(f):Void{
            if(back){
                particleGroup2.remove(particle, true);
            } else {
                particleGroup1.remove(particle, true);
            }
            particle.destroy();
        }});
    }
}