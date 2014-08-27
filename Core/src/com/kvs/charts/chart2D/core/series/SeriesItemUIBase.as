package com.kvs.charts.chart2D.core.series
{
	import com.kvs.charts.common.SeriesDataPoint;
	import com.kvs.utils.XMLConfigKit.style.States;
	import com.kvs.utils.XMLConfigKit.style.Style;
	
	import flash.display.Sprite;
	
	/**
	 * 每个序列的节点不但要有ItemRender， 还要有专门渲染此节点的渲染器，
	 * 
	 * 如柱体， 散点，气泡等类型的节点；
	 */	
	public class SeriesItemUIBase extends Sprite
	{
		public function SeriesItemUIBase(dataItem:SeriesDataPoint)
		{
			super();
			
			this.dataItem = dataItem;
			this.mouseChildren = false;
		}
		
		/**
		 */		
		private var _style:Style;
		
		/**
		 * 
		 */
		public function get currState():Style
		{
			return _style;
		}
		
		/**
		 * @private
		 */
		public function set currState(value:Style):void
		{
			_style = value;
		}
		
		/**
		 */		
		private var _metaData:Object;
		
		/**
		 */
		public function get mdata():Object
		{
			return _metaData;
		}
		
		/**
		 * @private
		 */
		public function set mdata(value:Object):void
		{
			_metaData = value;
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
		
		/**
		 */		
		public function render():void
		{
			
		}
		
		/**
		 */		
		private var _dataItem:SeriesDataPoint;
		
		/**
		 */
		public function get dataItem():SeriesDataPoint
		{
			return _dataItem;
		}
		
		/**
		 * @private
		 */
		public function set dataItem(value:SeriesDataPoint):void
		{
			_dataItem = value;
		}
		
		
	}
}