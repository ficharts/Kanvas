package com.kvs.ui
{
	import com.kvs.ui.button.IconBtn;
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	import com.kvs.utils.XMLConfigKit.style.LabelStyle;
	import com.kvs.ui.label.LabelUI;
	import com.kvs.utils.XMLConfigKit.style.Style;
	import com.kvs.utils.dec.NullPad;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	import com.greensock.TweenLite;
	
	import flash.display.Shape;

	/**
	 * 面板
	 */	
	public class Panel extends FiUI
	{
		public function Panel()
		{
			w = 180;
			h = 500;
			
			super();
		}
		
		/**
		 */		
		private var _isOpen:Boolean = false;

		/**
		 * 是否开启 
		 */
		public function get isOpen():Boolean
		{
			return _isOpen;
		}

		/**
		 * @private
		 */
		public function set isOpen(value:Boolean):void
		{
			_isOpen = this.visible = enable = value;
		}

		/**
		 */		
		public function open(x:Number, y:Number):void
		{
			isOpen = true;
			alpha = 0;
			
			TweenLite.killTweensOf(this);
			TweenLite.to(this, 0.5, {alpha : 1, x: x, y: y});
		}
		
		/**
		 */		
		public function close(x:Number, y:Number):void
		{
			isOpen = false;
			
			TweenLite.killTweensOf(this);
			TweenLite.to(this, 0.5, {alpha : 0, x: x, y: y, onComplete:afterClose});
		}
		
		/**
		 */		
		private function afterClose():void
		{
			
		}
		
		/**
		 * 刷新布局关系，此时近背景需要重绘，
		 * 
		 * 内容区域动态调节滚动条 
		 * 
		 */		
		public function updateLayout():void
		{
			renderBG();
			
			if (ifShowExitBtn)
			{
				exitBtn.y = (barHeight - exitBtn.height) / 2;
				exitBtn.x = (w - exitBtn.width - exitBtn.y);
			}
		}
		
		/**
		 */		
		public function render():void
		{
			//绘制标题
			this.reTitle(title);
			
			updateLayout(); 
		}
		
		/**
		 * 绘制背景 
		 */		
		protected function renderBG():void
		{
			bgShape.graphics.clear();
			
			if (!isNaN(w))
				bgStyle.width = w;
			
			if (!isNaN(h))
				bgStyle.height = h;
			
			StyleManager.drawRectOnShape(bgShape, bgStyle);
			
			titleBgStyle.width = w;
			titleBgStyle.height = barHeight;
			
			StyleManager.setFillStyle(bgShape.graphics, titleBgStyle);
			bgShape.graphics.lineStyle(0, 0, 0);
			bgShape.graphics.drawRect(0, 0, w, barHeight);
			bgShape.graphics.endFill();
		}
		
		/**
		 * 面板头部高度
		 */		
		public function get barHeight():Number
		{
			return _barHeight;
		}
		
		/**
		 * 
		 */		
		public function set barHeight(value:Number):void
		{
			_barHeight = value;
		}
		
		/**
		 */		
		private var _barHeight:Number = 50;
		
		/**
		 */		
		override protected function init():void
		{
			super.init();
			
			XMLVOMapper.fuck(titleBgStyleXML, titleBgStyle);
			titleUI.styleXML = titleStyleXML;
			XMLVOMapper.fuck(bgStyleXML, bgStyle);
				
			addChild(bgShape);		
			addChild(titleUI);
			
			if (ifShowExitBtn)
			{
				exitBtn.styleXML = exitBtnStyleXML;
				addChild(exitBtn);
			}
		}
		
		/**
		 * 绘制标题
		 */		
		public function reTitle(txt:String):void
		{
			titleUI.text = txt;
			titleUI.render();
			titleUI.y = (barHeight - titleUI.height) / 2;
		}
		
		/**
		 */		
		private var _title:String = '';

		/**
		 */
		public function get title():String
		{
			return _title;
		}

		/**
		 * @private
		 */
		public function set title(value:String):void
		{
			_title = value;
		}
		
		/**
		 */		
		protected var titleUI:LabelUI = new LabelUI;
		
		/**
		 * 绘制背景的画布 
		 */		
		protected var bgShape:Shape = new Shape;
		
		/**
		 * 面板头部背景 
		 */		
		private var titleBg:Shape = new Shape;
		
		/**
		 * 是否开启/显示退出按钮
		 */		
		public var ifShowExitBtn:Boolean = false;
		
		/**
		 * 退出按钮
		 */		
		public var exitBtn:IconBtn = new IconBtn;
		
		
		
		
		
		//-----------------------------------------------
		//
		//
		// 面板样式
		//
		//
		//-----------------------------------------------

		
		/**
		 * 退出按钮的样式配置
		 */		
		public var exitBtnStyleXML:XML = <states>
											<normal width='20' height='20'>
												<fill color='#333333' alpha='0'/>
											</normal>
											<hover width='20' height='20'>
												<fill color='#DDDDDD' alpha='1'/>
											</hover>
											<down width='20' height='20'>
												<fill color='#CCCCCC' alpha='1'/>
											</down>
										</states>;
		
		
		/**
		 * 背景样式 
		 */		
		private var bgStyle:Style = new Style;
		
		
		/**
		 * 面板背景样式配置文件
		 */		
		public var bgStyleXML:XML = <style>
										<border color='#CCCCCC' alpha='0'/>
										<fill color='#EFEFEF' alpha='1'/>
									 </style>
		/**
		 * 头部背景样式
		 */			
		private var titleBgStyle:Style = new Style;
		
		/**
		 * 头部背景样式配置文件 
		 */			
		public var titleBgStyleXML:XML = <style>
											<border color='#CCCCCC'/>
											<fill color='#FFFFFF' alpha='0'/>
										 </style>
			
		/**
		 *  标题样式的配置文件
		 */		
		public var titleStyleXML:XML = <label radius='0' vPadding='20' hPadding='20'>
											<format color='#555555' font='华文细黑' size='14'/>
										</label>
			
		
			
		
	}
}