package scene 
{
	import core.Assets;
	import core.DataEvent;
	import core.GameCore;
	import flash.utils.setTimeout;
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import utils.SpriteUtil;
	import utils.SoundUtil;
	
	/**
	 * ...
	 * @author Max
	 */
	public class HomeScene extends BaseScene
	{
		public static const GO_TO_LOBBY:String = "gotoLobby"
		
		public function HomeScene() 
		{
	 		
		}
		
		override protected function init():void 
		{
			this.addChild(SpriteUtil.getImage(Assets.HOME_BG, true));
			var img:Image = SpriteUtil.getImage(Assets.HOME_TOUCH);
			img.scaleX = 1.8;
			img.scaleY = 1.8;
			SpriteUtil.addChild(this, img, "imgTouch", -60, 900) as Image;
			GameCore.STAGE.addEventListener(TouchEvent.TOUCH, onClick);
		}
		
		override public function dispose():void 
		{
			super.dispose();
		}
		
		private function onClick(e:TouchEvent):void
		{
			 var touch:Touch = e.getTouch(this, TouchPhase.ENDED);
			 if (touch)
			 {
				//SoundUtil.playSound(Assets.SOUND_CLICK, 3);
				 GameCore.STAGE.removeEventListener(TouchEvent.TOUCH, onClick);
				setTimeout(dispatchEvent, 500, new DataEvent( { action: GO_TO_LOBBY } ));
			 }
		}
	}

}