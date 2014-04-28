package com.kvs.utils.XMLConfigKit.shape
{
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	import com.kvs.utils.XMLConfigKit.style.States;
	import com.kvs.utils.XMLConfigKit.style.Style;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	
	import flash.display.Sprite;
	
	/**
	 * 矩形
	 */	
	public class RectShape implements IShape
	{
		public function RectShape()
		{
		}
		
		/**
		 */		
		private var _angle:int = 0;
		
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
		public function set size(value:uint):void
		{
			states.width = states.height = value * Math.sin(Math.PI / 4);
		}
		
		/**
		 */		
		public function get size():uint
		{
			return 0;
		}
		
		/**
		 */		
		public function render(canvas:Sprite, metadata:Object):void
		{
			style.tx = - style.width / 2;
			style.ty = - style.height / 2;
			
			StyleManager.drawRect(canvas, style, metadata);
		}
		
		/**
		 */		
		public function get style():Style
		{
			return _style;
		}
		
		/**
		 */		
		public function set style(value:Style):void
		{
			_style = value;
		}
		
		/**
		 */		
		private var _style:Style;
		
		/**
		 */		
		public function get states():States
		{
			return _states;
		}
		
		/**
		 */		
		public function set states(value:States):void
		{
			_states = XMLVOMapper.updateObject(value, _states, "states", this) as States;
		}
		
		/**
		 */		
		private var _states:States;
	}
}