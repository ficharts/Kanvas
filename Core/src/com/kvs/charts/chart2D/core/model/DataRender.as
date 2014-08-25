package com.kvs.charts.chart2D.core.model
{
	import com.kvs.utils.XMLConfigKit.Model;
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	import com.kvs.utils.XMLConfigKit.shape.Decorate;
	import com.kvs.utils.XMLConfigKit.shape.IShape;
	import com.kvs.utils.XMLConfigKit.shape.IShapeGroup;
	import com.kvs.utils.XMLConfigKit.style.elements.IFiElement;
	import com.kvs.utils.XMLConfigKit.style.elements.IFreshElement;
	import com.kvs.utils.XMLConfigKit.style.elements.IStyleElement;
	
	import flash.display.Sprite;
	
	/**
	 * 数据节点的样式， 数据节点显示方式有多种形状，也可能由多个形状构成一个节点
	 */	
	public class DataRender implements IFreshElement, IShapeGroup, IFiElement, IStyleElement
	{
		public function DataRender()
		{
			super();
			
			_decorate = new Decorate(this);
		}
		
		/**
		 */		
		private var _size:uint = 0

		/**
		 */
		public function get size():uint
		{
			return _size;
		}

		/**
		 * @private
		 */
		public function set size(value:uint):void
		{
			_size = value;
			
			ifSetSize = true;
		}
		
		/**
		 */		
		private var ifSetSize:Boolean = false;

		/**
		 */			
		private var _decorate:Decorate;

		/**
		 */
		public function get decorate():Decorate
		{
			return _decorate;
		}

		/**
		 * @private
		 */
		public function set decorate(value:Decorate):void
		{
			_decorate = value;
		}

		/**
		 */		
		public function fresh():void
		{
			_circle = _rect = _diamond = _triangle = null;
			_decorate.fresh();
			
			shapes.length = 0;
			ifSetSize = false;
		}
		
		/**
		 * 因数据节点构成存在多元化，每次重新设置样式时需重置整个对象
		 */		
		public function set style(value:String):void
		{
			_style = XMLVOMapper.updateStyle(this, value, Model.DATA_RENDER);
		}
		
		/**
		 */		
		public function get style():String
		{
			return _style;
		}
		
		/**
		 */		
		private var _style:String;
		
		
		/**
		 */		
		private var _enable:Boolean = true;

		/**
		 */
		public function get enable():Object
		{
			return _enable;
		}

		/**
		 * @private
		 */
		public function set enable(value:Object):void
		{
			_enable = XMLVOMapper.boolean(value);
		}
		
		/**
		 */		
		public function render(canvas:Sprite, metadata:Object, radius:Number = NaN):void
		{
			for each (var shape:IShape in shapes)
			{
				shape.style = shape.states.getNormal;
				
				if (isNaN(radius) == false)
					shape.style.radius = radius;
					
				if (ifSetSize)
					shape.size = size;
				
				shape.angle = this.angle;
				shape.render(canvas, metadata);
			}
		}
		
		/**
		 */		
		private var _angle:int = 0;
		
		/**
		 */
		public function get angle():int
		{
			return _angle;
		}
		
		/**
		 * @private
		 */
		public function set angle(value:int):void
		{
			_angle = - value;
		}
		
		/**
		 */		
		public function get circle():IShape
		{
			return _circle;
		}

		/**
		 */		
		public function set circle(value:IShape):void
		{
			_circle = value;
			
			shapes.push(value);
		}
		
		/**
		 */		
		private var _circle:IShape;
		
		/**
		 */
		public function get rect():IShape
		{
			return _rect;
		}

		/**
		 */		
		public function set rect(value:IShape):void
		{
			_rect = value;
			
			shapes.push(value);
		}
		
		/**
		 */		
		private var _rect:IShape;
		
		/**
		 */
		public function get diamond():IShape
		{
			return _diamond;
		}
		
		/**
		 */		
		public function set diamond(value:IShape):void
		{
			_diamond = value;
			
			shapes.push(value);
		}
		
		/**
		 */		
		private var _diamond:IShape;
		
		/**
		 */		
		private var _triangle:IShape

		public function get triangle():IShape
		{
			return _triangle;
		}

		public function set triangle(value:IShape):void
		{
			_triangle = value;
			
			shapes.push(value);
		}

		/**
		 */		
		private var _shapes:Vector.<IShape> = new Vector.<IShape>;

		/**
		 */
		public function get shapes():Vector.<IShape>
		{
			return _shapes;
		}

		/**
		 * @private
		 */
		public function set shapes(value:Vector.<IShape>):void
		{
			_shapes = value;
		}


	}
}