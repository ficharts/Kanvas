package com.kvs.charts.chart2D.core.itemRender
{
	import com.kvs.charts.chart2D.core.model.DataRender;
	import com.kvs.charts.common.SeriesDataPoint;
	import com.kvs.ui.label.LabelUI;
	import com.kvs.utils.XMLConfigKit.style.IStyleStatesUI;
	import com.kvs.utils.XMLConfigKit.style.LabelStyle;
	import com.kvs.utils.XMLConfigKit.style.States;
	import com.kvs.utils.XMLConfigKit.style.Style;
	
	import flash.display.Sprite;

	/**
	 */	
	public class PointRenderBace extends Sprite implements IStyleStatesUI
	{
		public function PointRenderBace()
		{
			super();

			//this.hitArea = canvas;
			addChild(canvas);
		}
		
		/**
		 * 
		 * 这个值在全局判断节点碰撞时会用到
		 * 
		 * 渲染节点的半径，  汽包图的气泡半径由Z值决定，默认由样式文件定�radius 
		 */		
		private var _radius:Number = 0;

		/**
		 */
		public function get radius():Number
		{
			return _radius;
		}

		/**
		 * @private
		 */
		public function set radius(value:Number):void
		{
			_radius = value;
		}
		
		/**
		 */		
		public var isHorizontal:Boolean = false;
		
		/**
		 * 判断当前渲染器是否有效�
		 */
		public function get isEnable():Boolean
		{
			return _isEnable;
		}
		
		/**
		 */		
		protected var _isEnable:Boolean = true;

		/**
		 */		
		public function disable():void
		{
			canvas.visible = _isEnable = false;
		}
		
		/**
		 */		
		public function enable():void
		{
			canvas.visible = _isEnable = true;
		}
		
		/**
		 */		
		public function get xTipLabel():String
		{
			return itemVO.xLabel;
		}
		
		/**
		 */		
		public function get yTipLabel():String
		{
			return itemVO.yLabel;
		}
		
		/**
		 */		
		public function get zTipLabel():String
		{
			return '';
		}
		
		/**
		 */		
		protected var canvas:Sprite = new Sprite;

		/**
		 * @param evt
		 */
		public function hoverHandler():void
		{
		}
		
		/**
		 */		
		public function normalHandler():void
		{
		}
		
		/**
		 */		
		public function downHandler():void
		{
		}
		
		/**
		 *  Set item render position.             
		 */
		public function render():void
		{
			if (this.dataRender.enable)
			{
				canvas.graphics.clear();
				this.dataRender.render(this.canvas, itemVO.metaData);
				this.radius = canvas.width / 2;
			}
		}
		
		/**
		 */		
		public function layout():void
		{
			x = _itemVO.dataItemX;
			y = _itemVO.dataItemY;
			if (this.valueLabel.enable)
			{
				if(valueLabelUI == null)
				{
					valueLabelUI = createValueLabelUI()
					//addChild(valueLabelUI);
					layoutValueLabel();
				}
			}
		}
		
		/**
		 */		
		protected function createValueLabelUI():LabelUI
		{
			var labelUI:LabelUI  = new LabelUI();
			labelUI.style = this.valueLabel;
			labelUI.mdata = this.itemVO.metaData;
			labelUI.render();
			
			return labelUI;
		}
		
		/**
		 * 数值字段， 用来判断toolTip提示的方向；
		 */		
		private var _valueField:String = 'xValue';
		
		public function get value():String
		{
			return _valueField;
		}
		
		public function set value(value:String):void
		{
			_valueField = value;
		}
		
		/**
		 */		
		protected function layoutValueLabel():void
		{
			if (this.valueLabel.layout == LabelStyle.VERTICAL)
			{
				valueLabelUI.rotation = - 90;
				valueLabelUI.x = - valueLabelUI.width / 2;
				
				if (Number(_itemVO.yValue) < 0)
					valueLabelUI.y = this.radius + valueLabelUI.height + this.valueLabel.margin;
				else
					valueLabelUI.y = - this.radius - this.valueLabel.margin;
			}
			else
			{
				valueLabelUI.x = - valueLabelUI.width / 2;
				
				if (Number(_itemVO.yValue) < 0)
					valueLabelUI.y = this.radius + this.valueLabel.margin;
				else
					valueLabelUI.y = - this.radius - valueLabelUI.height - this.valueLabel.margin;
			}
		}
		
		/**
		 */		
		public var valueLabelUI:LabelUI;

		/**
		 */
		protected var _itemVO:SeriesDataPoint;

		public function get itemVO():SeriesDataPoint
		{
			return _itemVO;
		}

		public function set itemVO(v:SeriesDataPoint):void
		{
			_itemVO = v;
		}
		
		/**
		 */		
		private var _dataRender:DataRender;

		/**
		 */
		public function get dataRender():DataRender
		{
			return _dataRender;
		}

		/**
		 * @private
		 */
		public function set dataRender(value:DataRender):void
		{
			_dataRender = value;
		}
		
		/**
		 */		
		private var _style:Style;
		
		public function get currState():Style
		{
			return _style;
		}
		
		public function set currState(value:Style):void
		{
			_style = value;
		}
		
		/**
		 * 数值标签的文字样式 
		 */		
		protected var _valueLabel:LabelStyle;

		/**
		 */
		public function get valueLabel():LabelStyle
		{
			return _valueLabel;
		}

		/**
		 * @private
		 */
		public function set valueLabel(value:LabelStyle):void
		{
			_valueLabel = value;
		}
		
		/**
		 */		
		private var _states:States;

		/**
		 */
		public function get states():States
		{
			return _states;
		}

		/**
		 * @private
		 */
		public function set states(value:States):void
		{
			_states = value;
			
			currState = _states.getNormal;
		}
		
	}
}