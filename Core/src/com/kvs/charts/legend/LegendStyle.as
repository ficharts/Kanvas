package com.kvs.charts.legend
{
	import com.kvs.charts.chart2D.core.model.DataRender;
	import com.kvs.utils.XMLConfigKit.Model;
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	import com.kvs.utils.XMLConfigKit.style.ContainerStyle;
	import com.kvs.utils.XMLConfigKit.style.LabelStyle;
	import com.kvs.utils.XMLConfigKit.style.elements.IFreshElement;
	import com.kvs.utils.XMLConfigKit.style.elements.IStyleElement;
	
	/**
	 * 图例的样式模型
	 */	
	public class LegendStyle extends ContainerStyle implements IStyleElement, IFreshElement
	{
		public function LegendStyle()
		{
			super();
		}
		
		/**
		 */		
		override public function fresh():void
		{
			super.fresh();
			
			_icon = new DataRender;
			_label = new LabelStyle;
		}
		
		/**
		 */		
		private var _style:String;

		public function get style():String
		{
			return _style;
		}

		/**
		 */		
		public function set style(value:String):void
		{
			_style = XMLVOMapper.updateStyle(this, value, Model.LEGEND);
		}

		/**
		 */		
		public function get icon():DataRender
		{
			return 	_icon;
		}
		
		/**
		 */		
		public function set icon(value:DataRender):void
		{
			_icon = XMLVOMapper.updateObject(value, _icon, Model.ICON, this) as DataRender;
		}
		
		/**
		 */		
		private var _icon:DataRender;
		
		/**
		 */		
		private var _label:LabelStyle;

		/**
		 */
		public function get label():LabelStyle
		{
			return _label;
		}

		/**
		 * @private
		 */
		public function set label(value:LabelStyle):void
		{
			_label = value;
		}
		
		/**
		 */		
		private var _position:String = 'bottom';

		/**
		 */
		public function get position():String
		{
			return _position;
		}

		/**
		 * @private
		 */
		public function set position(value:String):void
		{
			_position = value;
		}

		
	}
}