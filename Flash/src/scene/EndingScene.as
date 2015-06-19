package scene 
{
	import flash.display.BitmapData;
	import core.GameCore;
	import flash.geom.Rectangle;
	import starling.display.Image;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import utils.SpriteUtil;
	import utils.TextFieldUtil;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import flash.utils.setTimeout;
	import core.DataEvent;
	/**
	 * ...
	 * @author Max
	 */
	public class EndingScene extends BaseScene
	{
		private var sprT1:Sprite = new Sprite();
		private var sprT2:Sprite = new Sprite();
		private var sprT3:Sprite = new Sprite();
		private var sprT4:Sprite = new Sprite();
		private var sprT5:Sprite = new Sprite();
		private var sprT6:Sprite = new Sprite();
		private var listText:Vector.<Sprite> = Vector.<Sprite>([]);
		
		public function EndingScene() 
		{
			
		}
		
		override protected function init():void 
		{
			var bg:flash.display.Sprite = new flash.display.Sprite();
			bg.graphics.beginFill(0x000000);
			bg.graphics.drawRect(0, 0, GameCore.SIZE.x + 10, GameCore.SIZE.y);
			bg.graphics.endFill();
			var bitmapData:BitmapData = new BitmapData(GameCore.SIZE.x + 10, GameCore.SIZE.y);
			bitmapData.draw(bg);
			var imgBG:Image = new Image(Texture.fromBitmapData(bitmapData));
			imgBG.x = -5;
			bitmapData.dispose();
			this.addChild(imgBG);
			
			this.sprT1.addChild(TextFieldUtil.getTextField(45, "Congraduation!", 700, 100, 0xFFFFFF, false, HAlign.LEFT));
			this.sprT2.addChild(TextFieldUtil.getTextField(45, "Could you enjoy playing through all the levels?", 700, 100, 0xFFFFFF, false, HAlign.LEFT));
			this.sprT3.addChild(TextFieldUtil.getTextField(45, "Maybe you can try getting S rank in all levels,", 700, 100, 0xFFFFFF, false, HAlign.LEFT));
			this.sprT4.addChild(TextFieldUtil.getTextField(45, "that should be a great challenge!", 700, 100, 0xFFFFFF, false, HAlign.LEFT));
			this.sprT5.addChild(TextFieldUtil.getTextField(45, "Thankyou for playing! We will improve this game", 700, 100, 0xFFFFFF, false, HAlign.LEFT));
			this.sprT6.addChild(TextFieldUtil.getTextField(45, "to a larger scale, with many routes and multiplay mode!", 700, 100, 0xFFFFFF, false, HAlign.LEFT));
			SpriteUtil.addChild(this, this.sprT1, "t1", 20, 350);
			SpriteUtil.addChild(this, this.sprT2, "t2", 20, 450);
			SpriteUtil.addChild(this, this.sprT3, "t3", 20, 550);
			SpriteUtil.addChild(this, this.sprT4, "t4", 20, 600);
			SpriteUtil.addChild(this, this.sprT5, "t5", 20, 700);
			SpriteUtil.addChild(this, this.sprT6, "t6", 20, 750);
			this.sprT1.clipRect = new Rectangle(0, 0, 0, 0);
			this.sprT2.clipRect = new Rectangle(0, 0, 0, 0);
			this.sprT3.clipRect = new Rectangle(0, 0, 0, 0);
			this.sprT4.clipRect = new Rectangle(0, 0, 0, 0);
			this.sprT5.clipRect = new Rectangle(0, 0, 0, 0);
			this.sprT6.clipRect = new Rectangle(0, 0, 0, 0);
			listText.push(this.sprT1);
			listText.push(this.sprT2);
			listText.push(this.sprT3);
			listText.push(this.sprT4);
			listText.push(this.sprT5);
			listText.push(this.sprT6);
			this.addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
		}
		
		override public function dispose():void 
		{
			super.dispose();
		}
		
		private function onEnterFrame(e:Event):void
		{
			for (var i:int = 0; i < listText.length; i++)
			{
				var sprT:Sprite = listText[i];
				var tf:TextField = sprT.getChildAt(0) as TextField;
				if (sprT.clipRect.width < tf.width)
				{
					sprT.clipRect = new Rectangle(0, 0, sprT.clipRect.width + 5, tf.height);
					return;
				}
			}
			this.removeEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
			GameCore.STAGE.addEventListener(TouchEvent.TOUCH, onClick);
		}
		
		private function onClick(e:TouchEvent):void
		{
			 var touch:Touch = e.getTouch(this, TouchPhase.ENDED);
			 if (touch)
			 {
				GameCore.STAGE.removeEventListener(TouchEvent.TOUCH, onClick);
				setTimeout(dispatchEvent, 500, new DataEvent( { action: "gotoLobby" } ));
			 }
		}
	}

}