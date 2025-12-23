package killbox.shaders;

/**
 * THIS IS THE FIRST SHADER I CODED BY MYSELF -comatoasterstrudel 8/7/2025
 */
class MaskAlphaShader extends FlxShader
{
  public var swagSprX(default, set):Float = 0;
    
  public var swagSprY(default, set):Float = 0;

  public var frameUV(default, set):FlxRect;

  var sprite:FlxSprite;
  
  function set_swagSprX(x:Float):Float
  {
    sprX.value[0] = x;

    return x;
  }
  
  function set_swagSprY(y:Float):Float
  {
    sprY.value[0] = y;

    return y;
  }

  function set_frameUV(uv:FlxRect):FlxRect
  {
    trace("SETTING FRAMEUV");
    trace(uv);

    uvFrameX.value[0] = uv.x;
    uvFrameY.value[0] = uv.y;

    return uv;
  }

  @:glFragmentSource('
        #pragma header

        uniform float sprX;
        uniform float sprY;
        
        uniform float maskX;
        uniform float rightMaskX;

        uniform float maskY;
        uniform float bottomMaskY;
        
		    uniform float uvFrameX;
		    uniform float uvFrameY;

        uniform sampler2D maskTexture;

        void main()
        {
            vec2 uv = openfl_TextureCoordv.xy;
                
            vec4 color = flixel_texture2D(bitmap, uv.xy);

            vec4 maskthing = flixel_texture2D(maskTexture, vec2((openfl_TextureCoordv.x + (sprX / openfl_TextureSize.x) + uvFrameX) * ( openfl_TextureSize.x / 1280.0), (openfl_TextureCoordv.y + (sprY / openfl_TextureSize.y) + uvFrameY) * ( openfl_TextureSize.y / 720.0)));
            
            color = vec4(color.r * maskthing.a, color.g * maskthing.a, color.b * maskthing.a, color.a * maskthing.a);
                
            gl_FragColor = color;

        }
    ')
    
  /**
   * this is a shader that only renders a sprite inside of the pixels of a mask image!!
   * @param sprite the sprite youre applying the shader to
   * @param maskPath the path to the mask image youre using
   */
  public function new(sprite:FlxSprite, maskPath:String)
  {
    super();

    this.sprite = sprite;
    
    sprX.value = [0];
    sprY.value = [0];
    
    maskTexture.input = BitmapData.fromFile(maskPath);

    update();
  }
  
  public function update():Void
    {
        swagSprX = sprite.x;
        swagSprY = sprite.y;   
    }
}
