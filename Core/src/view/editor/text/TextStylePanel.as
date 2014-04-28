package view.editor.text
{
	import com.kvs.ui.clickMove.ClickMoveControl;
	import com.kvs.ui.clickMove.IClickMove;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	import com.kvs.utils.XMLConfigKit.style.Style;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import model.CoreFacade;
	import model.CoreProxy;
	import model.vo.TextVO;
	
	import util.StyleUtil;
	
	import view.elementSelector.toolBar.StyleBtn;
	
	/**
	 * 文本编辑器的样式控制面板，负责字体样式控制
	 * 
	 * 可以拖动
	 */	
	public class TextStylePanel extends Sprite implements IClickMove
	{
		public function TextStylePanel(editor:TextEditor)
		{
			super();
			
			this.editor = editor;
			
			bgShape.alpha = 1;
			addChild(bgShape);
			XMLVOMapper.fuck(bgStyleXML, bgStyle);
			bgShape.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownPanel, false, 0, true);
		
			fontStyleBtnsC.addEventListener(MouseEvent.CLICK, styleSelectedHandler, false, 0, true);
			this.addChild(fontStyleBtnsC);
			
			colorSelectBtn.w = colorSelectBtn.h = 22;
			colorSelectBtn.iconWidth = 18;
			colorSelectBtn.iconHeight = 18;
			colorSelectBtn.bgStatesXML = <states>
											<normal radius='24'>
												<border thickness='2' color='CCCCCC'/>
												<fill color='#555555' alpha='0'/>
											</normal>
											<hover radius='24'>
												<border thickness='2' color='999999'/>
											</hover>
											<down radius='24'>
												<border color='#555555' alpha='1' angle="90"/>
											</down>
										</states>;
			
			colorSelectBtn.iconStatesXML = <states>
												<normal radius='20'>
													<fill color='${iconColor}'/>
												</normal>
												<hover radius='20'>
													<fill color='${iconColor}'/>
												</hover>
												<down radius='20'>
													<fill color='${iconColor}'/>
												</down>
											</states>
			
			colorSelectBtn.addEventListener(MouseEvent.CLICK, openColorPanel, false, 0, true);
			addChild(colorSelectBtn);
			
			fontColors = new FontColorsPanel(this);
			fontColors.hide();
			addChild(fontColors);
			
			clickMoveControl = new ClickMoveControl(this, bgShape);
		}
		
		
		
		
		
		
		
		//----------------------------------------------
		//
		//
		// 字体样式控制
		//
		//
		//-----------------------------------------------
		
		/**
		 */		
		private function styleSelectedHandler(evt:MouseEvent):void
		{
			evt.stopPropagation();
			
			curStyleBtn.statesControl.enable = true;
			
			if (evt.target is TextStyleBtn)
			{
				curStyleBtn = evt.target as TextStyleBtn;
				curStyleBtn.statesControl.enable = false;
				curStyleBtn.parent.addChild(curStyleBtn);//防止边角被遮住，因为样式按钮都是贴边1像素在一起的
				
				curStyleBtn.textVO.color = colorSelectBtn.iconColor;
				curStyleBtn.textVO.colorIndex = uint(colorSelectBtn.data);
		
				editor.textField.applyStyle(curStyleBtn.textVO);
				
				colorSelectBtn.render();
			}
		}
		
		/**
		 * 获取当前文本的样式
		 */		
		public function getStyle(textVO:TextVO):void
		{	
			textVO.styleID = curStyleBtn.id;
			textVO.colorIndex = uint(colorSelectBtn.data);
			
			//用户选取了另外的颜色，则认为采用了自定义颜色，此文本颜色不随样式模版
			if (curStyleBtn.textVO.colorIndex == textVO.colorIndex)
				textVO.isCustomColor = false;
			else
				textVO.isCustomColor = true;
			
			editor.textField.getTextVO(textVO);
		}
			
		/**
		 * 編輯文字時，將文本模型傳遞進來，用於更新樣式
		 * 
		 * 面板狀態和文本輸入框的內容, 同时更新颜色信息
		 */		
		public function setStyle(textVO:TextVO):void
		{
			for each (var item:TextStyleBtn in styleBtns)
			{
				if (item.id == textVO.styleID)
				{
					curStyleBtn = item;
					
					curStyleBtn.statesControl.enable = false;
					editor.textField.applyTextVO(textVO);
					
					// 记录下文字的颜色信息
					colorSelectBtn.iconColor = textVO.color;
					colorSelectBtn.data = textVO.colorIndex;
					
					colorSelectBtn.render();
				}
				else
				{
					item.statesControl.enable = true;
				}
			}
		}
		
		/**
		 * 颜色选择后触发
		 */		
		public function changeFontColor(color:Object):void
		{
			colorSelectBtn.iconColor = color;
			colorSelectBtn.render();
			
			editor.textField.updateColor(color);
		}
		
		/**
		 */		
		private var curStyleBtn:TextStyleBtn;
		
		/**
		 * 初始化样式, 切换全局样式模板时也会用到
		 */		
		public function styleBtnsInit():void
		{
			//清空数据
			styleBtns.length = 0;
			while (fontStyleBtnsC.numChildren)
				fontStyleBtnsC.removeChildAt(0);
			
			// 根据配置信息，创建样式按钮
			var styles:XML = XMLVOMapper.getStyleXMLBy_ID('text', 'template')  as XML;
			var textStyleBtn:TextStyleBtn;
			for each (var item:XML in styles.children())
			{
				textStyleBtn = new TextStyleBtn;
				XMLVOMapper.fuck(item, textStyleBtn.textVO);
				
				StyleUtil.applyStyleToElement(textStyleBtn.textVO);
				
			
			
				addStyleBtn(textStyleBtn);
				
				if (textStyleBtn.id == 'Title')
					setStyle(textStyleBtn.textVO);
			}
			
			//保证当前所选样式按钮位于最顶层
			fontStyleBtnsC.addChild(curStyleBtn)
			
			fontStyleBtnsC.x = 0 ;
			fontStyleBtnsC.y = - editor.offSet - panelUnitHeight + (panelUnitHeight - fontStyleBtnsC.height) / 2;
			
			colorSelectBtn.x = fontStyleBtnsC.x + fontStyleBtnsC.width + 10;
			colorSelectBtn.y = - editor.offSet - panelUnitHeight + (panelUnitHeight - colorSelectBtn.height) / 2;
			
			//更新文本颜色般
			fontColors.update(XMLVOMapper.getStyleXMLBy_ID('text', 'colors') as XML);
		}
		
		/**
		 */		
		private var styleBtns:Vector.<TextStyleBtn> = new Vector.<TextStyleBtn>;
		
		/**
		 */		
		private function addStyleBtn(btn:Sprite):void
		{
			//让按钮恰好贴边靠拢
			if (fontStyleBtnsC.numChildren)
				btn.x = fontStyleBtnsC.width - 1;
			else
				btn.x = fontStyleBtnsC.width;
				
			fontStyleBtnsC.addChild(btn);
			styleBtns.push(btn);
		}
		
		/**
		 */		
		private var fontStyleBtnsC:Sprite = new Sprite;
		

		
		
		
		
		//----------------------------------------------
		//
		//
		// 颜色控制
		//
		//
		//-----------------------------------------------
		
		/**
		 */		
		private function openColorPanel(evt:MouseEvent):void
		{
			colorSelectBtn.selected = true;
			fontColors.show();
		}
		
		/**
		 */		
		private var fontColors:FontColorsPanel;
		
		/**
		 */		
		public var colorSelectBtn:StyleBtn = new StyleBtn;
		
		
		
		
		
		
		
		//----------------------------------------------
		//
		//
		// 面板控制
		//
		//
		//-----------------------------------------------
		
		
		public function moveOff(xOff:Number, yOff:Number):void
		{
		}
			
		/**
		 */		
		public function clicked():void
		{
			if (colorSelectBtn.selected == true)
			{
				colorSelectBtn.selected = false;
				fontColors.hide();
			}
		}
		
		/**
		 */		
		public function startMove():void
		{
		}
			
		/**
		 */			
		public function stopMove():void
		{
			
		}
		
		/**
		 */		
		private var clickMoveControl:ClickMoveControl;
		
		
		/**
		 */		
		private function mouseDownPanel(evt:MouseEvent):void
		{
			bgShape.alpha = 0.5;
			
			editor.startDrag();
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpPanel, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, draggingPanel, false, 0, true);
		}
		
		/**
		 */		
		private function mouseUpPanel(evt:MouseEvent):void
		{
			bgShape.alpha = 1;
				
			editor.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpPanel);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, draggingPanel);
		}
		
		/**
		 */		
		private function draggingPanel(evt:MouseEvent):void
		{
			editor.synTextProxy();
		}
									   
		/**
		 */		
		public function updateSize():void
		{
			bgShape.graphics.clear();
			
			bgStyle.width = editor.fieldWidth + editor.offSet * 2;
			
			if (bgStyle.width < panelMinWidth)
				bgStyle.width = panelMinWidth;
			
			bgStyle.height = panelUnitHeight;
			
			bgStyle.tx = - editor.offSet;
			bgStyle.ty = - editor.offSet - bgStyle.height;
			
			StyleManager.drawRect(bgShape, bgStyle);
			
			//绘制头部灰色条
			var topH:uint = 10;
			bgShape.graphics.lineStyle(1, 0xDDDDDD, 0);
			bgShape.graphics.beginFill(0xEEEEEE);
			bgShape.graphics.drawRect(bgStyle.tx, bgStyle.ty - topH, bgStyle.width, topH);
			bgShape.graphics.endFill();
			
			bgShape.graphics.lineStyle(1, 0xDDDDDD);
			bgShape.graphics.moveTo(bgStyle.tx, bgStyle.ty);
			bgShape.graphics.lineTo(bgStyle.tx, bgStyle.ty - topH);
			bgShape.graphics.lineTo(bgStyle.width - editor.offSet, bgStyle.ty - topH);
			bgShape.graphics.lineTo(bgStyle.width- editor.offSet, bgStyle.ty);
			
			fontColors.x = colorSelectBtn.x + colorSelectBtn.width / 2;
			fontColors.y = bgStyle.ty - editor.offSet - 6;
		}
		
		internal function get panelWidth():Number
		{
			return bgStyle.width;
		}
		
		internal function get panelHeight():Number
		{
			return bgStyle.height;
		}
		
		
		
		/**
		 * 面板的最小宽度，防止按钮放不下
		 */		
		private var panelMinWidth:uint = 270;
		
		/**
		 */		
		private var panelUnitHeight:uint = 36;
		
		/**
		 */		
		private var bgShape:Sprite = new Sprite;
		
		/**
		 */		
		private var bgStyle:Style = new Style;
		
		/**
		 */		
		private var bgStyleXML:XML = <style>
											<border color="#e0e0e0" thikness='1'/>
											<fill color='#fafafa,#F6F6F6' alpha='1,1' angle='90'/>
									  </style>
		/**
		 */		
		private var editor:TextEditor;
	}
}