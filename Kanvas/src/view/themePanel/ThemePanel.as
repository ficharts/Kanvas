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
	
	import commands.Command;
	
	import control.InteractEvent;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import view.elementSelector.toolBar.StyleBtn;
	import view.themePanel.sound.SoundInserter;
	
	/**
	 * 全局风格设置面板
	 */	
	public class ThemePanel extends Panel implements IColorPanelHost
	{
		public function ThemePanel(kvs:Kanvas)
		{
			super();
			
			style_1;
			style_2;
			style_3;
			style_4;
			style_5;
			style_6;
			style_7;
			style_8;
			style_9;
			style_10;
			style_11;
			style_12;
			style_13;
			style_14;
			style_15;
			style_16;
			style_17;
			style_18;
			style_19;
			style_20;
			style_21;
			style_22;
			style_23;
			style_24;
			
			this.kvs = kvs;
			this.kvs.kvsCore.addEventListener(KVSEvent.THEME_UPDATED, updateCurTheme); 
			this.kvs.kvsCore.addEventListener(KVSEvent.UPDATE_BG_COLOR_LIST, updateBgColorList);
			this.kvs.kvsCore.addEventListener(KVSEvent.UPDATE_BG_COLOR, updateBGColor);
			
		}
		
		/**
		 */		
		public var kvs:Kanvas;
		
		/**
		 */		
		public var sound:SoundInserter
		
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
			if (evt.colorIndex == - 1)
			{
				if (colorPanel.curColorBtn)
					colorPanel.curColorBtn.selected = false;
				
				bgColorIcon.iconColor = evt.bgColor;
				bgColorIcon.render();
			}
			else
			{
				colorPanel.setCurColor(evt.colorIndex);
				
				bgColorIcon.iconColor = colorPanel.curColorBtn.iconColor;
				bgColorIcon.render();
			}
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
			
			sound = new SoundInserter(this);
			addChild(sound);
			
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
			
			var startX:uint = 23;
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
			bgConfigArea.y = barHeight + scrollProxy.viewHeight//h - bgConfigPanelHeight;
			
			layoutColorPanel();
			
			//布局背景音乐插入按钮
			sound.x = (w - sound.width) / 2;
			sound.y = bgConfigArea.y + bgConfigArea.height + 20;
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
				theme.setIcons(theme.themeID, theme.themeID, theme.themeID);
				
				theme.w = themePanelWidth;
				theme.h = 80
					
				theme.iconW = 90;
				theme.iconH = 65;
				
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
			this.dispatchEvent(new InteractEvent(InteractEvent.CLOSE_PANEL));
		}
		
		/**
		 */		
		private var themesXML:XML = <themes>
										<theme themeID='style_1' icon='white_preview'/>
										<theme themeID='style_2' icon='white_preview'/>
										<theme themeID='style_3' icon='white_preview'/>
										<theme themeID='style_4' icon='white_preview'/>
										<theme themeID='style_5' icon='white_preview'/>
										<theme themeID='style_6' icon='white_preview'/>
										<theme themeID='style_7' icon='white_preview'/>
										<theme themeID='style_8' icon='white_preview'/>
										<theme themeID='style_9' icon='white_preview'/>
										<theme themeID='style_10' icon='white_preview'/>
										<theme themeID='style_11' icon='white_preview'/>
										<theme themeID='style_12' icon='white_preview'/>
										<theme themeID='style_13' icon='white_preview'/>
										<theme themeID='style_14' icon='white_preview'/>
										<theme themeID='style_15' icon='white_preview'/>
										<theme themeID='style_16' icon='white_preview'/>
										<theme themeID='style_17' icon='white_preview'/>
										<theme themeID='style_18' icon='white_preview'/>
										<theme themeID='style_19' icon='white_preview'/>
										<theme themeID='style_20' icon='white_preview'/>
										<theme themeID='style_21' icon='white_preview'/>
										<theme themeID='style_22' icon='white_preview'/>
										<theme themeID='style_23' icon='white_preview'/>
										<theme themeID='style_24' icon='white_preview'/>
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
												<fill color='#1b7ed1' alpha='0.8' angle='90'/>
												<img/>
											</down>
										</states>
		
	}
}