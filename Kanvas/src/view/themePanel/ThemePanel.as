package view.themePanel
{
	import com.kvs.ui.Panel;
	import com.kvs.ui.colorPanel.ColorPanel;
	import com.kvs.ui.colorPanel.IColorPanelHost;
	import com.kvs.utils.Map;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	import com.kvs.utils.XMLConfigKit.style.Style;
	import com.kvs.utils.layout.VerticalLayouter;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import control.InteractEvent;
	
	import view.elementSelector.toolBar.StyleBtn;
	
	/**
	 * 全局风格设置面板
	 */	
	public class ThemePanel extends Panel implements IColorPanelHost
	{
		public function ThemePanel(kvs:Kanvas)
		{
			super();
			
			white_preview;
			green_preview;
			red_preview;
			blue_preview;
			yellow_preview;
			black_preview;
			
			this.kvs = kvs;
			this.kvs.kvsCore.addEventListener(KVSEvent.THEME_UPDATED, updateCurTheme); 
			this.kvs.kvsCore.addEventListener(KVSEvent.UPDATE_BG_COLOR_LIST, updateBgColorList);
			this.kvs.kvsCore.addEventListener(KVSEvent.UPDATE_BG_COLOR, updateBGColor);
		}
		
		/**
		 */		
		internal var kvs:Kanvas;
		
		/**
		 */		
		override protected function init():void
		{
			super.init();
			
			exitBtn.addEventListener(MouseEvent.CLICK, exitHandler, false, 0, true);
			
			initThemes();
			initBGPanel();
			
			scrollProxy.updateMask();
			scrollProxy.update();
			
			render();
		}
		
		
		
		
		
		
		//----------------------------------------------------------------
		//
		//
		//
		//  背景颜色及图片设置
		//
		//
		//
		//----------------------------------------------------------------
		
		
		/**
		 */		
		private function updateBgColorList(evt:KVSEvent):void
		{
			colorPanel.dataXML = evt.colorList;
			drawColorPanelBG();
			layoutColorPanel();
		}
		
		/**
		 */		
		private function updateBGColor(evt:KVSEvent):void
		{
			colorPanel.setCurColor(evt.colorIndex);
			
			bgColorIcon.iconColor = colorPanel.curColorBtn.iconColor;
			bgColorIcon.render();
		}
		
		/**
		 */		
		public function previewColor(colorBtn:StyleBtn):void
		{
			kvs.kvsCore.previewBgColor(uint(colorBtn.data));
			
			bgColorIcon.iconColor = colorBtn.iconColor;
			bgColorIcon.render();
		}
		
		/**s
		 */			
		public function panelRollOut(curColorBtn:StyleBtn):void
		{
			kvs.kvsCore.previewBgColor(uint(curColorBtn.data));
			
			bgColorIcon.iconColor = curColorBtn.iconColor;
			bgColorIcon.render();
		}
		
		/**
		 */		
		public function colorSelected(curColorBtn:StyleBtn):void 
		{
			closeColorPanel();
			
			kvs.kvsCore.changeBgColor(uint(curColorBtn.data));
			
			bgColorIcon.iconColor = curColorBtn.iconColor;
			bgColorIcon.render();
		}
		
		/**
		 */		
		private var colorPanel:ColorPanel; 
		
		/**
		 */		
		private function initBGPanel():void
		{
			bgImgInertor = new BGImgInsertor(this);
			addChild(bgConfigArea);
			bgConfigArea.addChild(bgImgInertor);
			
			colorPanel = new ColorPanel(this);
			colorPanel.panelWidth = 120;
			colorPanel.iconWidth = 26;
			colorPanel.iconHeight = 26;
			colorPanel.x = colorPanel.y = 8;
			
			colorPanel.iconStatesXML = <states>
												<normal>
													<fill color='${iconColor}'/>
												</normal>
												<hover radius='30'>
													<border color='ffffff' thickness='1' alpha='1'/>
													<fill color='${iconColor}'/>
												</hover>
												<down radius='30'>
													<border color='ffffff' thickness='2' alpha='1'/>
													<fill color='${iconColor}'/>
												</down>
											</states>
				
			colorPanel.iconBGStatesXML = <states>
											<normal>
												<fill color='#000000' alpha='1'/>
											</normal>
											<hover>
												<fill color='#000000' alpha='1'/>
											</hover>
											<down>
												<fill color='#000000' alpha='1'/>
											</down>
										</states>;
			
			colorPanel.visible = false;
			addChild(colorPanel);
			
			
			bgColorIcon = new StyleBtn;
			bgColorIcon.tips = '背景颜色';
			bgColorIcon.bgStatesXML = <states>
											<normal radius='28'>
												<border color='#999999' alpha='1'/>
											</normal>
											<hover radius='28'>
												<border color='#666666' alpha='1'/>
											</hover>
											<down radius='28'>
												<border color='#000000' alpha='1'/>
											</down>
										</states>;
			
			bgColorIcon.iconStatesXML =  <states>
											<normal radius='24'>
												<fill color='${iconColor}'/>
											</normal>
											<hover radius='24'>
												<fill color='${iconColor}'/>
											</hover>
											<down radius='24'>
												<fill color='${iconColor}'/>
											</down>
										</states>
			
			bgColorIcon.w = bgColorIcon.h = 20;
			bgColorIcon.iconWidth = bgColorIcon.iconHeight = 18;
			
			bgColorIcon.addEventListener(MouseEvent.CLICK, colorBtnClickHandler);
			bgConfigArea.addChild(bgColorIcon);
			
			layoutBGArea();
		}
		
		/**
		 */		
		private function drawColorPanelBG():void
		{
			var panelBGStyle:Style = new Style;
			var panelBGStyleXML:XML = <style>
										<fill color='555555'/>
										<border color='333333'/>
									</style>
			XMLVOMapper.fuck(panelBGStyleXML, panelBGStyle);
			
			var startX:uint = 28;
			var size:uint = 8;
			
			panelBGStyle.width = colorPanel.width - 1;
			panelBGStyle.height = colorPanel.height - 1;
			panelBGStyle.tx = 0;
			panelBGStyle.ty = 0;
			
			colorPanel.graphics.clear();
			
			StyleManager.setShapeStyle(panelBGStyle, colorPanel.graphics);
			colorPanel.graphics.moveTo(startX, panelBGStyle.height + size);
			colorPanel.graphics.lineTo(startX - size, panelBGStyle.height - 2);
			colorPanel.graphics.lineTo(startX + size, panelBGStyle.height - 2);
			colorPanel.graphics.lineTo(startX, panelBGStyle.height + size);
			colorPanel.graphics.endFill();
			
			StyleManager.drawRect(colorPanel, panelBGStyle);
		}
		
		
		/**
		 */		
		private var colorPanelBgStyle:Style = new Style;
		
		/**
		 */		
		private var colorPanelBgStyleXML:XML = <style>
												<fill color='555555'/>
												<border color='333333'/>
											</style>
		
		private function colorBtnClickHandler(evt:MouseEvent):void
		{
			evt.stopImmediatePropagation();
			
			colorPanel.visible = true;
			
			stage.addEventListener(MouseEvent.CLICK, outsideClickHandler);
			
			kvs.kvsCore.mouseChildren = kvs.kvsCore.mouseEnabled = 
				bgConfigArea.mouseChildren = bgConfigArea.mouseEnabled = 
				themesContainer.mouseChildren = themesContainer.mouseEnabled = false;
			
			bgColorIcon.selected = true;
		}
		
		/**
		 */		
		private function outsideClickHandler(evt:MouseEvent):void
		{
			if (!colorPanel.hitTestPoint(stage.mouseX, stage.mouseY, true))
			{
				closeColorPanel();
			}
		}
		
		/**
		 */		
		private function closeColorPanel():void
		{
			colorPanel.visible = false;
			bgColorIcon.selected = false;
			
			stage.removeEventListener(MouseEvent.CLICK, outsideClickHandler);
			colorPanel.removeEventListener(MouseEvent.CLICK, outsideClickHandler);
			
			kvs.kvsCore.mouseChildren = kvs.kvsCore.mouseEnabled = 
				bgConfigArea.mouseChildren = bgConfigArea.mouseEnabled = 
				themesContainer.mouseChildren = themesContainer.mouseEnabled = true;
		}
		
		
		/**
		 */		
		private function layoutBGArea():void
		{
			bgImgInertor.y = 20;
			bgImgInertor.x = (w - bgImgInertor.width) / 2;
			
			bgColorIcon.x = bgImgInertor.x + 8;
			bgColorIcon.y = bgImgInertor.y + 8;
			
			bgConfigArea.x = 3;
			bgConfigArea.y = h - bgConfigPanelHeight;
			
			layoutColorPanel();
		}
		
		/**
		 */		
		private function layoutColorPanel():void
		{
			colorPanel.x = (w - colorPanel.width) / 2 - 1;
			colorPanel.y = scrollProxy.viewHeight - colorPanel.height + barHeight + 23;
		}
		
		/**
		 */		
		internal function get bgConfigPanelHeight():Number
		{
			return bgConfigArea.getBounds(bgConfigArea).bottom + 17;
		}
		
		/**
		 */		
		private var bgColorIcon:StyleBtn;
		
		/**
		 */		
		internal var bgConfigArea:Sprite = new Sprite;
		
		
		
		
		
		
		
		
		
		
		
		//----------------------------------------------------------------
		//
		//
		//
		// 样式模板
		//
		//
		//
		//----------------------------------------------------------------
		
		/**
		 */		
		private var bgImgInertor:BGImgInsertor;
		
		/**
		 * 核心core
		 */		
		public function updateCurTheme(evt:KVSEvent):void
		{
			if (currTheme)
				currTheme.selected = false;
			
			currTheme = themes.getValue(evt.themeID);
			currTheme.selected = true;
		}
		
		/**
		 */		
		private var currTheme:ThemeItem;
		
		/**
		 */		
		override public function updateLayout():void
		{
			super.updateLayout();
			
			layoutBGArea();
			scrollProxy.updateMask();
			scrollProxy.update();
		}
		
		/**
		 */		
		override protected function renderBG():void
		{
			super.renderBG();
		}
		
		/**
		 */		
		internal var themesContainer:Sprite = new Sprite;
		
		/**
		 */		
		private function initThemes():void
		{
			scrollProxy = new ThemesScrollProxy(this);
			addChild(themesContainer);
			
			layouter.gap = 0;
			layouter.locX = 0;
			layouter.locY = barHeight;
			layouter.ready();
			
			var theme:ThemeItem;
			for each (var themeXML:XML in themesXML.children())
			{
				theme = new ThemeItem;
				XMLVOMapper.fuck(themeXML, theme);
				theme.styleXML = themeIconStyle;
				theme.setIcons(theme.icon, theme.icon, theme.icon);
				
				theme.w = themePanelWidth;
				theme.h = 80
					
				theme.iconW = 90;
				theme.iconH = 65.45;
				
				layouter.layout(theme);
				themesContainer.addChild(theme);
				themes.put(theme.themeID, theme);
			}
			
			themesContainer.addEventListener(MouseEvent.CLICK, themeClickedHandler, false, 0, true);
		}
		
		/**
		 */		
		private var scrollProxy:ThemesScrollProxy;
		
		/**
		 */		
		private function themeClickedHandler(evt:MouseEvent):void
		{
			if (evt.target is ThemeItem) 
			{
				kvs.kvsCore.changeTheme((evt.target as ThemeItem).themeID);
			}
		}
		
		/**
		 */		
		internal function get themePanelWidth():Number
		{
			return this.w;
		}
		
		/**
		 */		
		internal function get themePanelHeight():Number
		{
			return layouter.height;
		}
		
		/**
		 */		
		private var layouter:VerticalLayouter = new VerticalLayouter;
		
		/**
		 * 存放样式模板的
		 */		
		private var themes:Map = new Map;
		
		/**
		 */		
		private function exitHandler(evt:MouseEvent):void
		{
			this.dispatchEvent(new InteractEvent(InteractEvent.CLOSE_THEME_PANEL));
		}
		
		/**
		 */		
		private var themesXML:XML = <themes>
										<theme themeID='White' icon='white_preview'/>
										<theme themeID='Green' icon='green_preview'/>
										<theme themeID='Red' icon='red_preview'/>
										<theme themeID='Blue' icon='blue_preview'/>
										<theme themeID='Yellow' icon='yellow_preview'/>
										<theme themeID='Black' icon='black_preview'/>
									</themes>
			
		/**
		 */			
		private var themeIconStyle:XML = <states>
											<normal>
												<fill color='#FFFFFF' alpha='0'/>
												<img/>
											</normal>
											<hover>
												<fill color='#DDDDDD' alpha='0.8'/>
												<img/>
											</hover>
											<down>
												<fill color='#539fd8, #3c92e0' alpha='0.8, 0.8' angle='90'/>
												<img/>
											</down>
										</states>
		
	}
}