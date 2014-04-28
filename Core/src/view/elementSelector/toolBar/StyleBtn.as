package view.elementSelector.toolBar
{
	import com.kvs.ui.FiUI;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	import com.kvs.utils.XMLConfigKit.style.IStyleStatesUI;
	import com.kvs.utils.XMLConfigKit.style.States;
	import com.kvs.utils.XMLConfigKit.style.StatesControl;
	import com.kvs.utils.XMLConfigKit.style.Style;
	import com.kvs.utils.layout.IBoxItem;
	
	import flash.display.Shape;
	
	/**
	 * 在颜色/样式面板中，标识颜色/样式单元
	 */	
	public class StyleBtn extends FiUI implements IStyleStatesUI, IBoxItem
	{
		public function StyleBtn()
		{
			this.mouseChildren = false;
			this.buttonMode = true;
			
			super();
		}
		
		/**
		 */		
		private var _data:Object = 0;

		/**
		 */
		public function get data():Object
		{
			return _data;
		}

		/**
		 * @private
		 */
		public function set data(value:Object):void
		{
			_data = value;
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
		public function set selected(value:Boolean):void
		{
			ready();
			
			_selected = value;
			
			if (_selected)
			{
				this.mouseEnabled = false;
				if (statesControl)
				{
					statesControl.enable = false;
					statesControl.toDown();
				}
			}
			else
			{
				this.mouseEnabled = true;
				if (statesControl)
				{
					statesControl.enable = true;
					statesControl.toNormal();
				}
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
		private function ready():void
		{
			if (isReady == false)
			{
				_ready();
				
				isReady = true;
			}
		}
		
		/**
		 */		
		protected function _ready():void
		{
			XMLVOMapper.fuck(iconStatesXML, iconStates);
			iconStyle = iconStates.getNormal;
			
			XMLVOMapper.fuck(bgStatesXML, states);
			
			statesControl = new StatesControl(this, states);
			this.addChild(iconShape);
		}
			
		
		/**
		 */		
		private var isReady:Boolean = false;
		
		/**
		 */		
		private var statesControl:StatesControl;
		
		
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
		private var _states:States = new States;
		
		/**
		 */		
		public function render():void
		{
			_render();
			
			iconShape.x = (w - iconWidth) / 2;
			iconShape.y = (h - iconHeight) / 2;
		}
		
		/**
		 */		
		protected function _render():void
		{
			ready();
			
			this.graphics.clear();
			currState.width = w;
			currState.height = h;
			StyleManager.drawRect(this, currState);
			
			iconShape.graphics.clear();
			iconStyle.width = iconWidth;
			iconStyle.height = iconHeight;
			StyleManager.drawRectOnShape(iconShape, iconStyle, this);
		}
		
		/**
		 * 此属性时为了兼容全样式图形在快捷工具条中的样式选择按钮； 
		 */		
		public var thickness:uint = 3;
		
		/**
		 */		
		public var iconWidth:uint = 15;
		
		public var iconHeight:uint = 15;
		
		/**
		 */		
		protected var iconShape:Shape = new Shape;
		
		/**
		 */		
		public function get currState():Style
		{
			return _bgStyle;
		}
		
		/**
		 */		
		public function set currState(value:Style):void
		{
			_bgStyle = value;
		}
		
		/**
		 */		
		private var _bgStyle:Style;
		
		/**
		 */		
		public function hoverHandler():void
		{
			iconStyle = iconStates.getHover;
		}
		
		/**
		 */		
		public function normalHandler():void
		{
			iconStyle = iconStates.getNormal;
		}
		
		/**
		 */		
		public function downHandler():void
		{
			iconStyle = iconStates.getDown;
		}
		
		
		/**
		 * 图标的颜色
		 */		
		public var iconColor:Object;
		
		/**
		 * 控制图标状态 
		 */		
		public var iconStates:States = new States;
		
		/**
		 */		
		public var iconStatesXML:XML = <states>
											<normal>
												<fill color='${iconColor}'/>
											</normal>
											<hover>
												<fill color='${iconColor}'/>
											</hover>
											<down>
												<fill color='${iconColor}'/>
											</down>
										</states>
		/**
		 */		
		public var iconStyle:Style = new Style;
		
		
		/**
		 * 定义了按钮背景颜色，这个颜色可以响应鼠标状态
		 */		
		public var bgStatesXML:XML;
		
	}
}