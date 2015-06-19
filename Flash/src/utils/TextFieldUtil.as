package utils 
{
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.HAlign;
	/**
	 * ...
	 * @author Max
	 */
	public class TextFieldUtil 
	{
		
		public static function getTextField(size:int, text:String, width:Number = 200, height:Number = 50, color:uint = 0xFFFFFF, touchable:Boolean = false, align:String = HAlign.CENTER):TextField
		{
			var tf:TextField = new TextField(100, 50, text, "Edwardian", size, color);
			tf.autoSize = TextFieldAutoSize.NONE;
			tf.width = width;
			tf.height = height;
			tf.touchable = touchable;
			tf.hAlign = align;
			return tf;
		}
		
	}

}