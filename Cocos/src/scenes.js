//Home Scene
var HomeLayer = cc.Layer.extend({
	ctor:function () {
		this._super();
		gData.home = this;
		this.loadData();
		var draw = new cc.DrawNode();
		this.addChild(draw, 0);
		draw.drawRect(cc.p(0, 0), cc.p(gameSize.x, gameSize.y),cc.color(255, 255, 255, 255), 1, cc.color(255, 255, 255, 255));
		this.container = new cc.Sprite();
		this.sprite = getSprite(res.HomeBG_jpg);
		this.container.addChild(this.sprite);
		var pngTouch = getSprite(res.HomeTouch_png, -80, 0);
		pngTouch.scale *= 1.8;
		this.container.addChild(pngTouch);
		cc.eventManager.addListener({
			event: cc.EventListener.TOUCH_ALL_AT_ONCE,
			onTouchesEnded: function(touches, event){
				childsFadeInOut(gData.home.container, false);
				gData.home.runAction(cc.sequence([cc.delayTime(gData.fadeTime), cc.callFunc(gData.home.gotoLobby,gData.home)]));
			},
			swallowTouches:true
		}, this);
		this.addChild(this.container);
		return true;
	},
	gotoLobby:function(){
		gData.home = null;
		var lobby = new LobbyScene();
		lobby.isFadeIn = true;
		cc.director.runScene(lobby);
	},
	loadData:function(){
		var ls = cc.sys.localStorage;
		for(var i in gLevelData){
			var key = "ep"+gLevelData[i].id;
			var val = ls.getItem(key);
			if (val == null){
				gLevelData[i].score = 0;
				ls.setItem(key, 0);
			}else{
				gLevelData[i].score = val;
			}
		}
	}
});

var HomeScene = cc.Scene.extend({
	onEnter:function () {
		this._super();
		var layer = new HomeLayer();
		this.addChild(layer);
	}
});

