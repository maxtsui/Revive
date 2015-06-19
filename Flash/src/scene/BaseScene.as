package scene 
{
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	/**
	 * ...
	 * @author Max
	 */
	public class BaseScene extends Sprite
	{
		
		public function BaseScene() 
		{
			init();
		}
		
		protected function init():void
		{
			
		}
		
		public override function dispose():void
		{
			clearChildren(this);
			super.dispose();
		}
		
		private function clearChildren(container:DisplayObjectContainer):void
		{
			while (container.numChildren)
			{
				var obj:DisplayObject = container.removeChildAt(0, true);
				if (obj is Image)
				{
					(obj as Image).texture.base.dispose();
				}
				if (obj is DisplayObjectContainer)
				{
					clearChildren(obj as DisplayObjectContainer);
				}
			}
		}
	}

}