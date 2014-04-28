package com.kvs.utils.XMLConfigKit.style
{
	import com.kvs.utils.XMLConfigKit.Model;
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	import com.kvs.utils.XMLConfigKit.style.elements.IFiElement;
	import com.kvs.utils.XMLConfigKit.style.elements.IFreshElement;
	import com.kvs.utils.XMLConfigKit.style.elements.IStyleElement;
	import com.kvs.utils.XMLConfigKit.StyleManager;

	/**
	 */	
	public class Colors implements IFiElement, IFreshElement, IStyleElement
	{
		public function Colors()
		{
		}
		
		/**
		 */		
		private var _style:String;

		public function get style():String
		{
			return _style;
		}

		/**
		 *  完全清空样色，重新添加新色系
		 */		
		public function set style(value:String):void
		{
			_style = XMLVOMapper.updateStyle(this, value, Model.COLORS);
		}

		/**
		 */
		public function get color():String
		{
			return null;
		}
		
		/**
		 */
		public function set color(value:String):void
		{
			values.push(StyleManager.getUintColor(value));
		}
		
		/**
		 */		
		public function fresh():void
		{
			values.length = 0;
		}
		
		/**
		 */		
		public function get length():uint
		{
			return values.length;
		}
		
		/**
		 * 根据颜色序号获取颜色值
		 */		
		public function getColor(index:uint):uint
		{
			return values[index];
		}
		
		/**
		 */		
		private var values:Vector.<int> = new Vector.<int>;

	}
}