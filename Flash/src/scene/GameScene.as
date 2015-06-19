package scene
{
	import com.greensock.easing.Linear;
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import core.Assets;
	import core.DataEvent;
	import core.GameCore;
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.extensions.ColorArgb;
	import starling.extensions.PDParticleSystem;
	import starling.filters.ColorMatrixFilter;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import utils.*;
	import flash.display.BitmapData;
	
	/**
	 * ...
	 * @author Max
	 */
	public class GameScene extends BaseScene
	{
		public static const GO_TO_RESULT:String = "gotoResult";
		private static const NOTE_TIME:int = 2000;
		
		private var data:Object;
		private var listNoteMc:Array = [];
		private var listExplosionMc:Array = [];
		private var startTime:int;
		private var lastNoteTime:int;
		private var playNoteList:Dictionary = new Dictionary();
		private var currentIcon:DisplayObject;
		private var missIcon:Image;
		private var goodIcon:Image;
		private var perfectIcon:Image;
		private var preLayer:Sprite;
		private var psConfing:XML;
		private var psTexture:Texture;
		private var psConfing2:XML;
		private var noteList:Array;
		private var border:Image;
		private var borderAlphaHandler:uint;
		private var hpBar:Sprite;
		private var hp:Number = 100;
		private var score:int = 0;
		private var combo:int = 0;
		private var perfect:int = 0;
		private var good:int = 0;
		private var miss:int = 0;
		private var noteCount:int = 0;
		private var maxCombo:int = 0;
		private var txtScore:TextField;
		private var txtCombo:TextField;
		private var sprCombo:Sprite;
		private var listInterval:Array;
		private var imgMiss:Image;
		private var timelineMiss:TimelineLite;
		private var listTouchPoint:Dictionary = new Dictionary();
		private var maxScore:int = 0;
		private var hitEffect:Image;
		
		public function GameScene()
		{
			
		}
		
		public function startGame(data:Object):void
		{
			this.data = data;
			var bg:Image = SpriteUtil.getImage(data.bg2, true);
			bg.filter = new ColorMatrixFilter(Vector.<Number>([0.65,0,0,0,0,0,0.65,0,0,0,0,0,0.65,0,0,0,0,0,1,0]));
			preLayer.addChildAt(bg, 0);
			var txt:ByteArray = new data.dat();
			data.str = txt.toString();
			this.noteList = (this.data.str as String).split(",");
			this.noteList.sort(sortNote);
			setTimeout(playGame, NOTE_TIME - 500);
			startTime = getTimer();
			lastNoteTime = 0;
			nextNote();
		}
		
		override protected function init():void
		{
			this.preLayer = new Sprite();
			this.border = SpriteUtil.addChild(preLayer, SpriteUtil.getImage(Assets.PLAY_BORDER), "border", 0, 1050) as Image;
			this.missIcon = SpriteUtil.getImage(Assets.PLAY_MISS);
			this.goodIcon = SpriteUtil.getImage(Assets.PLAY_GOOD);
			this.perfectIcon = SpriteUtil.getImage(Assets.PLAY_PERFECT);
			GameCore.STAGE.addEventListener(TouchEvent.TOUCH, onClick);
			this.addChild(preLayer);
			
			this.psConfing = XML(new Assets.FIRE_CONFING());
			this.psConfing2 = XML(new Assets.FIRE_CONFING2());
			var bitmap:Bitmap = new Assets.FIRE_PARTICLE();
			this.psTexture = Texture.fromBitmap(bitmap);
			bitmap.bitmapData.dispose();
			SpriteUtil.addChild(preLayer, TextFieldUtil.getTextField(60, "Score", 200, 60), "lblScore", 80, 12);
			this.txtScore = SpriteUtil.addChild(preLayer, TextFieldUtil.getTextField(90, "0", 400, 90), "txtScore", 250, 0) as TextField;
			this.txtScore.hAlign = HAlign.LEFT;
			var hpbar_screen:Image = SpriteUtil.getImage(Assets.PLAY_HP_BAR_SCREEN);
			hpbar_screen.blendMode = BlendMode.ADD;
			SpriteUtil.addChild(preLayer, hpbar_screen, "hp_br_accessory", 0, -110);
			SpriteUtil.addChild(preLayer, SpriteUtil.getImage(Assets.PLAY_HP_BAR_BLACK_BG), "hp_bar_black", 20, 60);
			this.hpBar = new Sprite();
			this.hpBar.addChild(SpriteUtil.getImage(Assets.PLAY_HP_BAR));
			//this.hpBar.alpha = 0.8;
			SpriteUtil.addChild(preLayer, this.hpBar, "hp_bar", 35, 85);
			SpriteUtil.addChild(preLayer, SpriteUtil.getImage(Assets.PLAY_HP_BAR_ACCESSORY), "hp_bar_accessory", 0, 0);
			this.sprCombo = new Sprite();
			SpriteUtil.addChild(sprCombo, TextFieldUtil.getTextField(50, "Combo"), "lblCombo", 0, 115);
			this.txtCombo = SpriteUtil.addChild(sprCombo, TextFieldUtil.getTextField(130, "0", 400, 130), "txtCombo", -75) as TextField;
			SpriteUtil.addChild(preLayer, sprCombo, "combo", 250, 600);
			this.sprCombo.visible = false;
			borderAlphaHandler = setInterval(OnBorderAlpha, 1000);
			this.setHp(hp);
			imgMiss = SpriteUtil.addChild(preLayer, SpriteUtil.getImage(Assets.PLAY_MISS_EFFECT), "missEffect", 0, 595) as Image;
			imgMiss.blendMode = BlendMode.SCREEN;
			imgMiss.alpha = 0;
			this.timelineMiss = new TimelineLite();
			this.timelineMiss.to(imgMiss, 0.3, { alpha: 0.5 } );
			this.timelineMiss.to(imgMiss, 0.3, { alpha: 1 } );
			this.timelineMiss.to(imgMiss, 0.3, { alpha: 0 } );
			this.clipRect = new Rectangle(0, 0, GameCore.SIZE.x, GameCore.SIZE.y);
			SpriteUtil.addChild(this, SpriteUtil.getImage(Assets.PLAY_GIVEUP, true), "giveup", 620, 5);
			
			var spr:flash.display.Sprite = new flash.display.Sprite();
			spr.graphics.beginFill(0xFFFFFF);
			spr.graphics.drawRect(0, 0, 80, GameCore.SIZE.y);
			spr.graphics.endFill();
			var bitmapData:BitmapData = new BitmapData(80, GameCore.SIZE.y);
			bitmapData.draw(spr);
			var texture:Texture = Texture.fromBitmapData(bitmapData);
			hitEffect = new Image(texture);
			bitmapData.dispose();
			hitEffect.alpha = 0.4;
			hitEffect.touchable = false;
			preLayer.addChildAt(hitEffect, 5);
		}
		
		override public function dispose():void
		{
			super.dispose();
			GameCore.STAGE.removeEventListener(TouchEvent.TOUCH, onClick);
			clearInterval(borderAlphaHandler);
			for each(var node:PDParticleSystem in listNoteMc)
			{
				TweenLite.killTweensOf(node);
				node.stop(true);
				node.dispose();
			}
			goodIcon.dispose();
			goodIcon.texture.base.dispose();
			perfectIcon.dispose();
			perfectIcon.texture.base.dispose();
			missIcon.dispose();
			missIcon.texture.base.dispose();
			this.psTexture.base.dispose();
			timelineMiss.stop();
		}
		
		private function playGame():void
		{
			SoundUtil.playSound(data.sound);
		}
		
		private function nextNote():void
		{
			listInterval = [];
			while (this.noteList.length)
			{
				var str:String = this.noteList.shift();
				var note:Array = str.split(":");
				var time:int = int(note[1].substr(0, note[1].length - 1));
				var posX:Number = Number(note[0].substr(1)) * GameCore.SIZE.x / 100;
				var name:String = Math.floor(Math.random() * 1000)+":"+posX.toString()+":"+time.toString();
				listInterval.push(setTimeout(addNote, Math.max(time - lastNoteTime, 0), name, posX));
				this.lastNoteTime = 0;
				this.noteCount++;
				if (this.noteList.length == 0)
				{
					listInterval.push(setTimeout(gotoResult, time + 5000));
				}
				maxScore += 200 * (5.5 + Math.min(5, (this.noteCount / 50)));
			}
			trace("this.noteCount:" + this.noteCount, this.maxScore);
		}
		
		private function addNote(name:String, posX:Number = 0):void
		{
			var note:DisplayObject = getNote();
			note.name = name;
			SpriteUtil.move(note, posX, 0);
			preLayer.addChild(note);
			TweenLite.to(note, NOTE_TIME / 1000, {y: GameCore.SIZE.y, ease: Linear.easeIn, onComplete: function():void
				{
					if (note.parent)
					{
						note.parent.removeChild(note);
					}
					Starling.juggler.remove(playNoteList[note.name]);
					(note as PDParticleSystem).stop(true);
					delete(playNoteList[note.name]);
					showIcon(0);
					hp = Math.max(0, hp - 5);
					setHp(hp);
					combo = 0;
					setCombo(combo);
					miss++;
					listNoteMc.push(note);
					timelineMiss.restart();
				}});
			playNoteList[note.name] = note;
		}
		
		private function getNote():DisplayObject
		{
			var ps:PDParticleSystem;
			if (this.listNoteMc.length)
			{
				ps = this.listNoteMc.shift();
			}
			else
			{
				ps = new PDParticleSystem(this.psConfing, this.psTexture);
				ps.startColor = new ColorArgb(Math.random(), Math.random(), Math.random(), 0.6);
				ps.endColor = new ColorArgb(Math.random(), Math.random(), Math.random(), 0);
			}
			Starling.juggler.add(ps);
			ps.start();
			return ps;
		}
		
		private function getExplosion():PDParticleSystem
		{
			var ps:PDParticleSystem;
			if (this.listExplosionMc.length)
			{
				ps = this.listExplosionMc.shift();
			}
			else
			{
				ps = new PDParticleSystem(this.psConfing2, this.psTexture);
			}
			Starling.juggler.add(ps);
			ps.start(0.5);
			return ps;
		}
		
		private function showIcon(type:int):void
		{
			if (currentIcon)
			{
				TweenLite.killTweensOf(currentIcon);
				if (currentIcon.parent)
				{
					preLayer.removeChild(currentIcon);
				}
			}
			switch (type)
			{
				case 0: 
					currentIcon = missIcon;
					break;
				case 1: 
					currentIcon = goodIcon;
					break;
				case 2: 
					currentIcon = perfectIcon;
					break;
			}
			preLayer.addChild(currentIcon);
			SpriteUtil.move(currentIcon, 200, 1000);
			TweenLite.to(currentIcon, 1, {y: 900, alpha: 0.7, ease: Linear.easeIn, onComplete: function():void
				{
					if (currentIcon.parent)
						currentIcon.parent.removeChild(currentIcon);
				}});
		}
		
		private function onClick(e:TouchEvent):void
		{
			var touches:Vector.<Touch> = e.getTouches(GameCore.STAGE, TouchPhase.BEGAN);
			e.getTouches(GameCore.STAGE, TouchPhase.MOVED, touches);
			e.getTouches(GameCore.STAGE, TouchPhase.ENDED, touches);
			for each(var touch:Touch in touches)
			{
				checkTouch(touch);
				checkTouchMove(touch);
				
				//tmp
				switch(touch.phase)
				{
					case TouchPhase.BEGAN:
						this.hitEffect.visible = true;
						break;
					case TouchPhase.MOVED:
						var location:Point = touch.getLocation(this);
						this.hitEffect.x = location.x - 40;
						break;
					case TouchPhase.ENDED:
						this.hitEffect.visible = false;
						break;
				}
			}
		}
		
		private function checkTouch(touch:Touch):void
		{
			if (touch)
			{
				var time:int = getTimer();
				var location:Point = touch.getLocation(this);
				
				if (touch.target.name == "giveup")
				{
					SoundUtil.stopSound(0);
					this.dispatchEvent(new DataEvent( { action: "gotoLobby" } ));
				}
				
				if ((touch.phase == TouchPhase.BEGAN && Math.abs(1185 - location.y) < 100) || (touch.phase == TouchPhase.MOVED && Math.abs(1185 - location.y) < 60))
				{
					for each (var note:PDParticleSystem in playNoteList)
					{
						var score:int = Math.abs(1185 - note.y);
						if (score < 100)
						{
							if (location.x > note.x - 60 && location.x < note.x + 60)
							{
								hitNote(note, score);
								break;
							}
						}
					}
				}
			}
		}
		
		private function checkTouchMove(touch:Touch):void
		{
			var a:Point = touch.getLocation(this);
			if (listTouchPoint[touch.id] != null && Math.abs(1185 - a.y) < 100)
			{
				var b:Point = listTouchPoint[touch.id];
				for each (var note:PDParticleSystem in playNoteList)
				{
					if (Math.min(a.x, b.x) < note.x && Math.max(a.x, b.x) > note.x)
					{
						var posY:int = ((a.y - b.y) * (note.x - b.x) / (a.x - b.x)) + b.y;
						var isHit:Boolean = Math.abs(posY - note.y) < 50;
						var score:int = Math.abs(1185 - note.y);
						if (score < 100 && isHit)
						{
							hitNote(note, score);
						}
					}
				}
			}
			if (touch.phase == TouchPhase.ENDED)
			{
				delete(listTouchPoint[touch.id]);
			}
			else
			{
				listTouchPoint[touch.id] = a;
			}
		}
		
		private function hitNote(note:PDParticleSystem, score:int):void
		{
			TweenLite.killTweensOf(note);
			preLayer.removeChild(note);
			(note as PDParticleSystem).stop(true);
			Starling.juggler.remove(note);
			delete(playNoteList[note.name]);
			this.listNoteMc.push(note);
			var effect:PDParticleSystem = getExplosion();
			effect.startColor = note.startColor;
			effect.endColor = note.endColor;
			SpriteUtil.addChild(preLayer, effect, "effect", note.x, note. y);
			setTimeout(function():void { preLayer.removeChild(effect); listExplosionMc.push(effect); Starling.juggler.remove(effect);  }, 2000);
			this.hp = Math.min(100, hp + 0.5);
			this.setHp(this.hp);
			if (score < 60)
			{
				showIcon(2);
				this.perfect++;
			}
			else
			{
				showIcon(1);
				this.good++;
			}
			this.score += (200 - score) * (5.5 + Math.min(5, (this.combo / 50)));
			this.setScore(this.score);
			this.setCombo(++this.combo);
		}
		
		private function sortNote(a:String, b:String, array:Array = null):int
		{
			var noteA:Array = a.split(":");
			var timeA:int = int(noteA[1].substr(0, noteA[1].length - 1));
			var noteB:Array = b.split(":");
			var timeB:int = int(noteB[1].substr(0, noteB[1].length - 1));
			return timeA > timeB?1: -1;
		}
		
		
		private function OnBorderAlpha():void
		{
			if (TweenLite.getTweensOf(border).length > 0)
				return;
			if (border.alpha <= 0.5)
				TweenLite.to(border, 0.9, { alpha:0.8 } );
			else
				TweenLite.to(border, 0.5, { alpha:0.5 } );
		}
		
		private function setHp(value:Number):void
		{
			this.hp = value;
			this.hpBar.clipRect = new Rectangle(0, 0, 575 * hp / 100, this.hpBar.height);
			if (this.hp == 0)
			{
				GameCore.STAGE.removeEventListener(TouchEvent.TOUCH, onClick);
				setTimeout(gotoResult, 1000);
			}
		}
		
		private function setScore(value:int):void
		{
			this.txtScore.text = value.toString();
			trace("setScore:" + value);
		}
		
		private function setCombo(value:int):void
		{
			this.txtCombo.text = value.toString();
			this.sprCombo.visible = value >= 10;
			if (value > this.maxCombo)
			{
				this.maxCombo = value;
			}
		}
		
		private function gotoResult():void
		{
			for each(var interval:uint in listInterval)
			{
				clearTimeout(interval);
			}
			var rank:String = "F";
			var perfect_p:int = Math.floor(perfect / noteCount * 100);
			var good_p:int = Math.floor(good / noteCount * 100);
			var miss_p:int = Math.floor(miss / noteCount * 100);
			var unlock:int = 0;
			var score_p:Number = this.score / this.maxScore;
			if (hp > 0)
			{
				if (score_p > 0.48 && miss == 0)
				{
					rank = "S";
					unlock = 4;
				}
				else if (score_p > 0.48)
				{
					rank = "A";
					unlock = 3;
				}
				else if (score_p > 0.26)
				{
					rank = "B";
					unlock = 2;
				}
				else
				{
					rank = "C";
					unlock = 1;
				}
			}
			
			if (unlock >= data.unlock)
				SqliteUtil.update(data.id + 1, 0, 0);
			if (score > data.score)
				SqliteUtil.update(data.id, score, 0);
			this.dispatchEvent(new DataEvent( { action: GO_TO_RESULT, data: { id: data.id, title: data.name, rank: rank, perfect: perfect, perfect_p: perfect_p, good: good, good_p: good_p, miss: miss, miss_p: miss_p, maxCombo: this.maxCombo, score: this.score, unlock: unlock >= data.unlock } }));
		}
	}

}