package com.kvs.charts.legend.view
{
	import com.kvs.charts.chart2D.core.model.DataRender;
	import com.kvs.charts.legend.LegendStyle;
	import com.kvs.charts.legend.model.LegendVO;
	import com.kvs.utils.XMLConfigKit.style.LabelStyle;
	import com.kvs.ui.label.LabelUI;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
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
			
			this.addEventListener(MouseEvent.ROLL_OVER, overHandler);
			this.addEventListener(MouseEvent.ROLL_OUT, outHandler);
			this.addEventListener(MouseEvent.MOUSE_DOWN, clickHandler);
			this.addEventListener(MouseEvent.MOUSE_UP, upHandler);
		}
		
		/**
		 */		
		private function clickHandler(evt:MouseEvent):void
		{
			if (this.ifShow)
			{
				this.vo.dispatchEvent(new LegendEvent(LegendEvent.HIDE_LEGEND, vo));
				this.filters =  StyleManager.getDisableFilter();
				this.ifShow = false;
				this.alpha = .8;
			}
			else
			{
				this.vo.dispatchEvent(new LegendEvent(LegendEvent.SHOW_LEGEND, vo));
				this.filters = null;
				this.ifShow = true;
				this.alpha = 1;
			}
			
			this.y += 1;
		}
		
		/**
		 */		
		private function upHandler(evt:MouseEvent):void
		{
			this.y = sourceY;
		}
		
		/**
		 */		
		private var sourceY:Number;
		
		/**
		 */		
		private var ifShow:Boolean = true;
		
		/**
		 */		
		private function overHandler(evt:MouseEvent):void
		{
		}
		
		/**
		 */		
		private function outHandler(evt:MouseEvent):void
		{
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