//Lobby Scene
var LobbyLayer = cc.Layer.extend({
	ctor:function () {
		this._super();
		this.imgWordBG = getSprite(res.LobbyWordBG_png, gameSize.x, 730);
		var action = cc.moveTo(0.5, 0, 730);
		this.imgWordBG.runAction(cc.sequence([action, cc.delayTime(0.05), cc.callFunc(this.onBGActionEnd, this)]));
		this.addChild(this.imgWordBG, 1);
		return true;
	},
	onMsgActionEnd:function(){
		this.lblMsg.x = gameSize.x;
		this.lblMsg.runAction(cc.sequence([this.actMsg, cc.callFunc(this.onMsgActionEnd, this)]));
	},
	onBGActionEnd:function(){
		this.group = new cc.Sprite();
		this.imgPlay = getSprite(res.LobbyBtnPlay_png, 390, 180);
		this.imgPlay.scale *= 1.6;
		this.imgPlay.attr({
			anchorX: 0.5,
			anchorY: 0.5
		});
		this.group.addChild(this.imgPlay);
		this.lblScoreT = getLabelTTF("Highest Score ", 60, 90, 325, cc.color(76,85,61));
		this.group.addChild(this.lblScoreT);
		var strScore = gLevelData[gData.lv].score <= 0 ? "0 ": gLevelData[gData.lv].score + " ";
		this.lblScore = getLabelTTF(strScore, 70, 310, 320, cc.color(76,85,61));
		this.lblScore.setDimensions(350, 80);
		this.lblScore.setHorizontalAlignment(cc.TEXT_ALIGNMENT_RIGHT);
		this.group.addChild(this.lblScore);
		this.lblEpisode = getLabelTTF("Episode "+gLevelData[gData.lv].id+" ", 80, 15, 1180, cc.color(76,85,61));
		this.group.addChild(this.lblEpisode);
		this.lblTitle = getLabelTTF(gLevelData[gData.lv].name, 100, 0, 850);
		this.lblTitle.setDimensions(gameSize.x, 110);
		this.lblTitle.setHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER);
		this.group.addChild(this.lblTitle, 1);
		this.lblMsg = getLabelTTF(gLevelData[gData.lv].title, 50, gameSize.x, 723);
		var delay = cc.delayTime(0.1);
		this.actMsg = cc.moveTo(10, -this.lblMsg.getContentSize().width, 723);
		this.lblMsg.runAction(cc.sequence([this.actMsg, cc.callFunc(this.onMsgActionEnd, this)]));
		this.group.addChild(this.lblMsg, 1);
		if (gData.lv > 0){
			this.imgLArrow = getSprite(res.LobbyArrow_png, 5, 670);
			this.imgLArrow.setFlippedX(true);
			this.actLa = cc.moveTo(0.5, 30, 670);
			this.actLb = cc.moveTo(0.5, 5, 670);
			this.imgLArrow.runAction(cc.sequence([this.actLa, this.actLb, cc.callFunc(this.onLArrowActionEnd, this)]));
			this.group.addChild(this.imgLArrow, 1);
		}
		if (gData.lv < 9){
			this.imgRArrow = getSprite(res.LobbyArrow_png, 680, 670);
			this.actRa = cc.moveTo(0.5, 655, 670);
			this.actRb = cc.moveTo(0.5, 680, 670);
			this.imgRArrow.runAction(cc.sequence([this.actRa, this.actRb, cc.callFunc(this.onRArrowActionEnd, this)]));
			this.group.addChild(this.imgRArrow, 1);
		}
		this.imgIcon = getSprite(res["LVEP"+gLevelData[gData.lv].id+"Icon_png"], 138, 510);
		this.addChild(this.imgIcon, 0);
		for(var i = 0; i < 5; i++){
			var name = res.LobbyStarEmpty_png;
			if (gLevelData[gData.lv].star >i){
				name = res.LobbyStarFull_png;
				var starBG = getSprite(res.LobbyStarEffect_png, 265 + (i * 42) + 19, 450 + 20);
				starBG.attr({
					anchorX: 0.5,
					anchorY: 0.5
				});
				this.group.addChild(starBG);
				this["onStarActionEnd"](starBG);
			}
			var star = getSprite(name, 265 + (i * 42), 450);
			this.group.addChild(star, 1);
		}
		//this.group.setOpacity(0.5);
		//var fadeInAction = cc.fadeIn(2.0);
		//this.group.runAction(cc.sequence([cc.delayTime(0.1), fadeInAction]));
		this.addChild(this.group, 1);
		childsFadeInOut(this.group, true);
	},
	onLArrowActionEnd:function(){
		this.imgLArrow.runAction(cc.sequence([this.actLa, this.actLb, cc.callFunc(this.onLArrowActionEnd, this)]));
	},
	onRArrowActionEnd:function(){
		this.imgRArrow.runAction(cc.sequence([this.actRa, this.actRb, cc.callFunc(this.onRArrowActionEnd, this)]));
	},
	onStarActionEnd:function(obj){
		var starA = cc.scaleTo(1.2, 0.8, 0.8);
		var starB = cc.scaleTo(1.2, 1.2, 1.2);
		obj.runAction(cc.sequence([starA, starB, cc.callFunc(this.onStarActionEnd, this, obj)]));
	},
	initClickEvent:function(fn, layer){
		cc.eventManager.addListener({
			event: cc.EventListener.TOUCH_ALL_AT_ONCE,
			onTouchesBegan:function(touches, event){
				this.startPoint = { x:touches[0].getLocationX(), y:touches[0].getLocationY() };
			},
			onTouchesEnded: function(touches, event){
				var point = { x:touches[0].getLocationX(), y:touches[0].getLocationY() };
				var diffX = this.startPoint.x - point.x;
				var lr = 0;
				if (Math.abs(diffX) < 35){
					if (point.x > 0 && point.x < 200 && point.y > 600 && point.y < 800){
						lr = 1;
					}
					if (point.x > 550 && point.x < 750 && point.y > 600 && point.y < 800){
						lr = 2;
					}
					if (point.x > 280 && point.x < 480 && point.y > 120 && point.y < 270){
						if (!this.end){
							this.end = true;
							layer.imgPlay.scale = 1;
							layer.imgPlay.runAction(cc.sequence([cc.delayTime(0.1), cc.callFunc(this.gotoGameScene, this)]));
							layer.imgPlay.runAction(cc.scaleTo(0.2, 1.6, 1.6));
						}
					}
				}
				else{
					if (diffX < 0){
						lr = 1;
					}
					else{
						lr = 2;
					}
				}
				if (lr == 1 && gData.lv > 0){
					gData.lv = Math.max(0, gData.lv -1);
					fn();
				}else if (lr == 2 && gData.lv < 9){
					gData.lv = Math.min(9, gData.lv +1);
					fn();
				}
			},
			gotoGameScene:function(){
				var name = "SoundEP" + gLevelData[gData.lv].id;
				var obj = {};
				obj[name] = g_mp3[name];
				cc.LoaderScene.preload(obj[name], function () {
					cc.director.runScene(new GameScene());
				}, cc.game);
			},
			swallowTouches:true
		}, this);
	}
});
//LobbyLayer.prototype.nextPage = null;

