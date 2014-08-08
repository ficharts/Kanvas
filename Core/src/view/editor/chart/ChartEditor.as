package view.editor.chart
{
	import com.kvs.ui.label.TextInputField;
	
	import flash.display.Sprite;
	import flash.text.engine.CFFHinting;
	import flash.text.engine.FontLookup;
	
	import flashx.textLayout.container.ScrollPolicy;
	import flashx.textLayout.container.TextContainerManager;
	import flashx.textLayout.edit.EditingMode;
	import flashx.textLayout.formats.TextAlign;
	import flashx.textLayout.formats.TextLayoutFormat;
	
	import util.textFlow.FlowTextManager;
	
	/**
	 *
	 * 图表编辑器
	 *  
	 * @author wanglei
	 * 
	 */	
	public class ChartEditor extends Sprite
	{
		public function ChartEditor(core:CoreApp)
		{
			super();
			
			this.app = core;
			
			dataField.textLayoutFormat.fontSize = 16;
			
			dataField.textLayoutFormat.paddingTop = dataField.textLayoutFormat.paddingLeft 
				= dataField.textLayoutFormat.paddingRight = dataField.textLayoutFormat.paddingBottom = 20;
			
			dataField.textLayoutFormat.fontFamily = "宋体";
			dataField.textLayoutFormat.lineHeight = "150%";
			dataField.textLayoutFormat.wordSpacing
			
			dataField.text = "awefawefawefawef";
			dataField.updateLayout();
			
			addChild(dataField);
		}
		
		/**
		 */		
		public function resize():void
		{
			this.graphics.clear();
			this.graphics.beginFill(0, 0);
			this.graphics.drawRect(app.contentRect.x, app.contentRect.y, app.contentRect.width, app.contentRect.height);
			this.graphics.endFill();
			
			dataField.textWidth = app.contentRect.width - 100;
			dataField.textHeight = app.contentRect.height - 100;
			dataField.updateLayout();
			
			dataField.x = (app.contentRect.width - dataField.textWidth) / 2;
			dataField.y = app.contentRect.y + (app.contentRect.height - dataField.height) / 2;
		}
		
		/**
		 * 数据输入区域 
		 */		
		private var dataField:TextInputField = new TextInputField();
		
		/**
		 */		
		private var app:CoreApp;
	}
}