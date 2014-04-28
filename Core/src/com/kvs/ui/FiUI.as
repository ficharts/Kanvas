package com.kvs.ui
{
	import com.kvs.ui.toolTips.ITipsSender;
	import com.kvs.ui.toolTips.TipsHolder;
	import com.kvs.utils.StageUtil;
	
	import flash.display.Sprite;
	
	/**
	 * ui 基类， 享有所有UI共性， 初始化控制，信息提示机制等
	 */	
	public class FiUI extends Sprite implements ITipsSender
	{
		public function FiUI()
		{
			StageUtil.initApplication(this, preInit);
		}
		
		/**
		 * 保证了初始化仅会在初次加入显示列表时触发
		 */		
		private function preInit():void
		{
			if (ifInited == false)
			{
				init();
				ifInited = true;
			}
		}
		
		/**
		 */		
		protected function init():void
		{
			tipsHolder = new TipsHolder(this);
		}
		
		/**
		 * 防止重复添加进显示列表造成的重复初始化
		 */		
		private var ifInited:Boolean = false;
		
		/**
		 */		
		protected var _enable:Boolean = true;

		/**
		 */
		public function get enable():Boolean
		{
			return _enable;
		}

		/**
		 * @private
		 */
		public function set enable(value:Boolean):void
		{
			if (value)
			{
				mouseChildren = mouseEnabled = true;
				this.alpha = 1;				
			}
			else
			{
				mouseChildren = mouseEnabled = false;
				this.alpha = 0.5;				
			}
			
			_enable = value;
		}

		/**
		 */		
		private var _w:Number = 0;

		/**
		 */
		public function get w():Number
		{
			return _w;
		}

		/**
		 * @private
		 */
		public function set w(value:Number):void
		{
			_w = value;
		}

		/**
		 */		
		private var _h:Number = 0;

		/**
		 */
		public function get h():Number
		{
			return _h;
		}

		/**
		 * @private
		 */
		public function set h(value:Number):void
		{
			_h = value;
		}
		
		/**
		 */		
		public function get tips():String
		{
			return _tips;
		}
		
		/**
		 */		
		public function set tips(value:String):void
		{
			_tips = value;
		}
		
		/**
		 */		
		private var _tips:String = '';
		
		/**
		 */		
		public var tipsHolder:TipsHolder;
	}
}