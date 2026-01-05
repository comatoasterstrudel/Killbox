package killbox.game.pause;

/**
 * the data for options on the pause menu
 */
typedef PauseOption = {
    /**
     * the text that appears on the buttom
     */
    var name:String;
    
    /**
     * the function that should be ran when the button is clicked
     */
    var onClick:Void->Void;
    
    /**
     * should clicking this button close the menu?
     */
    var close:Bool;
    
    /**
     * should this button be pressed if the pause button is pressed while on the pause menu?
     */
    var pressEscape:Bool;
}