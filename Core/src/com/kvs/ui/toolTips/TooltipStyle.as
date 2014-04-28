package com.kvs.ui.toolTips
{
	import com.kvs.utils.XMLConfigKit.Model;
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	import com.kvs.utils.XMLConfigKit.style.LabelStyle;
	import com.kvs.utils.XMLConfigKit.style.elements.IFreshElement;
	import com.kvs.utils.XMLConfigKit.style.elements.IStyleElement;

	/**
	 *
	 * 当同时要显示几个数据节点信息时， 采用  group 样式， 
	 * 
	 * 默认仅有一个数据节点信息时采用 self 样式；
	 * 
	 */	
	public class TooltipStyle extends LabelStyle implements IStyleElement, IFreshElement
	{
		public function TooltipStyle()
		{
		}
		
		/**
		 */		
		override public function fresh():void
		{
			super.fresh();
			
			self = new LabelStyle;
			group = new LabelStyle;
			
			self.text.value = _label;
			group.text.value = _label;
		}
		
		/**
		 */		
		override public function set style(value:String):void
		{
			_style = XMLVOMapper.updateStyle(this, value, Model.TOOLTIP);
		}
		
		/**
		 */		
		public function set label(value:String):void
		{
			if (self == null) self = new LabelStyle;
			if (group == null) group = new LabelStyle;
			
			_label = value;
			
			self.text.value = _label;
			group.text.value = _label;
		}
		
		/**
		 */		
		private var _label:String;
		
		/**
		 */		
		public function get label():String
		{
			if (self)
				return self.text.value
			else if (group)
				return group.text.value;
			else
				return null;
		}
		
		/**
		 */		
		private var _normal:LabelStyle;

		public function get self():LabelStyle
		{
			return _normal;
		}

		public function set self(value:LabelStyle):void
		{
			_normal = value
		}
		
		/**
		 */		
		private var _group:LabelStyle;

		public function get group():LabelStyle
		{
			return _group;
		}

		public function set group(value:LabelStyle):void
		{
			_group = value;
		}
		
		/**
		 */		
		private var _locked:Boolean = false;
		
		/**
		 */
		public function get locked():Object
		{
			return _locked;
		}
		
		/**
		 * @private
		 */
		public function set locked(value:Object):void
		{
			_locked = XMLVOMapper.boolean(value);
		}
		

	}
}