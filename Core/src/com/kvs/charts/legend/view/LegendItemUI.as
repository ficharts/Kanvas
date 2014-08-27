package com.kvs.charts.legend.view
{
	import com.kvs.charts.chart2D.core.model.DataRender;
	import com.kvs.charts.legend.LegendStyle;
	import com.kvs.charts.legend.model.LegendVO;
	import com.kvs.ui.label.LabelUI;
	import com.kvs.utils.XMLConfigKit.style.LabelStyle;
	
	import flash.display.Sprite;
	
	/**
	 */	
	public class LegendItemUI extends Sprite
	{
		/**
		 */		
		private var vo:LegendVO;
		
		/**
		 */		
		public function LegendItemUI(vo:LegendVO)
		{
			super();
			
			this.vo = vo;
			this.mouseChildren = false;
			this.addChild(canvas);
		}
		
		/**
		 */		
		public function render(style:LegendStyle):void
		{
			var labelStyle:LabelStyle = style.label;
			
			// 默认采用全局图例icon，序列可独立定义图例icon
			if (vo.iconRender)
				icoRender = vo.iconRender;
			else
				icoRender = style.icon;
			
			icoRender.render(iconShape, vo.metaData);
			iconShape.x = iconShape.width / 2;
			iconShape.y = 0;
			canvas.addChild(iconShape);
			
			var label:LabelUI = new LabelUI();
			label.mdata = vo.metaData;
			label.style = labelStyle;
			label.render();
			label.x = iconShape.width + style.hPadding;
			label.y = - label.height / 2;
			canvas.addChild(label);
			
			canvas.y = canvas.height / 2;
			
			// 绘制填充背景�
			this.graphics.clear();
			this.graphics.beginFill(0, 0);
			this.graphics.drawRect(0, 0, this.width, this.height);
		}
		
		/**
		 */		
		private var canvas:Sprite = new Sprite;
		
		/**
		 */		
		private var iconShape:Sprite = new Sprite;
		
		/**
		 */		
		private var icoRender:DataRender;
	}
}