package view.elementSelector.toolBar
{
	import com.kvs.utils.XMLConfigKit.StyleManager;
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	import com.kvs.utils.XMLConfigKit.style.States;
	
	import commands.Command;
	
	/**
	 * 含有样式选择器的工具条，如颜色选择器
	 */	
	public class ToolbarWithStyle extends ToolBarBase
	{
		public function ToolbarWithStyle(toolBar:ToolBarController)
		{
			super(toolBar);
		}
		
		/**
		 */		
		override public function init():void
		{
			var styleXML:XML = XMLVOMapper.getStyleXMLBy_ID(element.vo.styleType, 'colors') as XML;
			resetColorBtns(styleXML);
		}
		
		/**
		 */		
		protected function resetColorBtns(styleXML:XML):void
		{
			toolBar.colorBtns.clear();
			
			var colorBtn:StyleBtn;
			var index:uint = 0;
			
			for each (var item:XML in styleXML.children())
			{
				colorBtn = new StyleBtn();
				colorBtn.iconWidth = colorIconSize;
				colorBtn.iconHeight = colorIconSize;
				colorBtn.w = toolBar.btnWidth;
				colorBtn.h = toolBar.btnHeight;
				
				colorBtn.iconStatesXML = this.colorIconStyleXML;
				colorBtn.bgStatesXML = this.colorBtnBGStyle;
				colorBtn.iconColor = StyleManager.setColor(item.toString());
				
				if (item.hasOwnProperty('@index'))
					colorBtn.data = uint(item.@index);
				else
					colorBtn.data = index;
				
				toolBar.colorBtns.put(colorBtn.data, colorBtn);
				
				index ++;
			}
		}
		
		/**
		 */		
		protected var colorIconSize:uint = 21;
		
		/**
		 */		
		override public function stylePanelOpen():void
		{
			if(toolBar.colorBtns.containsKey(toolBar.styleBtn.data))
				toolBar.curStyleBtn = toolBar.colorBtns.getValue(toolBar.styleBtn.data);
		}
		
		/**
		 * 预览样式
		 */		
		override public function prevStyle(styleBtn:StyleBtn):void
		{
			element.vo.color = styleBtn.iconColor;
			element.render();
		}
		
		/**
		 * 撤销样式预览
		 */		
		override public function reBackStyle():void
		{
			element.vo.color = toolBar.curStyleBtn.iconColor;
			element.render();
		}
		
		/**
		 */		
		override public function styleSelected(styleBtn:StyleBtn):void
		{
			element.vo.color = styleBtn.iconColor;
			element.vo.colorIndex = uint(styleBtn.data);
			element.render();
			
			toolBar.curStyleBtn.selected = false;
			toolBar.resetToolbar();
			
			var oldColorObj:Object = {};
			oldColorObj.color = toolBar.curStyleBtn.iconColor;
			oldColorObj.colorIndex = toolBar.curStyleBtn.data;
			toolBar.selector.coreMdt.sendNotification(Command.CHANGE_ELEMENT_COLOR, oldColorObj);
		}
		
		/**
		 */		
		override public function render():void
		{
			
		}
		
		/**
		 */		
		protected function resetColorIconStyle():void
		{
			// 刷新颜色, 记录下当前颜色信息
			toolBar.styleBtn.iconColor = element.vo.color;
			toolBar.styleBtn.data = element.vo.colorIndex;
			
			toolBar.styleBtn.iconStates = new States;
			XMLVOMapper.fuck(colorPreviewIconStyleXML, toolBar.styleBtn.iconStates);
			toolBar.styleBtn.normalHandler();// 切换到默认样式
			toolBar.styleBtn.render();
		}
		
		/**
		 * 颜色icon的样式， 边框，填充类型的样式文件各不相同 
		 */		
		protected var colorIconStyleXML:XML;
		
		/**
		 * 样式预览icon的样式
		 */		
		protected var colorPreviewIconStyleXML:XML;
		
		/**
		 */			
		protected var colorBtnBGStyle:XML = <states>
												<normal>
													<border thickness='1' alpha='1' color='#373737'/>
													<fill color='#6a6a6a, #585858' alpha='1, 1' angle='90'/>
												</normal>
												<hover>
													<border thickness='1' color='#000000'/>
													<fill color='#999999, #888888' alpha='1, 1' angle='90'/>
												</hover>
												<down>
													<border thickness='1' color='373737'/>
													<fill color='#EEEEEE, #EEEEEE' alpha='1, 1' angle='90'/>
												</down>
											</states>
	}
}