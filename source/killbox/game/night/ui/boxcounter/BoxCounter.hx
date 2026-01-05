package killbox.game.night.ui.boxcounter;

/**
 * a ui element to track boxes that are placed on top of eachother
 */
class BoxCounter extends FlxTypedSpriteGroup<BoxCounterLabel>
{   
    /**
     * sprites
     */
    var room:Room;
    var boxGroup:FlxSpriteGroup;
    
	/**
	 * the amount that the label is moved from the boxes
	 */
	var yOffset:Float;

	public function new(room:Room, boxGroup:FlxSpriteGroup, yOffset:Float = 100):Void {
        super();
        
        this.room = room;
        this.boxGroup = boxGroup;
		this.yOffset = yOffset;

        new FlxTimer().start(.5, function(tmr):Void{
            tmr.reset();
            updateGroups();
        });
    }

	/**
	 * call this to update the groupings of boxes,
     * this only gets updated every .5 seconds,
     * since its pretty costly.
	 */
	function updateGroups():Void {
		for (i in members) {
            i.kill();
        }
        if(room.roomActive){            
            var groupedBoxes:Array<Array<FlxSprite>> = [];
            
            for(box in boxGroup.members){
                var pos = new FlxPoint(box.x + (box.width / 2), box.y + (box.height / 2));
                
                for(newBox in boxGroup.members){
                    if(box.ID == newBox.ID) continue;
                    
                    if(FlxG.overlap(box, newBox)){
                        var matchedToGroup:Bool = false;
                        
                        for(i in groupedBoxes){
                            if(i.contains(box) || i.contains(newBox)){ //a group in this list already has these boxes
                                if(!i.contains(box)) i.push(box);
                                if(!i.contains(newBox)) i.push(newBox);
                                matchedToGroup = true;
                            }
                        }
                        
                        if(!matchedToGroup){
                            groupedBoxes.push([box, newBox]);
                        }
                    }
                }                
            }
            
            for(i in 0...groupedBoxes.length){
                if(members.length - 1 < i){ //there isnt a label for this group, so make one
					var label = new BoxCounterLabel(groupedBoxes[i], yOffset);
                    add(label);
                } else {
                    var label = members[i];
                    label.revive();
                    label.boxes = groupedBoxes[i];
                }
            }
            
			for (i in members) {
				if (!i.alive){
					i.bg.alpha = 0;
                    i.text.alpha = 0;
                }
			}
            
            groupedBoxes = [];            
        }
    }
}