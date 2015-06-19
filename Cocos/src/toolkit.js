function getSprite(name, x, y)
{
	x = x || 0;
	y = y || 0;
	var sprite = new cc.Sprite(name);
	sprite.attr({
		x: x,
		y: y,
		anchorX: 0,
		anchorY: 0,
		scale: 1
	});
	return sprite;
}

function getLabelTTF(msg, size, x, y, color){
	x = x || 0;
	y = y || 0;
	color = color || cc.color(255,255,255,255);
	var pFont = cc.sys.platform < 50?"res/fonts/font.ttf":"Edwardian";
	var label = new cc.LabelTTF(msg, pFont, size);
	label.attr({
		x: x,
		y: y,
		anchorX: 0,
		anchorY: 0,
		color: color
	});
	return label;
}

function childsFadeInOut(obj, isIn){
	var childs = obj.getChildren();
	var action = isIn?cc.fadeIn(gData.fadeTime):cc.fadeOut(gData.fadeTime);
	for (var i in childs){
		var child = childs[i];
		if ("runAction" in child){
			if (isIn){
				child.setOpacity(0);
			}
			child.runAction(action.clone());
		}
	}
}

function addToPool(obj){
	if (cc.sys.platform < 50){
		cc.pool.putInPool(obj);
	}
}

function clearPool(){
	if (cc.sys.platform < 50){
		cc.pool.drainAllPools();
	}
}
