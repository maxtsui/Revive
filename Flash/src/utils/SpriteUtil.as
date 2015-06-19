package utils 
{
	import flash.display.Bitmap;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Max
	 */
	public class SpriteUtil 
	{
		
		public static function move(mc:DisplayObject, x:Number, y:Number):void
		{
			mc.x = x;
			mc.y = y;
		}
		
		public static function addChild(parent:DisplayObjectContainer, mc:DisplayObject, name:String, x:Number = 0, y:Number = 0):DisplayObject
		{
			parent.addChild(mc);
			mc.name = name;
			move(mc, x, y);
			return mc;
		}
		
		public static function getImage(cls:Class, touchable:Boolean = false):Image
		{
			var bitmap:Bitmap = new cls();
			var image:Image = Image.fromBitmap(bitmap, false, 0.5);
			bitmap.bitmapData.dispose();
			image.touchable = touchable;
			return image;
		}
	}

}