package com.kvs.ui.button
{
	import com.kvs.ui.FiUI;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	import com.kvs.utils.XMLConfigKit.style.IStyleStatesUI;
	import com.kvs.utils.XMLConfigKit.style.States;
	import com.kvs.utils.XMLConfigKit.style.StatesControl;
	import com.kvs.utils.XMLConfigKit.style.Style;
	import com.kvs.utils.XMLConfigKit.style.elements.Img;
	import com.kvs.utils.graphic.BitmapUtil;
	
	/**
	 * 仅有图标构成的按钮, 图标可随按钮状态切换时也切换
	 */	
	public class IconBtn extends FiUI implements IStyleStatesUI
	{
		public function IconBtn()
		{
			super();
		}
		
		/**
		 * 
		 */		
		public function set selected(value:Boolean):void
		{
			ready();
			
			_selected = value;
			
			if (_selected)
			{
				this.mouseEnabled = false;
				statesControl.enable = false;
				this.statesControl.toDown();		
			}
			else
			{
				this.statesControl.toNormal();
				statesControl.enable = true;
				this.mouseEnabled = true;
			}	
		}
		
		/**
		 */		
		public function get selected():Boolean
		{
			return _selected;			
			
		}
		
		/**
		 */		
		private var _selected:Boolean = false;
		
		/**
		 */		
		override protected function init():void
		{
			super.init();
			
			this.mouseChildren = false;
			this.buttonMode = true;
			
			
			ready();
			this.render();
		}
		
		/**
		 */		
		private function ready():void
		{
			if (ifReady == false)
			{
				this.states = new States;
				XMLVOMapper.fuck(styleXML, states);
				statesControl = new StatesControl(this, states);
				
				ifReady = true;
			}
		}
		
		/**
		 */		
		private var ifReady:Boolean = false;
		
		/**
		 * 设置图片
		 */		
		public function setIcons(normalImg:String, hoverImg:String, downImg:String):void
		{
			ready();
			
			states.width = w;
			states.height = h;
			
			states.getNormal.getImg.classPath = normalImg;
			states.getHover.getImg.classPath = hoverImg;
			states.getDown.getImg.classPath = downImg;
		}
		
		/**
		 */		
		protected var statesControl:StatesControl;
		
		/**
		 */		
		public function get states():States
		{
			return _states;
		}
		
		/**
		 */		
		private var _states:States;
		
		/**
		 */		
		public function set states(value:States):void
		{
			_states = value;
		}
		
		/**
		 * 先绘制背景， 在绘制图片，最后绘制边框
		 */		
		public function render():void
		{
			this.graphics.clear()
			
			if (w != 0)
				currState.width = w;
			
			if (h != 0)
				currState.height = h;
				
			StyleManager.setFillStyle(this.graphics, currState);
			this.graphics.drawRoundRect(0, 0, this.currState.width, currState.height, currState.radius, currState.radius);	
			this.graphics.endFill();
			
			var img:Img = currState.getImg;
			img.ready();
			
			if (isNaN(iconW))
				iconW = img.width;
			
			if (isNaN(iconH))
				iconH = img.height;
			
			var tx:Number = (currState.width - iconW) / 2;
			var ty:Number = (currState.height - iconH) / 2;
			BitmapUtil.drawBitmapDataToSprite(img.data, this, iconW, iconH, tx, ty, true);
			this.graphics.endFill();
			
			StyleManager.setLineStyle(this.graphics, currState.getBorder, currState);
			this.graphics.drawRoundRect(0, 0, this.currState.width, currState.height, currState.radius, currState.radius);	
			this.graphics.endFill();
			
			StyleManager.setEffects(this, currState);
		}
		
		/**
		 */		
		public var iconW:Number = NaN;
		public var iconH:Number = NaN;
		
		/**
		 */		
		public function get currState():Style
		{
			return style;
		}
		
		/**
		 */		
		public function set currState(value:Style):void
		{
			style = value;
		}
		
		/**
		 */		
		private var style:Style;
		
		/**
		 */		
		public function hoverHandler():void
		{
		}
		
		/**
		 */		
		public function normalHandler():void
		{
		}
		
		/**
		 */		
		public function downHandler():void
		{
		}
		
		/**
		 */		
		public var styleXML:XML = <states>
										<normal>
											<fill color='#FFFFFF' alpha='0'/>
											<img/>
										</normal>
										<hover>
											<fill color='#FFFFFF' alpha='0'/>
											<img/>
										</hover>
										<down>
											<fill color='#2494E6' alpha='0'/>
											<img/>
										</down>
									</states>
	}
}