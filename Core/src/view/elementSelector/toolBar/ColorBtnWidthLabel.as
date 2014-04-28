package view.elementSelector.toolBar
{
	import com.kvs.ui.label.LabelUI;
	import com.kvs.utils.XMLConfigKit.style.LabelStyle;

	/**
	 * 底部有label的颜色选择按钮
	 */	
	public class ColorBtnWidthLabel extends StyleBtn
	{
		public function ColorBtnWidthLabel()
		{
			super();
		}
		
		/**
		 */		
		override protected function _ready():void
		{
			super._ready();
			
			labelUI.style = this.labelStyle;
			labelUI.styleXML = labelStyleXML;
			this.addChild(labelUI);
		}
		
		/**
		 */		
		override public function render():void
		{
			_render();
			
			labelUI.text = text;
			labelUI.render();
			
			labelUI.x = (w - labelUI.width) / 2;
			labelUI.y = (h - labelUI.height);
			
			iconShape.x = (w - iconWidth) / 2;
			iconShape.y = (labelUI.y - iconWidth) / 2;
		}
		
		/**
		 */		
		public var text:String = 'label';
		
		/**
		 */		
		protected var labelUI:LabelUI = new LabelUI;
		
		/**
		 */		
		private var labelStyle:LabelStyle = new LabelStyle;
		
		/**
		 */		
		public var labelStyleXML:XML =  <label vAlign="center" paddingBottom='5' paddingTop='0'>
											<format color='#ffffff' font='微软雅黑' size='10' letterSpacing="3"/>
										</label>
		
		
	}
}