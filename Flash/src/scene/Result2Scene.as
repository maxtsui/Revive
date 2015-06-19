package scene 
{
	import starling.display.Image;
	import starling.text.TextField;
	import utils.*;
	import core.Assets;
	import starling.display.Sprite;
	import starling.events.TouchEvent;
	import core.DataEvent;
	import core.GameCore;
	import starling.events.Touch;
	import starling.events.TouchPhase;
	import starling.text.TextFieldAutoSize;
	import utils.SoundUtil;
	
	/**
	 * ...
	 * @author Max
	 */
	public class Result2Scene extends BaseScene
	{
		public static const GO_TO_LOBBY:String = "gotoLobby";
		private var id:int = 0;
		private var rank:int = 0;
		
		public function Result2Scene() 
		{
			
		}
		
		public function setResult(data:Object):void
		{
			var lblTitle:TextField = SpriteUtil.addChild(this, TextFieldUtil.getTextField(100, data.title, GameCore.SIZE.x, 150), "lblTitle", 0, 10) as TextField;
			var rank:Image;
			switch(data.rank)
			{
				case "S":
					rank = SpriteUtil.getImage(Assets.RESULT2_S);
					break;
				case "A":
					rank = SpriteUtil.getImage(Assets.RESULT2_A);
					break;
				case "B":
					rank = SpriteUtil.getImage(Assets.RESULT2_B);
					break;
				case "C":
					rank = SpriteUtil.getImage(Assets.RESULT2_C);
					break;
				case "F":
					rank = SpriteUtil.getImage(Assets.RESULT2_F);
			}
			rank.pivotX = rank.width / 2;
			rank.pivotY = rank.height / 2;
			if (rank)
			{
				SpriteUtil.addChild(this, rank, "txtRank", 370, 250);
			}
			SpriteUtil.addChild(this, TextFieldUtil.getTextField(50, data.perfect.toString() + "(" + data.perfect_p.toString() + "%)"), "txtPerfect", 270, 540);
			SpriteUtil.addChild(this, TextFieldUtil.getTextField(50, data.good.toString() + "(" + data.good_p.toString() + "%)"), "txtGood", 67, 700);
			SpriteUtil.addChild(this, TextFieldUtil.getTextField(50, data.miss.toString() + "(" + data.miss_p.toString() +"%)"), "txtMiss", 495, 690);
			SpriteUtil.addChild(this, TextFieldUtil.getTextField(50, data.maxCombo.toString()), "txtCombo", 260, 815);
			SpriteUtil.addChild(this, TextFieldUtil.getTextField(90, data.score.toString(), 400, 90, 0x4c553d), "txtScore", 300, 950);
			if (data.unlock)
			{
				SpriteUtil.addChild(this, SpriteUtil.getImage(Assets.RESULT2_UNLOCKED), "imgUnlock", 0, 1232);
			}
			this.id = data.id;
			this.rank = data.rank;
		}
		
		override protected function init():void 
		{
			SpriteUtil.addChild(this, SpriteUtil.getImage(Assets.RESULT2_BG), "bg");
			SpriteUtil.addChild(this, SpriteUtil.getImage(Assets.RESULT2_TITLE_BG), "title_bg", 0, 25);
			SpriteUtil.addChild(this, SpriteUtil.getImage(Assets.RESULT2_DATA_BG), "data_bg", 0, 360);
			SpriteUtil.addChild(this, TextFieldUtil.getTextField(80, "Back", 200, 80, 0xFFFFFF, true), "btnBack", 250, 1100);
			SpriteUtil.addChild(this, TextFieldUtil.getTextField(50, "Rank", 200, 50, 0x4C5440), "lblRank", -40, 320);
			SpriteUtil.addChild(this, TextFieldUtil.getTextField(150, "Perfect", 500, 150), "lblPerfect", 110, 400);
			SpriteUtil.addChild(this, TextFieldUtil.getTextField(100, "Good", 300, 120), "lblGood", 18, 590);
			SpriteUtil.addChild(this, TextFieldUtil.getTextField(75, "Miss", 300, 75), "lblMiss", 440, 610);
			SpriteUtil.addChild(this, TextFieldUtil.getTextField(70, "Max Combo", 400, 100), "lblCombo", 190, 740);
			SpriteUtil.addChild(this, TextFieldUtil.getTextField(100, "Score", 300, 100, 0x4c553d), "lblScore", 20, 940);
			this.addEventListener(TouchEvent.TOUCH, onClick);
		}
		
		override public function dispose():void 
		{
			SoundUtil.stopSound();
			super.dispose();
		}
		
		private function onClick(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this, TouchPhase.BEGAN);
			if (touch)
			{
				switch(touch.target.name)
				{
					case "btnBack":
						//SoundUtil.playSound(Assets.SOUND_CLICK, 3);
						this.removeEventListener(TouchEvent.TOUCH, onClick);
						if (this.id == 10 && this.rank > 0)
							this.dispatchEvent(new DataEvent( { action: "gotoEnd" } ));
						else
							this.dispatchEvent(new DataEvent( { action: GO_TO_LOBBY } ));
						break;
				}
			}
		}
	}

}