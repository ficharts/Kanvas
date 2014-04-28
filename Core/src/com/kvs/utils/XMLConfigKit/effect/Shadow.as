package com.kvs.utils.XMLConfigKit.effect
{
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	import com.kvs.utils.XMLConfigKit.style.elements.IFiElement;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	
	import flash.filters.DropShadowFilter;
	
	/**
	 */	
	public class Shadow implements IEffectElement, IFiElement
	{
		public function Shadow()
		{
			super();
		}
		
		/**
		 */		
		public function getEffect(metaData:Object):Object
		{
			if (_effect == null)
			{
				_effect = new DropShadowFilter(this.distance, this.angle, 0, this.alpha, this.blur, this.blur, 2, 3, inner, knockout);
			}
			
			_effect.color = uint(StyleManager.getColor(metaData, this.color));
			
			return _effect;
		}
		
		/**
		 */		
		private var _effect:DropShadowFilter;
		
		/**
		 */		
		private var _distance:uint = 2;

		/**
		 */
		public function get distance():uint
		{
			return _distance;
		}

		/**
		 * @private
		 */
		public function set distance(value:uint):void
		{
			_distance = value;
		}

		
		/**
		 */		
		private var _alpha:Number = 1;

		public function get alpha():Number
		{
			return _alpha;
		}

		public function set alpha(value:Number):void
		{
			_alpha = value;
		}
		
		/**
		 */		
		private var _blur:uint = 2;

		public function get blur():uint
		{
			return _blur;
		}

		public function set blur(value:uint):void
		{
			_blur = value;
		}
		
		/**
		 */		
		private var _color:Object = 0;

		public function get color():Object
		{
			return _color;
		}

		/**
		 */		
		public function set color(value:Object):void
		{
			_color = StyleManager.setColor(value);
		}
		
		/**
		 */		
		private var _angle:int = 45;

		/**
		 */
		public function get angle():int
		{
			return _angle;
		}

		/**
		 * @private
		 */
		public function set angle(value:int):void
		{
			_angle = value;
		}
		
		/**
		 */		
		private var _inner:Object = false;

		public function get inner():Object
		{
			return _inner;
		}

		public function set inner(value:Object):void
		{
			_inner = XMLVOMapper.boolean(value);
		}
		
		/**
		 */		
		private var _knockout:Object = false;

		public function get knockout():Object
		{
			return _knockout;
		}

		public function set knockout(value:Object):void
		{
			_knockout = XMLVOMapper.boolean(value);
		}


	}
}