var LobbyEffectLayer = cc.Layer.extend({
	ctor:function () {
		this._super();
		this.emitter = new cc.ParticleSystem(res.LobbyParticle_plist);
		this.emitter.attr({
			texture:cc.textureCache.addImage(res.LobbyParticle_png),
			shapeType:cc.ParticleSystem.BALL_SHAPE,
			x:850,
			y:350
		});
		this.addChild(this.emitter);
		return true;
	}
});

var LobbyScene = cc.Scene.extend({
	onEnter:function () {
		this._super();
		var draw = new cc.DrawNode();
		this.addChild(draw, 0);
		draw.drawRect(cc.p(0, 0), cc.p(gameSize.x, gameSize.y),cc.color(255, 255, 255, 255), 1, cc.color(255, 255, 255, 255));
		var layerBG = new cc.Layer();
		layerBG.addChild(getSprite(res.LobbyBG_jpg));
		this.addChild(layerBG, 0);
		if (this.isFadeIn){
			childsFadeInOut(layerBG, true);
			this.runAction(cc.sequence([cc.delayTime(gData.fadeTime), cc.callFunc(this.fadeInEnd, this)]));
		}else{
			this.fadeInEnd();
		}
	},
	nextPage:function(){
		var scene = cc.director.getRunningScene();
		if (scene.mainLayer){
			scene.removeChild(scene.mainLayer, true);
		}
		scene.mainLayer = new LobbyLayer();
		scene.mainLayer.initClickEvent(scene.nextPage, scene.mainLayer);
		scene.addChild(scene.mainLayer, 1);
	},
	fadeInEnd:function(){
		this.layerEffect = new LobbyEffectLayer();
		this.addChild(this.layerEffect, 2)
		this.nextPage();
	},
	isFadeIn:false
});

