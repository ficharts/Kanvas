package view.ui
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public final class Interact extends Sprite
	{
		public function Interact()
		{
			super();
			mouseEnabled = mouseChildren = false;
		}
		
		public function show(x:Number, y:Number, w:Number, h:Number):void
		{
			var sprite:InteractSprite = new InteractSprite;
			
			sprite.graphics.clear();
			sprite.graphics.beginFill(0x80FFFF, .2);
			sprite.graphics.drawRect(x, y, w, h);
			sprite.graphics.endFill();
			sprite.alpha = 0;
			addChild(sprite);
			
			sprite.addEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		private function enterFrame(e:Event):void
		{
			var sprite:InteractSprite = InteractSprite(e.currentTarget);
			if (sprite.alpha >= 1)
			{
				sprite.a = -.2;
			}
			else if (sprite.alpha < 0)
			{
				sprite.removeEventListener(Event.ENTER_FRAME, enterFrame);
				removeChild(sprite);
			}
			sprite.alpha += sprite.a;
		}
	}
}

import flash.display.Sprite;

class InteractSprite extends Sprite
{
	public var a:Number = .2;
}