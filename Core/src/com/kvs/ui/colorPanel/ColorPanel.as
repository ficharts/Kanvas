package com.kvs.ui.colorPanel
{
	import com.kvs.utils.Map;
	import com.kvs.utils.StageUtil;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	import com.kvs.utils.XMLConfigKit.style.Style;
	import com.kvs.utils.layout.BoxLayout;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import view.elementSelector.toolBar.StyleBtn;
	
	/**
	 * 颜色面板
	 */	
	public class ColorPanel extends Sprite
	{
		public function ColorPanel(host:IColorPanelHost)
		{
			super();
			
			this.host = host;
			StageUtil.initApplication(this, init);
		}
		
		/**
		 */		
		private var host:IColorPanelHost
		
		/**
		 */		
		public function setCurColor(colorIndex:uint):void
		{
			if (curColorBtn)
				curColorBtn.selected = false;
			
			curColorBtn = colorBtns.getValue(colorIndex);
			curColorBtn.selected = true;
		}
		
		/**
		 */		
		public var curColorBtn:StyleBtn;
		
		
		private var lastColor:StyleBtn;
		
		/**
		 */		
		private function init():void
		{
			if (ifBgStyleInit == false)
				bgStyleXML = _bgStyle;
			
			addEventListener(MouseEvent.MOUSE_OVER, overColorHandler);
			addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			addEventListener(MouseEvent.CLICK, colorSelected);
		}
		
		/**
		 */		
		private function colorSelected(evt:MouseEvent):void
		{
			if (evt.target is StyleBtn)
			{
				if (curColorBtn)
					curColorBtn.selected = false;
				
				//lastColor = curColor;
				curColorBtn = evt.target as StyleBtn;
				curColorBtn.selected = true;
				
				host.colorSelected(curColorBtn);
			}
		}
		
		/**
		 */		
		private function rollOutHandler(evt:MouseEvent):void
		{
			host.panelRollOut(curColorBtn);
		}
		
		/**
		 */		
		private function overColorHandler(evt:MouseEvent):void
		{
			if (evt.target is StyleBtn)
				host.previewColor(evt.target as StyleBtn);
		}
		
		/**
		 */		
		public function set dataXML(value:XML):void
		{
			colorBtns.clear();
			
			while (numChildren)
				removeChildAt(0);
			
			boxLayout.setLoc(0, 0);
			boxLayout.setItemSizeAndFullWidth(panelWidth, iconWidth, iconHeight);
			boxLayout.ready();
			
			var colorBtn:StyleBtn;
			var index:uint = 0;
			for each (var item:XML in value.children())
			{
				colorBtn = new StyleBtn();
				colorBtn.data = index;
				
				colorBtn.iconColor = StyleManager.setColor(item.toString());
				colorBtn.bgStatesXML = iconBGStatesXML;
				colorBtn.iconStatesXML = iconStatesXML;
				
				colorBtn.w = iconWidth;
				colorBtn.h = iconHeight;
				
				colorBtn.iconWidth = iconWidth - iconGutter;
				colorBtn.iconHeight = iconHeight - iconGutter;
				
				boxLayout.layout(colorBtn);
				addChild(colorBtn);
				colorBtns.put(colorBtn.data, colorBtn);
				
				index ++;
			}
			
			this.graphics.clear();
			bgStyle.width = panelWidth;
			bgStyle.height = boxLayout.getRectHeight();
			StyleManager.drawRect(this, bgStyle);
		}
		
		
		/**
		 * 颜色按钮内间距 
		 */		
		public var iconGutter:uint = 1;
		
		/**
		 */		
		private var colors:Map = new Map;
		
		/**
		 */		
		public function set bgStyleXML(value:XML):void
		{
			_bgStyle = value;
			
			XMLVOMapper.fuck(_bgStyle, bgStyle);
			ifBgStyleInit = true;
		}
		
		/**
		 */		
		private var ifBgStyleInit:Boolean = false;
		
		
		/**
		 */		
		private var bgStyle:Style = new Style;
		
		/**
		 */		
		public var panelWidth:uint = 250;

		/**
		 */		
		public var iconWidth:uint = 50;
		
		public var iconHeight:uint = 50;
		
		/**
		 */		
		private var boxLayout:BoxLayout = new BoxLayout;
		
		/**
		 */		
		private var colorBtns:Map = new Map;
		
		/**
		 */		
		private var _bgStyle:XML = <style>
										<border color='#CCCCCC' alpha='0'/>
										<fill color='#555555' alpha='0'/>
									</style>
		
		/**
		 * 颜色按钮背景状态样式
		 */		
		public var iconBGStatesXML:XML = <states>
											<normal>
												<border thickness='1' color='#DDDDDD' alpha='0'/>
												<fill color='#555555' alpha='0'/>
											</normal>
											<hover>
												<border thickness='1' color='eeeeee'/>
												<fill color='#FFFFFF' alpha='1'/>
											</hover>
											<down>
												<border thickness='2' color='ffffff'/>
												<fill color='#333333' alpha='1' angle="90"/>
											</down>
										</states>;
			
		/**
		 * 颜色按钮颜色的样式
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
	}
}