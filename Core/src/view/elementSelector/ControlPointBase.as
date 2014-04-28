package view.elementSelector
{
	import com.kvs.utils.StageUtil;
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	import com.kvs.utils.XMLConfigKit.style.IStyleStatesUI;
	import com.kvs.utils.XMLConfigKit.style.States;
	import com.kvs.utils.XMLConfigKit.style.StatesControl;
	import com.kvs.utils.XMLConfigKit.style.Style;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	
	import flash.display.Sprite;
	
	/**
	 * 形变控制点， 用来控制图形的比例，尺寸缩放
	 */	
	public class ControlPointBase extends Sprite implements IStyleStatesUI
	{
		public function ControlPointBase()
		{
			super();
			
			this.buttonMode = true;
			StageUtil.initApplication(this, init);
		}
		
		/**
		 */		
		private function init():void
		{
			XMLVOMapper.fuck(styleConfig, this.states);
			statesControl = new StatesControl(this, this.states);
			
			render();
		}
		
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
		protected var _states:States = new States;
		
		/**
		 */		
		protected var statesControl:StatesControl;
		
		/**
		 */		
		public function render():void
		{
			this.graphics.clear();
			
			StyleManager.setShapeStyle(this.style, graphics);
			StyleManager.drawCircle(this, this.style);
		}
		
		/**
		 * 
		 */		
		public function get currState():Style
		{
			return this.style;
		}
		
		/**
		 */		
		public function set currState(value:Style):void
		{
			this.style = value;
		}
		
		/**
		 */		
		protected var style:Style;
		
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
		public var styleConfig:XML = <states>
										<normal tx='-7' ty='-7' width='14' height='14' radius='7'>
											<border color='#4EA6EA' thickness='2'/>
											<fill color='#FFFFFF' alpha='1'/>
										</normal>
										<hover tx='-8' ty='-8' width='16' height='16' radius='8'>
											<border color='#4EA6EA' thickness='2'/>
											<fill color='#FFFFFF' alpha='1'/>
										</hover>
										<down tx='-8' ty='-8' width='16' height='16' radius='8'>
											<border color='#4EA6EA' thickness='2'/>
											<fill color='#4EA6EA' alpha='0.7'/>
										</down>
									</states>
	}
}