//Result Scene
var ResultLayer = cc.Layer.extend({
	ctor:function () {
		this._super();
		this.imgBG = getSprite(res.ResultBG_jpg);
		this.addChild(this.imgBG);
		this.imgTitleBG = getSprite(res.ResultTitleBG_png,0,1180);
		this.addChild(this.imgTitleBG);
		this.lblTitle = getLabelTTF(gLevelData[gData.lv].name, 100, 0, 1194);
		this.lblTitle.setDimensions(gameSize.x, 110);
		this.lblTitle.setHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER);
		this.addChild(this.lblTitle);
		this.imgDataBG = getSprite(res.ResultDataBG_png,0,390);
		this.addChild(this.imgDataBG);
		this.lblRank = getLabelTTF("Rank ", 50, 10, 935, cc.color(76,85,61));
		this.addChild(this.lblRank);
		if (gData.score > gLevelData[gData.lv].score){
			gLevelData[gData.lv].score = gData.score;
			var ls = cc.sys.localStorage;
			ls.setItem("ep"+gLevelData[gData.lv].id, gData.score);
		}
		childsFadeInOut(this, true);
		this.runAction(cc.sequence([cc.delayTime(gData.fadeTime), cc.callFunc(this.onFadeInEnd, this)]));
		return true;
	},
	onFadeInEnd:function(){
		this.groupPerfect = new cc.Sprite();
		this.addChild(this.groupPerfect);
		this.lblPerfectT = getLabelTTF("Perfect  ", 115, 235, 775);
		this.lblPerfect = getLabelTTF(gData.perfect+"("+gData.perfect_p+"%)", 42, 215, 670);
		this.lblPerfect.setDimensions(300, 110);
		this.lblPerfect.setHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER);
		this.groupPerfect.addChild(this.lblPerfectT);
		this.groupPerfect.addChild(this.lblPerfect);
		this.groupPerfect.scale = 0;
		var perfectAction = cc.scaleTo(0.5, 1, 1);
		this.groupPerfect.runAction(cc.sequence([perfectAction, cc.delayTime(0.15), cc.callFunc(this.onPerfectEnd, this)]));
	},
	onPerfectEnd:function(){
		this.groupGood = new cc.Sprite();
		this.addChild(this.groupGood);
		this.lblGoodT = getLabelTTF("Good  ", 100, 90, 620);
		this.lblGood = getLabelTTF(gData.good+"("+gData.good_p+"%)", 42, 30, 515);
		this.lblGood.setDimensions(300, 110);
		this.lblGood.setHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER);
		this.groupGood.addChild(this.lblGood);
		this.groupGood.addChild(this.lblGoodT);
		this.groupGood.scale = 0;
		var goodAction = cc.scaleTo(0.5, 1, 1);
		this.groupGood.runAction(cc.sequence([goodAction, cc.delayTime(0.15), cc.callFunc(this.onGoodEnd, this)]));
	},
	onGoodEnd:function(){
		this.groupMiss = new cc.Sprite();
		this.addChild(this.groupMiss);
		this.lblMissT = getLabelTTF("Miss  ", 90, 490, 615);
		this.groupMiss.addChild(this.lblMissT);
		this.lblMiss = getLabelTTF(gData.miss+"("+gData.miss_p+"%)", 42, 415, 518);
		this.lblMiss.setDimensions(300, 110);
		this.lblMiss.setHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER);
		this.groupMiss.addChild(this.lblMiss);
		this.groupMiss.scale = 0;
		var missAction = cc.scaleTo(0.5, 1, 1);
		this.groupMiss.runAction(cc.sequence([missAction, cc.delayTime(0.15), cc.callFunc(this.onMissEnd, this)]));
	},
	onMissEnd:function(){
		this.groupCombo = new cc.Sprite();
		this.addChild(this.groupCombo);
		this.lblComboT = getLabelTTF("Max Combo  ", 80, 210, 470);
		this.groupCombo.addChild(this.lblComboT);
		this.lblCombo = getLabelTTF(gData.maxCombo<=0?"0":gData.maxCombo, 42, 220, 380);
		this.lblCombo.setDimensions(300, 110);
		this.lblCombo.setHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER);
		this.groupCombo.addChild(this.lblCombo);
		this.groupCombo.scale = 0;
		var comboAction = cc.scaleTo(0.5, 1, 1);
		this.groupCombo.runAction(cc.sequence([comboAction, cc.delayTime(0.25), cc.callFunc(this.onComboEnd, this)]));
	},
	onComboEnd:function(){
		this.lblscoreT = getLabelTTF("Score ", 100, 100, 240, cc.color(76,85,61));
		this.addChild(this.lblscoreT);
		this.lblscore = getLabelTTF("0 ", 90, 230, 248, cc.color(76,85,61));
		this.lblscore.setDimensions(400, 100);
		this.lblscore.setHorizontalAlignment(cc.TEXT_ALIGNMENT_RIGHT);
		this.addChild(this.lblscore);
		this.step = 0;
		this.scheduleUpdate();
	},
	update:function(dt){
		this.lblscore.setString(Math.ceil(gData.score * (++this.step/60))+" ");
		if (this.step == 60){
			this.unscheduleUpdate();
			this.imgRank = new cc.Sprite(res["Result"+gData.rank+"_png"]);
			this.imgRank.attr({
				x:365,
				y:1065
			});
			this.imgRank.scale = 3;
			this.imgRank.y = 720;
			this.addChild(this.imgRank);
			var delay = cc.delayTime(0.5);
			var actionM = cc.moveTo(0.35, 365, 1065);
			var actionS = cc.scaleTo(0.35, 1, 1);
			this.imgRank.runAction(cc.sequence([delay, actionM]));
			this.imgRank.runAction(cc.sequence([delay.clone(), actionS, cc.delayTime(0.25), cc.callFunc(this.onRankEnd, this)]));
		}
	},
	onRankEnd:function(){
		var lblBack = getLabelTTF("Back ", 110, 265, 100);
		this.addChild(lblBack);
		cc.eventManager.addListener({
			event: cc.EventListener.TOUCH_ALL_AT_ONCE,
			onTouchesEnded: function(touches, event){
				var point = cc.p(touches[0].getLocationX(),touches[0].getLocationY());
				if (point.x >= 250 && point.x <= 515 && point.y >= 100 && point.y <= 230){
					cc.audioEngine.stopMusic(false);
					cc.director.runScene(new LobbyScene());
				}
			},
			swallowTouches:true
		}, this);
	}
});

