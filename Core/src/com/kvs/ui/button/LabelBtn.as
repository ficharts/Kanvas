package com.kvs.ui.button
{
	import com.kvs.ui.FiUI;
	import com.kvs.ui.label.LabelUI;
	import com.kvs.ui.toolTips.ITipsSender;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	import com.kvs.utils.XMLConfigKit.style.IStyleStatesUI;
	import com.kvs.utils.XMLConfigKit.style.LabelStyle;
	import com.kvs.utils.XMLConfigKit.style.States;
	import com.kvs.utils.XMLConfigKit.style.StatesControl;
	import com.kvs.utils.XMLConfigKit.style.Style;
	import com.kvs.utils.layout.LayoutManager;
	
	/**
	 * 基本的按钮组件
	 */	
	public class LabelBtn extends FiUI implements IStyleStatesUI, ITipsSender
	{
		public function LabelBtn()
		{
			super();
			this.mouseChildren = false;
			this.buttonMode = true;
		}
		
		/**
		 */		
		override protected function init():void
		{
			super.init();
			
			render();
		}
		
		/**
		 */		
		public function updateLabelStyle(style:XML):void
		{
			labelUI.styleXML = style;
			this.render();
		}
		
		/**
		 */		
		public function updateBgStyle(style:XML):void
		{
			bgStyleXML = style;
			
			states.fresh();
			XMLVOMapper.fuck(bgStyleXML, states);
			
			this.render();
		}
		
		/**
		 */		
		public function ready():void
		{
			labelUI.styleXML = labelStyleXML;
			this.addChild(labelUI);
			
			this.states = new States;
			XMLVOMapper.fuck(bgStyleXML, states);
			statesControl = new StatesControl(this, states);
		}
		
		/**
		 */		
		protected var ifReady:Boolean = false;
		
		/**
		 */		
		public function selected():void
		{
			this.mouseEnabled = false;
			
			this.currState = states.getDown;
			this.render();
			
			statesControl.enable = false;
		}
		
		/**
		 */		
		public function disSelect():void
		{
			this.mouseEnabled = true;
			statesControl.enable = true;
			
			this.currState = states.getNormal;
			this.render();
		}
		
		/**
		 */		
		private var statesControl:StatesControl;

		/**
		 */		
		protected var labelUI:LabelUI = new LabelUI;
		
		/**
		 */		
		private var labelStyle:LabelStyle = new LabelStyle;
		
		/**
		 */		
		private var _text:String

		/**
		 */
		public function get text():String
		{
			return _text;
		}

		/**
		 * @private
		 */
		public function set text(value:String):void
		{
			_text = value;
		}
		
		/**
		 */		
		public function render():void
		{
			if (ifReady == false)
			{
				this.ready();
				ifReady = true;
			}
			
			_render();
		}
		
		/**
		 */		
		protected function _render():void
		{
			labelUI.text = text;
			labelUI.render();
			
			checkSize();
			
			this.graphics.clear();
			StyleManager.drawRect(this, currState);
			
			LayoutManager.excuteVLayout(labelUI, this, this.labelStyle.vAlign, labelStyle.padding);
			LayoutManager.excuteHLayout(labelUI, this);
		}
		
		/**
		 */		
		protected function checkSize():void
		{
			if (h != 0)
				currState.height = h;
			else
				currState.height = labelUI.height;
			
			if (w != 0)
				currState.width = w;
			else
				currState.width = labelUI.width;
			
			if (currState.width < minWidth)
				currState.width = minWidth;
		}
		
		/**
		 */		
		public var minWidth:Number = 60;
		
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
			_states = value;
		}
		
		/**
		 */		
		private var _states:States;
		
		/**
		 */		
		public function get currState():Style
		{
			return _style;
		}
		
		/**
		 */		
		public function set currState(value:Style):void
		{
			_style = value;
		}
		
		/**
		 */		
		private var _style:Style;
		
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
		public var bgStyleXML:XML = <states>
										<normal>
											<fill color='#DDDDDD' alpha='0'/>
										</normal>
										<hover>
											<fill color='#EEEEEE, #EFEFEF' alpha='0.8, 0.8' angle="90"/>
										</hover>
										<down>
											<fill color='#DDDDDD' alpha='0.3' angle="90"/>
										</down>
									</states>
			
			
		public var labelStyleXML:XML =  <label vAlign="center">
							                <format color='555555' font='黑体' size='12' letterSpacing="3"/>
							            </label>

	}
}