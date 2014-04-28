package view.editor.text
{
	import com.kvs.ui.FiUI;
	import com.kvs.ui.colorPanel.ColorPanel;
	import com.kvs.ui.colorPanel.IColorPanelHost;
	import com.kvs.utils.ViewUtil;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	import com.kvs.utils.XMLConfigKit.style.Style;
	import com.kvs.utils.layout.BoxLayout;
	
	import view.elementSelector.toolBar.StyleBtn;
	
	/**
	 * 字体颜色选择面板
	 */	
	public class FontColorsPanel extends FiUI implements IColorPanelHost
	{
		public function FontColorsPanel(stylePanel:TextStylePanel)
		{
			super();
			
			this.stylePanel = stylePanel;
		}
		
		/**
		 */		
		public function previewColor(colorBtn:StyleBtn):void
		{
			stylePanel.changeFontColor(colorBtn.iconColor);
		}
		
		/**s
		 */			
		public function panelRollOut(curColorBtn:StyleBtn):void
		{
			stylePanel.changeFontColor(curColorBtn.iconColor);
		}
		
		/**
		 */		
		public function colorSelected(curColorBtn:StyleBtn):void 
		{
			stylePanel.changeFontColor(curColorBtn.iconColor);
			
			stylePanel.colorSelectBtn.data = curColorBtn.data;
			stylePanel.colorSelectBtn.selected = false;
			
			this.hide();
		}
		
		
		/**
		 */		
		private var colorPanel:ColorPanel;
		
		/**
		 */		
		private var stylePanel:TextStylePanel;
		
		/**
		 */		
		override protected function init():void
		{
			super.init();
			
			this.colorPanel = new ColorPanel(this);
			
			colorPanel.iconGutter = 4;
			colorPanel.iconWidth = iconSize;
			colorPanel.iconHeight = iconSize;
			colorPanel.bgStyleXML = <style>
										<fill color="ffffff"/>
									</style>;
			
			colorPanel.iconBGStatesXML = colorBgStatesXML;
			colorPanel.iconStatesXML = colorIconStatesXML;
			
			addChild(colorPanel);
			
			XMLVOMapper.fuck(bgStyleXML, bgStyle);
		}
		
		/**
		 */		
		private var iconSize:uint = 26;
		
		/**
		 * 根据配置文件，构建颜色内容
		 */		
		public function update(xml:XML):void
		{
			colorPanel.panelWidth = iconSize * 10;
			colorPanel.dataXML = xml;
			colorPanel.x = - colorPanel.panelWidth / 2;
			colorPanel.y = - colorPanel.height;
			
			drawBg();
		}
		
		/**
		 */		
		private function drawBg():void
		{
			var gap:uint = 4;
			
			bgStyle.tx = - colorPanel.panelWidth / 2 - gap;
			bgStyle.ty = - colorPanel.height - gap;
			bgStyle.width = colorPanel.panelWidth + gap * 2; 
			bgStyle.height = colorPanel.height  + gap * 2;
			
			this.graphics.clear();
			
			//底部三角刑
			this.graphics.lineStyle(0, 0xDEDEDE);
			this.graphics.beginFill(uint(bgStyle.getFill.color));
			this.graphics.moveTo(0, gap * 2 + 6);
			this.graphics.lineTo(- gap * 2, gap);
			this.graphics.lineTo(gap * 2, gap);
			this.graphics.lineTo(0, gap * 2 + 6);
			this.graphics.endFill();
			
			// 灰色背景
			graphics.lineStyle(0, 0xcccccc);
			StyleManager.setShapeStyle(bgStyle, graphics);
			this.graphics.drawRect(bgStyle.tx, bgStyle.ty, bgStyle.width, bgStyle.height);
			this.graphics.endFill();
			
			 //白色背景
			this.graphics.beginFill(0xfffffff);
			this.graphics.drawRect(bgStyle.tx + 3, bgStyle.ty + 3, bgStyle.width - 6, bgStyle.height - 6);
			this.graphics.endFill();
			
			//灰色边框
			this.graphics.lineStyle(0, 0xDEDEDE);
			this.graphics.drawRect(bgStyle.tx, bgStyle.ty, bgStyle.width, bgStyle.height);
			this.graphics.endFill();
			
		}
			
		/**
		 */		
		private var btns:Vector.<StyleBtn> = new Vector.<StyleBtn>;
		
		/**
		 */		
		private var boxLayout:BoxLayout = new BoxLayout;
		
		/**
		 */		
		public function show():void
		{
			ViewUtil.show(this);
			
			colorPanel.setCurColor(uint(stylePanel.colorSelectBtn.data));
		}
		
		/**
		 */		
		public function hide():void
		{
			ViewUtil.hide(this);
		}
		
		/**
		 */		
		private var colorBgStatesXML:XML = <states>
											<normal>
												<fill color='#FFFFFF' alpha='0'/>
											</normal>
											<hover>
												<fill color='#FFFFFF' alpha='0'/>
											</hover>
											<down>
												<fill color='#FFFFFF' alpha='0'/>
											</down>
										</states>
			
		/**
		 */		
		private var colorIconStatesXML:XML = <states>
												<normal radius='0'>
													<border color='CCCCCC' thickness='0.1' alpha='1'/>
													<fill color='${iconColor}'/>
												</normal>
												<hover radius='30'>
													<border color='CCCCCC' thickness='1' alpha='1'/>
													<fill color='${iconColor}'/>
												</hover>
												<down radius='30'> 
													<border color='CCCCCC' thickness='1' alpha='1'/>
													<fill color='${iconColor}'/>
												</down>
											</states>
			
		
		
		/**
		 */		
		private var bgStyle:Style = new Style;
		
		/**
		 */		
		private var bgStyleXML:XML = <style>
										<fill color='eeeeee'/>
									</style>
	}
}