//package scene 
//{
	//import starling.text.TextField;
	//import utils.*;
	//import core.Assets;
	//import starling.display.Sprite;
	//import starling.events.TouchEvent;
	//import core.DataEvent;
	//import core.GameCore;
	//import starling.events.Touch;
	//import starling.events.TouchPhase;
	//
	///**
	 //* ...
	 //* @author Max
	 //*/
	//public class ResultScene extends BaseScene
	//{
		//public static const GO_TO_LOBBY:String = "gotoLobby";
		//private var groupSprite:Sprite;
		//private var txtPerfect:TextField;
		//private var txtGood:TextField;
		//private var txtMiss:TextField;
		//private var txtLife:TextField;
		//private var txtScroe:TextField;
		//
		//public function ResultScene() 
		//{
			//
		//}
		//
		//override protected function init():void 
		//{
			//SpriteUtil.addChild(this, SpriteUtil.getImage(Assets.RESULT_BG), "bg");
			//SpriteUtil.addChild(this, SpriteUtil.getImage(Assets.RESULT_PERFECT), "perfect", 172, 331);
			//SpriteUtil.addChild(this, SpriteUtil.getImage(Assets.RESULT_GOOD), "good", 179, 443);
			//SpriteUtil.addChild(this, SpriteUtil.getImage(Assets.RESULT_MISS), "miss", 200, 540);
			//SpriteUtil.addChild(this, SpriteUtil.getImage(Assets.RESULT_LIFE), "life", 170, 639);
			//SpriteUtil.addChild(this, SpriteUtil.getImage(Assets.RESULT_SCORE), "life", 43, 750);
			//SpriteUtil.addChild(this, SpriteUtil.getImage(Assets.RESULT_BTN), "btnBack", 263, 1123);
			//SpriteUtil.addChild(this, TextFieldUtil.getTextField(40, "Episode 1.0", 200, 50, 0xFF0000), "txtTitle", 200, 108);
			//this.txtPerfect = TextFieldUtil.getTextField(60, "32");
			//this.txtGood = TextFieldUtil.getTextField(60, "23");
			//this.txtMiss = TextFieldUtil.getTextField(60, "5");
			//this.txtLife = TextFieldUtil.getTextField(60, "80%");
			//this.txtScroe = TextFieldUtil.getTextField(60, "324125");
			//SpriteUtil.addChild(this, this.txtPerfect, "txtPerfect", 387, 327);
			//SpriteUtil.addChild(this, this.txtGood, "txtGood", 397, 455);
			//SpriteUtil.addChild(this, this.txtMiss, "txtMiss", 407, 546);
			//SpriteUtil.addChild(this, this.txtLife, "txtLife", 357, 660);
			//SpriteUtil.addChild(this, this.txtScroe, "txtScroe", 315, 771);
			//this.addEventListener(TouchEvent.TOUCH, onClick);
		//}
		//
		//override public function dispose():void 
		//{
			//this.removeEventListener(TouchEvent.TOUCH, onClick);
			//super.dispose();
		//}
		//
		//private function onClick(e:TouchEvent):void
		//{
			//var touch:Touch = e.getTouch(GameCore.STAGE, TouchPhase.ENDED);
			//if (touch)
			//{
				//switch(touch.target.name)
				//{
					//case "btnBack":
						//this.dispatchEvent(new DataEvent( { action: GO_TO_LOBBY } ));
						//break;
				//}
			//}
		//}
	//}
//
//}