var ResultScene = cc.Scene.extend({
	onEnter:function () {
		this._super();
		if (gData.hp > 0){
			var draw = new cc.DrawNode();
			this.addChild(draw, 0);
			draw.drawRect(cc.p(0, 0), cc.p(gameSize.x, gameSize.y),cc.color(255, 255, 255, 255), 1, cc.color(255, 255, 255, 255));
		}
		var layer = new ResultLayer();
		this.addChild(layer);
	}
});

//Game Scene
var GameLayer = cc.Layer.extend({
	ballColor:[cc.color(255, 0, 0, 255),cc.color(255, 165, 0, 255),cc.color(255, 255, 0, 255),cc.color(0, 255, 0, 255),cc.color(0, 255, 255, 255),cc.color(0, 0, 255, 255),cc.color(43, 0, 255, 255),cc.color(87, 0, 100, 255)],
	ctor:function () {
		gData.rank = "F"; gData.perfect = 0; gData.perfect_p = 0; gData.good = 0; gData.good_p = 0; gData.miss = 0; gData.miss_p = 0; gData.maxCombo = 0; gData.score = 0, gData.unlock = 0;
		gData.game = this;
		this._super();
		this.NOTE_TIME = 2500;
		this.hp = 1.2;
		this.endY = (gameSize.y + 70);
		this.imgBG = getSprite(res["LVEP"+gLevelData[gData.lv].id+"BG_jpg"]);
		this.addChild(this.imgBG);
		var tnitB = cc.tintTo(0.05, 25, 25, 25);
		this.imgBG.runAction(tnitB);
		this.imgBorder = getSprite(res.GameBorder_png, 0, 80);
		this.addChild(this.imgBorder);
		this.imgHpBarBG = getSprite(res.GameHpbarBG_png,0,970);
		//this.addChild(this.imgHpBarBG, 2);
		this.imgHpBarBlack = getSprite(res.GameHpbarBlack_png,10,1205);
		this.addChild(this.imgHpBarBlack, 2);
		this.imgHpBar = getSprite(res.GameHpBar_png, 0, 1220);
		this.imgHpBar.scale = 1.2;
		this.addChild(this.imgHpBar, 2);
		this.imgHpBarAccessory = getSprite(res.GameHpBarA_png, 0, 1140);
		this.addChild(this.imgHpBarAccessory, 2);
		this.imgGiveup = getSprite(res.GameGiveUp_png,674,1294);
		this.imgGiveup.attr({
			anchorX: 0.5,
			anchorY: 0.5
		});
		this.addChild(this.imgGiveup, 2);
		this.lblScoreT = getLabelTTF("Score ", 60, 130, 1255);
		this.addChild(this.lblScoreT, 2);
		this.lblScore = getLabelTTF("0 ",80,255,1245);
		this.addChild(this.lblScore, 2);
		this.imgPerect = new cc.Sprite(res.GamePerfect_png);
		this.imgGood = new cc.Sprite(res.GameGood_png);
		this.imgMiss = new cc.Sprite(res.GameMiss_png);
		this.lblComboT = getLabelTTF("Combo", 50, 300, 625);
		this.addChild(this.lblComboT, 2);
		this.lblCombo = getLabelTTF("30", 130, 220, 650);
		this.lblCombo.setDimensions(300, 150);
		this.lblCombo.setHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER);
		this.addChild(this.lblCombo, 2);
		this.setCombo(0);
		this.listEmitter1 = [];
		this.listBall = [];
		this.listSoundInfo = [];
		this.initSoundData();
		this.runAction(cc.sequence([cc.delayTime(1.2), cc.callFunc(this.startGame,this)]));
		addToPool(this.imgMiss);
		addToPool(this.imgGood);
		addToPool(this.imgPerect);
		childsFadeInOut(this, true);
		/*var draw = new cc.DrawNode();
		this.addChild(draw, 10);
		draw.drawRect(cc.p(600, 1250), cc.p(750, 1350),cc.color(255, 255, 255, 100), 1, cc.color(255, 255, 255, 100));
		draw.drawRect(cc.p(0, 227-40), cc.p(750, 227+40),cc.color(255, 255, 0, 100), 1, cc.color(255, 255, 0, 100));
		draw.drawSegment(cc.p(0,227), cc.p(750,227), 3, cc.color(255, 255, 255, 255));
		var point = cc.p(300,227);*/
		return true;
	},
	startGame:function(){
		this.gameTime = -450;
		this.skipTime = 0;
		cc.audioEngine.playMusic(g_mp3["SoundEP"+gLevelData[gData.lv].id], false);
		this.scheduleUpdate();
		cc.eventManager.addListener({
			event: cc.EventListener.TOUCH_ALL_AT_ONCE,
			touchesLoction: {},
			onTouchesBegan: function(touches, event){
				for(var i in touches){
					var touch = touches[i];
					var point = this.touchesLoction[touch.getID().toString()] = cc.p(touch.getLocationX(), touch.getLocationY());
					if (this.isOnBorder(point)){
						for (var a in gData.game.listBall){
							var ball = gData.game.listBall[a];
							var pb = cc.p(ball.x, ball.y - 22);
							var pb2 = cc.p(ball.x, ball.y + 38);
							if (this.isOnBorder(pb) || this.isOnBorder(pb2)){
								if (pb.x >= point.x - 80 && pb.x <= point.x + 80 && ((pb.y >= point.y - 80 && pb.y <= point.y + 80) || (pb2.y >= point.y - 80 && pb2.y <= point.y + 80))){
									gData.game.hitBall(ball);
								}
							}
						}
					}
				}
				
				if (gData.game.skipTime == 0 && point.x >= 225 && point.x <= 525 && point.y >= 522 && point.y <= 822){
					var emitter = new cc.ParticleSystem(res.GameEffect3_plist);
					gData.game.addChild(emitter, 10);
					gData.game.skipTime = gData.game.gameTime + 3000;
					gData.game.clearBall();
				}
				if (point.x >= 600 && point.x <= 750 && point.y >= 1250 && point.y <= 1350){
					gData.game.imgGiveup.setScale(0.5, 0.5);
					gData.game.imgGiveup.runAction(cc.scaleTo(0.2, 1, 1));
					gData.game.hp = 0;
					gData.game.imgHpBar.setScale(0,0);
					gData.game.gotoResult();
				}
			},
			onTouchesMoved: function(touches, event){
				for(var i in touches){
					this.checkLine(touches[i]);
				}
			},
			onTouchesEnded: function(touches, event){
				for(var i in touches){
					this.checkLine(touches[i]);
					this.touchesLoction[touches[i].getID().toString()] = null;
				}
			},
			isOnBorder:function(point){
				return point.x >= 0 && point.x <= 750 && point.y >=105 && point.y <= 315;
			},
			checkLine:function(touch){
				var id = touch.getID().toString();
				if (id in this.touchesLoction && this.touchesLoction[id] != null){
					var p1 = this.touchesLoction[id];
					var p2 = cc.p(touch.getLocationX(), touch.getLocationY());
					if (this.isOnBorder(p2)){
						for (var a in gData.game.listBall){
							var ball = gData.game.listBall[a];
							var pb = cc.p(ball.x, ball.y - 22);
							var pb2 = cc.p(ball.x, ball.y + 38);
							if (this.isOnBorder(pb) || this.isOnBorder(pb2)){
								if (p2.x > 670?750:(Math.min(p1.x,p2.x) - 50) <= pb.x && p2.x < 80?0:(Math.max(p1.x,p2.x) + 50) >= pb.x){
									if (Math.abs(pb.y - 227) < 40 || Math.abs(pb2.y - 227) < 40){
										gData.game.hitBall(ball);
									}
								}
							}
						}
					}
				}
			},
			swallowTouches:true
		}, this);
	},
	createBall:function(xp, diffTime){
		var emitter = null;
		while (this.listEmitter1.length > 0 && emitter == null){
			emitter = this.listEmitter1.shift();
			if (cc.isObject(emitter)){
				emitter.resetSystem();
			}else{
				emitter = null;
			}
		}
		if (emitter == null){
			emitter = new cc.ParticleSystem(res.GameBall_plist);
			emitter.setPositionType(2);
			if (cc.sys.platform < 50){
				emitter.setStartSize(emitter.getStartSize() * 1.4);
				emitter.setEndSize(emitter.getEndSize() * 1.4);
			}
			addToPool(emitter);
		}
		emitter.setStartColor(this.getRandomColor());
		if (cc.sys.platform == cc.sys.MOBILE_BROWSER){
			emitter.setTotalParticles(8);
		}else{
			emitter.setTotalParticles(this.getChildrenCount() > 30?10:15);
		}
		this.addChild(emitter, 1);
		var offset = diffTime / this.NOTE_TIME * this.endY;
		emitter.attr({
			x:(xp * (gameSize.x - 25)) + 5,
			y:gameSize.y - offset,
			miss:false,
			isHit:false,
			cTime:diffTime
		});
		this.listBall.push(emitter);
		
		/*var draw = new cc.DrawNode();
		this.addChild(draw, 10);
		draw.drawSegment(cc.p(emitter.x,emitter.y-23), cc.p(emitter.x,emitter.y+38), 3, cc.color(0, 0, 0, 255));*/
	},
	clearBall:function(){
		for(var i in this.listBall){
			this.listBall[i].stopSystem();
		}
	},
	getRandomColor:function(){
		var t = 700;
		var r = 0;
		var r = 1;
		var g = 1;
		var b = 1;
		while(t>600 || r < 100 || t<120){
			r = Math.random() * 255;
			g = Math.random() * 255;
			b = Math.random() * 255;
			t = r+g+b;
			r = Math.abs(r-g)+Math.abs(r-b)+Math.abs(g-b);
		}
		//cc.log(r+":"+g+":"+b);
		return cc.color(r, g, b, 255);
	},
	initSoundData:function(){
		var nodeList = gSoundsData[gData.lv].split(",");
		this.maxScore = 0;
		this.combo = 0;
		for (var i in nodeList){
			var arr = nodeList[i].split(":");
			var obj = { x:arr[0].substr(1), time:arr[1].substr(0, arr[1].length -1) };
			this.listSoundInfo.push(obj);
			this.maxScore += 200 * (5.5 + Math.min(5, (this.listSoundInfo.length / 50)));
		}
		this.listSoundInfo.sort(function(a,b){
			return a.time - b.time;
		});
		this.totalNode = this.listSoundInfo.length;
	},
	update:function(dt){
		this.gameTime += dt * 1000;
		if (this.listSoundInfo.length > 0){
			var diffTime = Math.floor(this.gameTime - (this.listSoundInfo[0].time - this.NOTE_TIME));
			if (Math.abs(diffTime) < 7 || diffTime > 17){
				var obj = this.listSoundInfo.shift();
				if (this.gameTime > this.skipTime){
					this.createBall(obj.x / 100, diffTime);
				}
			}
		}
		if (this.listBall.length > 0){
			for(var i in this.listBall){
				var ball = this.listBall[i];
				ball.cTime += dt * 1000;
				if (ball.y > -70){
					ball.y = gameSize.y - (ball.cTime/this.NOTE_TIME * this.endY);
				}
				if (ball.y <= -20 && !ball.miss && !ball.isHit && this.gameTime > this.skipTime){
					ball.miss = true;
					gData.miss++;
					this.setCombo(0);
					this.showHitMsg(0);
					this.imgHpBar.setScaleX(this.hp-=0.05);
					if (this.hp <= 0){
						this.gotoResult();
					}
				}
			}
			while(this.listBall.length > 0 && this.listBall[0].y <= -70){
				var emitter = this.listBall.shift();
				emitter.stopSystem();
				this.removeChild(emitter, false);
				this.listEmitter1.push(emitter);
			}
		}
		if (this.listSoundInfo.length == 0 && this.listBall.length == 0){
			this.unscheduleUpdate();
			this.runAction(cc.sequence([cc.delayTime(1), cc.callFunc(this.gotoResult, this)]));
		}
	},
	gotoResult:function(){
		gData.perfect_p = Math.ceil(gData.perfect / this.totalNode * 100);
		gData.good_p = Math.ceil(gData.good / this.totalNode * 100);
		gData.miss_p = Math.ceil(gData.miss / this.totalNode * 100);
		var sp = gData.score / this.maxScore;
		if (this.hp > 0){
			if (sp > 0.48 && gData.miss == 0){
				gData.rank = "S";
			}else if(sp > 0.48){
				gData.rank = "A";
			}else if(sp > 0.26){
				gData.rank = "B";
			}else{
				gData.rank = "C";
			}
		}
		gData.hp = this.hp;
		if (this.hp <= 0){
			childsFadeInOut(this, false);
			this.clearBall();
			this.runAction(cc.sequence([cc.delayTime(gData.fadeTime + 0.1), cc.callFunc(this.gotoResultEnd, this)]))
		}else{
			addToPool(this.imgBG);
			this.removeChild(this.imgBG);
			var draw = new cc.DrawNode();
			this.addChild(draw, 0);
			draw.drawRect(cc.p(0, 0), cc.p(gameSize.x, gameSize.y),cc.color(255, 255, 255, 255), 1, cc.color(255, 255, 255, 255));
			childsFadeInOut(this, false);
			this.addChild(this.imgBG);
			var tint = cc.tintTo(1.5, 225, 225, 225);
			this.imgBG.runAction(cc.sequence([tint, cc.delayTime(0.6), cc.fadeOut(gData.fadeTime), cc.callFunc(this.gotoResultEnd, this)]));
		}
		this.unscheduleUpdate();
	},
	gotoResultEnd:function(){
		clearPool();
		cc.loader.release(g_mp3["SoundEP"+gLevelData[gData.lv].id]);
		cc.director.runScene(new ResultScene());
	},
	hitBall:function(ball){
		var emitter = null;
		emitter = new cc.ParticleSystem(res.GameEffect_plist);
		emitter.attr({
			x:ball.x,
			y:ball.y
		});
		emitter.setStartColor(ball.getStartColor());
		emitter.setEndColor(ball.getEndColor());
		emitter.setAutoRemoveOnFinish(true);
		if (cc.sys.platform == cc.sys.MOBILE_BROWSER){
			emitter.setTotalParticles(30);
		}else{
			emitter.setTotalParticles(this.getChildrenCount() > 28?50:100);
		}
		this.addChild(emitter, 1);
		ball.isHit = true;
		this.setCombo(this.combo + 1);
		if (this.combo > gData.maxCombo){
			gData.maxCombo = this.combo;
		}
		var score = Math.abs(ball.y - 227 - 12);
		if (score <= 50){
			gData.perfect++;
			this.showHitMsg(2);
		}else{
			gData.good++;
			this.showHitMsg(1);
		}
		gData.score += Math.floor(Math.max(0,(200 - score)) * (5.5 + Math.min(5, (this.combo / 50))));
		ball.y = -100;
		this.lblScore.setString(gData.score.toString()+" ");
		this.hp = Math.min(this.hp + 0.002, 1.2);
		this.imgHpBar.setScaleX(this.hp);
	},
	showHitMsg:function(type){
		this.removeChildByTag(60, false)
		var icon = null;
		switch(type){
		case 1:
			icon = this.imgGood;
			break;
		case 2:
			icon = this.imgPerect;
			break;
		default:
			icon = this.imgMiss;
			break;
		}
		icon.x = 370;
		icon.y = 450;
		icon.stopAllActions();
		icon.setOpacity(255);
		this.addChild(icon, 2, 60)
		var move = cc.moveTo(0.6, 370, 590);
		var opac = cc.fadeTo(0.4, 40);
		icon.runAction(cc.sequence([move, cc.callFunc(this.hitMsgEnd, this)]));
		icon.runAction(cc.sequence([cc.delayTime(0.2), opac]));
	},
	hitMsgEnd:function(icon){
		this.removeChildByTag(60, false);
	},
	setCombo:function(val){
		this.combo = val;
		this.lblCombo.setScale(0.7, 0.7);
		this.lblCombo.runAction(cc.scaleTo(0.15, 1, 1));
		this.lblCombo.setString(val.toString());
		if (val > 9){
			this.lblCombo.setVisible(true);
			this.lblComboT.setVisible(true);
		}else{
			this.lblCombo.setVisible(false);
			this.lblComboT.setVisible(false);
		}
	}
});

var GameScene = cc.Scene.extend({
	onEnter:function () {
		this._super();
		var layer = new GameLayer();
		this.addChild(layer);
	}
});