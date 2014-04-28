package view.elementSelector.toolBar
{
	import com.kvs.utils.XMLConfigKit.StyleManager;
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	import com.kvs.utils.XMLConfigKit.style.States;
	import com.kvs.utils.XMLConfigKit.style.Style;
	
	import commands.Command;
	
	import flash.events.MouseEvent;
	
	import model.CoreFacade;
	import model.CoreProxy;
	
	import util.StyleUtil;

	/**
	 * 既含有填充，有含有边框的图形的工具条
	 */	
	public class WholeShapeToolBar extends BorderShape
	{
		public function WholeShapeToolBar(toolBar:ToolBarController)
		{
			super(toolBar);
		}
		
		/**
		 */		
		override public function stylePanelOpen():void
		{
			if(toolBar.colorBtns.containsKey(toolBar.styleBtn.data))
				toolBar.curStyleBtn = toolBar.colorBtns.getValue(toolBar.styleBtn.data);
		}
		
		/**
		 */		
		override public function prevStyle(styleBtn:StyleBtn):void
		{
			element.vo.styleID = styleBtn.data.toString();
			StyleUtil.applyStyleToElement(element.vo);
			
			element.render();
		}
		
		/**
		 */		
		override public function reBackStyle():void
		{
			element.vo.styleID = toolBar.curStyleBtn.data.toString();
			StyleUtil.applyStyleToElement(element.vo);
			
			element.render();
		}
		
		/**
		 */		
		override public function styleSelected(styleBtn:StyleBtn):void
		{
			var styleID:String = styleBtn.data.toString();
			
			toolBar.curStyleBtn.selected = false;
			toolBar.resetToolbar();
			
			toolBar.selector.coreMdt.sendNotification(Command.CHANGE_ELEMENT_STYLE, styleID);
		}
		
		/**
		 */		
		override public function init():void
		{
			//样式列表
			toolBar.colorBtns.clear();
			var styleXML:XML = XMLVOMapper.getStyleXMLBy_ID('shape', 'styles') as XML;
			var colorBtn:StyleBtn;
			var index:uint = 0;
			
			for each (var item:XML in styleXML.children())
			{
				colorBtn = new StyleBtn();
				colorBtn.iconWidth = colorBtn.iconHeight = 25;
				colorBtn.w = toolBar.btnWidth;
				colorBtn.h = toolBar.btnHeight;
				
				colorBtn.iconStatesXML = this.colorIconStyleXML;
				colorBtn.bgStatesXML = this.colorBtnBGStyle;
				colorBtn.data = item.@styleID.toString();
				
				//因icon的样式是有状态的， 需要把独立的style拼装成状态结构的
				 colorBtn.iconStatesXML = styleXMLToStatesXML(XML(XMLVOMapper.getStyleXMLBy_ID(colorBtn.data.toString(), 'shape').style.toXMLString()));
				
				colorBtn.thickness = iconBorderThickness;
				toolBar.colorBtns.put(colorBtn.data, colorBtn);
				
				index ++;
			}
		}
		
		/**
		 * 
		 */		
		private var iconBorderThickness:uint = 3;
		
		/**
		 */		
		override public function render():void
		{
			toolBar.addBtn(toolBar.linkBtn);
			toolBar.styleBtn.data = element.vo.styleID;
			
			//这里不改变真正的图标样式，因为颜色选择面板的还要用原有样式
			var iconStyleXML:XML = XML(XMLVOMapper.getStyleXMLBy_ID(element.vo.styleID, element.vo.styleType).style.toXMLString());
			XMLVOMapper.fuck(styleXMLToStatesXML(iconStyleXML, true), toolBar.styleBtn.iconStates);
			toolBar.styleBtn.normalHandler();// 切换到默认样式
			toolBar.styleBtn.render();
			
			toolBar.addBtn(toolBar.styleBtn);
			toolBar.addBtn(addBtn);
			toolBar.addBtn(cutBtn);
			toolBar.addBtn(toolBar.topLayerBtn);
			toolBar.addBtn(toolBar.bottomLayerBtn);
			initPageElementConvertIcons();
			toolBar.addBtn(toolBar.delBtn);
			
		}
		
		/**
		 * 把独立节点的xml样式文件转换为状态结构的states类型的xml
		 */		
		private function styleXMLToStatesXML(source:XML, ifPreviewIcon:Boolean = false):XML
		{
			var result:XML = <states/>;
			var nodeXML:XML;
				
			nodeXML = source.copy()
			nodeXML.setName('normal');
			
			if (ifPreviewIcon)
				nodeXML.@radius = colorIconSize;
			
			result.appendChild(nodeXML);
			
			nodeXML = source.copy()
			nodeXML.setName('hover');
			nodeXML.@radius = colorIconSize;
			result.appendChild(nodeXML);
			
			nodeXML = source.copy()
			nodeXML.setName('down');
			nodeXML.@radius = colorIconSize;
			result.appendChild(nodeXML);
				
				
			return result;
		}
		
	}
}