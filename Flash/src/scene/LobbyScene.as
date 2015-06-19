package scene 
{
	import com.greensock.easing.Linear;
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import comp.StarScore;
	import core.Assets;
	import core.DataEvent;
	import core.GameCore;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.SQLEvent;
	import flash.geom.Rectangle;
	import flash.media.SoundChannel;
	import flash.utils.setTimeout;
	import org.gestouch.events.GestureEvent;
	import org.gestouch.gestures.SwipeGesture;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.extensions.PDParticleSystem;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import utils.*;
	import utils.SqliteUtil;
	
	/**
	 * ...
	 * @author Max
	 */
	public class LobbyScene extends BaseScene
	{
		public static const GO_TO_GAME:String = "gotoGame";
		public static var HP:int = 5;
		public static var RECOVERTIME:int = 120000;
		private var txtTitle:TextField;
		private var txtName:TextField;
		private var txtScore:TextField;
		private var txtHeader:TextField;
		private var btnDown:Image;
		private var btnUp:Image;
		private var btnPlay:Image;
		private var starScore:StarScore;
		private var wordBG:Image;
		private var sprText:Sprite;
		private var listTimeline:Array = [];
		private var nextPageTimeline:TimelineLite;
		private var psBG:PDParticleSystem;
		private var bg:Image;
		private var imgLock:Image;
		private var swipe:SwipeGesture;
		private var channel:SoundChannel;
		private var listHP:Vector.<Image> = Vector.<Image>([]);
		private var txtLife:TextField;
		private var txtTime:TextField;
		private var now:Number = 0;
		
		private static var currentIndex:int = 0;
		
		private var data:Array = [
									{ id: 1, title: "The time is out of joint, cursed spite, that ever I was born to set it right!", name: "Desertification", star: 1, score:0, sound: Assets.EP1_SOUND, dat: Assets.EP1_DAT, bg1: SpriteUtil.getImage(Assets.EP1_BG), bg2: Assets.EP1_BG2, lock: 0, unlock:1 },
									{ id: 2, title: "All that glisters is not gold. While there is life, there is hope.", name: "Make a wish", star: 2, score:0, sound: Assets.EP2_SOUND, dat: Assets.EP2_DAT, bg1: SpriteUtil.getImage(Assets.EP2_BG), bg2: Assets.EP2_BG2, lock: 1, unlock:1 },
									{ id: 3, title: "It's a cruel and random world, but the chaos is all so beautiful.", name: "Magic", star: 4, score:0, sound: Assets.EP3_SOUND, dat: Assets.EP3_DAT, bg1: SpriteUtil.getImage(Assets.EP3_BG), bg2: Assets.EP3_BG2, lock: 1, unlock:2 },
									{ id: 4, title: "Miracles, magic...they are real... To be or not to be: that is the question.", name: "Wonderful", star: 3, score:0, sound: Assets.EP4_SOUND, dat: Assets.EP4_DAT, bg1: SpriteUtil.getImage(Assets.EP4_BG), bg2: Assets.EP4_BG2, lock: 1, unlock:2 },
									{ id: 5, title: "Truly and deeply, thank you for giving my life to me.", name: "Revive", star: 3, score:0, sound: Assets.EP5_SOUND, dat: Assets.EP5_DAT, bg1: SpriteUtil.getImage(Assets.EP5_BG), bg2: Assets.EP5_BG2, lock: 1, unlock:2 },
									{ id: 6, title: "Now that I think about it, I really didn't understand anything back then. Neither what it meant to pray for a miracle...nor the price of one.", name: "A brighter future", star: 5, score:0, sound: Assets.EP6_SOUND, dat: Assets.EP6_DAT, bg1: SpriteUtil.getImage(Assets.EP6_BG), bg2: Assets.EP6_BG2, lock: 1, unlock:3 },
									{ id: 7, title: "So the winter went by, and spring came along.", name: "Circulation", star: 4, score:0, sound: Assets.EP7_SOUND, dat: Assets.EP7_DAT, bg1: SpriteUtil.getImage(Assets.EP7_BG), bg2: Assets.EP7_BG2, lock: 1, unlock:3 },
									{ id: 8, title: "Nature is in its full bloom, and there is nothing left that reminds you of the hard cold days.", name: "The Apple", star: 4, score:0, sound: Assets.EP8_SOUND, dat: Assets.EP8_DAT, bg1: SpriteUtil.getImage(Assets.EP8_BG), bg2: Assets.EP8_BG2, lock: 1, unlock:3 },
									{ id: 9, title: "The days keep passing by... And we still chase the same star we once saw.", name: "Repetition", star: 3, score:0, sound: Assets.EP9_SOUND, dat: Assets.EP9_DAT, bg1: SpriteUtil.getImage(Assets.EP9_BG), bg2: Assets.EP9_BG2, lock: 1, unlock:4 },
									{ id: 10, title: "We will return to where we belong, one sunny day.", name: "Brilliant Years", star: 5, score:0, sound: Assets.EP10_SOUND, dat: Assets.EP10_DAT, bg1: SpriteUtil.getImage(Assets.EP10_BG), bg2: Assets.EP10_BG2, lock: 1, unlock:99 }
								 ];
		
		public function LobbyScene() 
		{
			
		}
		
		override protected function init():void 
		{
			this.sprText = new Sprite();
			var imgBG:Image = this.addChild(SpriteUtil.getImage(Assets.LOBBY_BG, true)) as Image;
			wordBG = SpriteUtil.getImage(Assets.LOBBY_WORD_BG);
			SpriteUtil.addChild(this, wordBG, "bg", GameCore.SIZE.x, 338);
			this.addChild(sprText);
			imgLock = SpriteUtil.getImage(Assets.LOBBY_LOCKED);
			this.swipe = new SwipeGesture(imgBG);
			this.clipRect = new Rectangle(0, 0, GameCore.SIZE.x, GameCore.SIZE.y);
			SpriteUtil.addChild(this, SpriteUtil.getImage(Assets.LOBBY_LIFE_BG), "life_bg", 0, 0);
			for (var i:int = 0; i < 3; i++)
			{
				listHP.push(SpriteUtil.addChild(this, SpriteUtil.getImage(Assets.LOBBY_LIFE), "hp", i * 60, 10));
			}
			this.txtLife = SpriteUtil.addChild(this, TextFieldUtil.getTextField(50, "Life: 3/3", 300, 50, 0x4c553d, false, HAlign.LEFT), "txtLife", 5, 78) as TextField;
			this.txtTime = SpriteUtil.addChild(this, TextFieldUtil.getTextField(50, "Recovering: 5:23", 400, 60, 0x4c553d, false, HAlign.LEFT), "txtTime", 5, 130) as TextField;
			var sql:SQLStatement = SqliteUtil.getHP();
			sql.addEventListener(SQLEvent.RESULT, onSqlHPResult);
			sql.execute();
		}
		
		private function init2():void
		{
			var config:XML = XML(new Assets.LEAVE_CONFIG());
			var bitmap:Bitmap = new Assets.LEAVE_PARTICLE();
			var texture:Texture = Texture.fromBitmap(bitmap);
			this.psBG = new PDParticleSystem(config, texture);
			Starling.juggler.add(this.psBG);
			this.psBG.x = GameCore.SIZE.x;
			this.psBG.y = 500;
			this.psBG.start();
			this.addChild(this.psBG);
			bitmap.bitmapData.dispose();
			
			var sql:SQLStatement = SqliteUtil.getData();
			sql.addEventListener(SQLEvent.RESULT, onSqlResult);
			sql.execute();
			
			//this.channel = SoundUtil.playSound(Assets.SOUND_LOBBY, 1);
			//this.channel.addEventListener(Event.SOUND_COMPLETE, onSoundEnd);
			this.addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
		}
		
		override public function dispose():void
		{
			for each(var tl:TimelineLite in listTimeline)
			{
				tl.stop();
			}
			Starling.juggler.remove(this.psBG);
			this.psBG.stop();
			this.psBG.dispose();
			this.psBG.texture.base.dispose();
			TweenLite.killTweensOf(this.txtTitle);
			if (nextPageTimeline)
			{
				nextPageTimeline.stop();
			}
			for each (var obj:Object in data)
			{
				(obj.bg1 as Image).texture.base.dispose();
				(obj.bg1 as Image).dispose();
			}
			super.dispose();
			this.imgLock.dispose();
			this.imgLock.texture.base.dispose();
			this.swipe.removeEventListener(GestureEvent.GESTURE_RECOGNIZED, onSwipe);
			this.swipe.dispose();
			if (this.channel)
			{
				this.channel.removeEventListener(Event.SOUND_COMPLETE, onSoundEnd);
				SoundUtil.stopSound(1);
			}
			this.removeEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
		}
		
		private function onReady():void
		{
			this.txtHeader = SpriteUtil.addChild(sprText, TextFieldUtil.getTextField(80, "Episode 1", 400, 100, 0x4c553d), "title", 20, 725) as TextField;
			this.txtHeader.hAlign = HAlign.LEFT;
			txtTitle = TextFieldUtil.getTextField(100, "", GameCore.SIZE.x, 180);
			SpriteUtil.addChild(sprText, txtTitle, "soundTitle", 0, 356);
			txtName = TextFieldUtil.getTextField(50, "", 200, 50);
			SpriteUtil.addChild(sprText, txtName, "soundName", 358, 552);
			txtName.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			btnDown = SpriteUtil.getImage(Assets.LOBBY_ARROW, true);
			btnDown.scaleX = -1;
			SpriteUtil.addChild(this, btnDown, "btnDown", 80, 620);
			btnUp = SpriteUtil.getImage(Assets.LOBBY_ARROW, true);
			SpriteUtil.addChild(this, btnUp, "btnUp", 670, 620);
			SpriteUtil.addChild(sprText, TextFieldUtil.getTextField(60, "Highest Score", 400, 80, 0x4c553d), "soundScore", 30, 923);
			txtScore = TextFieldUtil.getTextField(70, "652000", 400, 80, 0x4c553d);
			SpriteUtil.addChild(sprText, txtScore, "txtScore", 340, 922);
			starScore = new StarScore();
			SpriteUtil.addChild(sprText, starScore, "starScore", 270, 845);
			shakeItem(this.btnDown);
			setTimeout(shakeItem, 500, this.btnUp);
			this.sprText.alpha = 0;
			TweenLite.to(this.sprText, 0.5, { alpha: 1 } );
			btnPlay = SpriteUtil.addChild(this, SpriteUtil.getImage(Assets.LOBBY_BTN_PLAY, true), "btnPlay", 260, 1050) as Image;
			btnPlay.scaleX = 1.5;
			btnPlay.scaleY = 1.5;
			GameCore.STAGE.addEventListener(TouchEvent.TOUCH, onClick);
			this.update();
			this.swipe.addEventListener(GestureEvent.GESTURE_RECOGNIZED, onSwipe);
		}
		
		private function onClick(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(GameCore.STAGE, TouchPhase.ENDED);
			
			if (touch)
			{
				switch(touch.target.name)
				{
					case "btnPlay":
						if (HP > 0)
						{
							//SoundUtil.playSound(Assets.SOUND_CLICK, 3);
							GameCore.STAGE.removeEventListener(TouchEvent.TOUCH, onClick);
							SqliteUtil.updateHP(HP - 1, RECOVERTIME, (new Date()).time);
							this.dispatchEvent(new DataEvent( { action: GO_TO_GAME, data: data[currentIndex] } ));
						}
						break;
					case "btnDown":
						//SoundUtil.playSound(Assets.SOUND_CLICK, 3);
						upPage();
						break;
					case "btnUp":
						//SoundUtil.playSound(Assets.SOUND_CLICK, 3);
						downPage();
						break;
				}
			}
		}
		
		private function upPage():void
		{
			if (currentIndex - 1 >= 0)
			{
				currentIndex = Math.max(0, currentIndex - 1);
				nextPage();
			}
		}
		
		private function downPage():void
		{
			if (currentIndex + 1 < data.length)
			{
				currentIndex = Math.min(data.length - 1, currentIndex + 1);
				nextPage();
			}
		}
		
		private function update():void
		{
			var obj:Object = data[currentIndex];
			txtTitle.text = obj.name;
			txtName.text = obj.title;
			txtScore.text = obj.score.toString();
			txtHeader.text = "Episode " + obj.id.toString();
			starScore.setScore(obj.star);
			runTitle();
			if (bg && bg.parent)
			{
				bg.parent.removeChild(bg);
			}
			bg = obj.bg1;
			bg.alpha = 1;
			this.addChildAt(bg, Math.min(this.numChildren, 1));
			SpriteUtil.move(bg, 140, 410);
			if (obj.lock)
			{
				txtName.text = "Try " + this.getRankName(data[currentIndex - 1].unlock) + " rank in previous episode to unlock";
				this.addChildAt(imgLock, Math.min(this.numChildren, 2));
				SpriteUtil.move(imgLock, 235, 520);
				this.imgLock.alpha = 1;
				bg.alpha = 0.5;
			}
			else
			{
				btnPlay.visible = true;
			}
		}
		
		private function getRankName(rank:int):String
		{
			var name:String = "F";
			switch(rank)
			{
				case 1:
					name = "C";
					break;
				case 2:
					name = "B";
					break;
				case 3:
					name = "A";
					break;
				case 4:
					name = "S";
					break;
			}
			return name;
		}
		
		private function runTitle():void
		{
			TweenLite.killTweensOf(this.txtName);
			this.txtName.x = 750;
			TweenLite.to(this.txtName, 10, { x: -txtName.width, ease: Linear.easeIn, onComplete: runTitle } );
		}
		
		private function onSqlResult(e:Event):void
		{
			var sql:SQLStatement = e.currentTarget as SQLStatement;
			sql.removeEventListener(SQLEvent.RESULT, onSqlResult);
			var result:SQLResult = sql.getResult();
			for each (var row:Object in result.data)
			{
				var a:Object;
				for each(var item:Object in data)
				{
					if (item.id == row.id)
					{
						item.score = row.score;
						item.lock = row.lock;
						if (item.lock == 0 && a != null)
						{
							a.unlock = 99;
						}
						break;
					}
					//item.lock = 0;
					a = item;
				}
			}
			TweenLite.to(wordBG, 0.6, { x: 0, ease: Linear.easeIn, delay:1.5, onComplete: onReady } );
		}
		
		private function onSqlHPResult(e:Event):void
		{
			var sql:SQLStatement = e.currentTarget as SQLStatement;
			sql.removeEventListener(SQLEvent.RESULT, onSqlHPResult);
			var result:SQLResult = sql.getResult();
			var endTime:Number = 0;
			for each (var row:Object in result.data)
			{
				endTime = row.endTime;
				RECOVERTIME = row.recoverTime;
				HP = row.hp;
				trace(endTime, RECOVERTIME, HP);
			}
			this.now = (new Date()).time;
			var diff:Number = this.now - endTime + Math.min(0, 120000 - RECOVERTIME);
			HP = Math.min(HP + diff / 120000, 3);
			if (HP < 3)
			{
				RECOVERTIME -= diff % 120000;
			}
			else
			{
				RECOVERTIME = 120000;
			}
			trace(RECOVERTIME, diff, (this.now - endTime));
			init2();
			this.updateHP();
			this.updateRecoverTime();
		}
		
		private function updateHP():void 
		{
			for (var i:int = 0; i < listHP.length; i++)
			{
				listHP[i].visible = HP > i;
			}
			this.txtLife.text = "Life: " + HP.toString() + "/3";
		}
		
		private function updateRecoverTime():void
		{
			if (HP < 3)
			{
				var m:int = Math.floor(RECOVERTIME / 60000);
				var s:int = Math.floor(RECOVERTIME % 60000 / 1000);
				this.txtTime.text = "Recovering: " + m.toString() + ":" + s.toString();
			}
			else
			{
				this.txtTime.text = "";
			}
		}
		
		private function shakeItem(item:Image):void
		{
			var tl:TimelineLite = new TimelineLite( { onComplete: function():void { tl.restart(); }} );
			tl.to(item, 0.5, { x:item.x + 10 } );
			tl.to(item, 0.5, { x:item.x - 10 } );
			tl.play();
			listTimeline.push(tl);
		}
		
		private function nextPage():void
		{
			if (this.nextPageTimeline)
			{
				this.nextPageTimeline.stop();
			}
			this.nextPageTimeline = new TimelineLite();
			if (this.sprText.alpha != 0)
			{
				this.nextPageTimeline.to(sprText, 0.3, { alpha: 0 } );
			}
			this.nextPageTimeline.to(wordBG, 0.3, { alpha: 0, onComplete: function():void { wordBG.alpha = 1; wordBG.x = GameCore.SIZE.x; }} );
			this.nextPageTimeline.to(wordBG, 0.6, { x: 0, ease: Linear.easeIn, onComplete:update } );
			this.nextPageTimeline.to(sprText, 0.5, { alpha: 1 } );
			this.nextPageTimeline.play();
			TweenLite.killTweensOf(bg);
			TweenLite.to(bg, 0.3, { alpha: 0 } );
			if (imgLock.parent)
			{
				TweenLite.killTweensOf(imgLock);
				TweenLite.to(imgLock, 0.3, { alpha: 0, onComplete: function():void { imgLock.parent.removeChild(imgLock); } } );
			}
			btnPlay.visible = false;
		}
		
		private function onSwipe(e:GestureEvent):void
		{
			if (this.swipe.offsetX > 6)
			{
				upPage();
			}
			else if (swipe.offsetX < -6)
			{
				downPage();
			}
		}
		
		private function onSoundEnd(e:Event):void
		{
			this.channel.removeEventListener(Event.SOUND_COMPLETE, onSoundEnd);
			this.channel = SoundUtil.playSound(Assets.SOUND_LOBBY, 1);
			this.channel.addEventListener(Event.SOUND_COMPLETE, onSoundEnd);
		}
		
		private function onEnterFrame(e:EnterFrameEvent):void
		{
			if (HP < 3)
			{
				var time:Number = (new Date()).time;
				RECOVERTIME -= (time - this.now);
				if (RECOVERTIME <= 0)
				{
					HP = Math.min(3, HP + 1);
					RECOVERTIME = 120000;
					this.updateHP();
				}
				this.updateRecoverTime();
				this.now  = time;
			}
		}
	}

}