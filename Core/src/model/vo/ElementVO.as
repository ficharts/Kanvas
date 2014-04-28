package model.vo
{
	import com.kvs.utils.XMLConfigKit.StyleManager;
	import com.kvs.utils.XMLConfigKit.style.Style;
	
	import flash.events.EventDispatcher;
	
	/**
	 * 元素模型
	 * 
	 * 元素包括形状、图片、线条、文字、视频
	 */
	public class ElementVO extends EventDispatcher
	{
		/**
		 */		
		public function ElementVO()
		{
			super();
		}
		
		/**
		 * 元件ID标识，每份图档唯一
		 */		
		public var id:uint = 0;
		
		/**
		 * 元件类型：图形，图片，线条等；
		 */		
		public var type:String;
		
		/**
		 * 模块名称，不同模块囊括了各自的图形集，这里记录了图形隶属那个模块
		 */		
		public var module:String = 'shape';
		
		/**
		 * 扩展属性， 外部程序与Kanvas集成时，可为元件设定
		 * 
		 * 业务相关属性，例如一个url连接，最总发布时，点击这个元件会开启
		 * 
		 * 指向url的页面；
		 */		
		public var property:String = '';
		
		/**
		 */		
		public function get x():Number
		{
			return _x;
		}
		public function set x(value:Number):void
		{
			_x = value;
			if (pageVO) pageVO.x = value;
			
		}
		protected var _x:Number = 0;
		
		/**
		 */		
		public function get y():Number
		{
			return _y;
		}
		public function set y(value:Number):void
		{
			_y = value;
			if (pageVO) pageVO.y = value;
		}
		protected var _y:Number = 0;
		
		/**
		 * 原始尺寸， 通常此值由系统设定，不改动；只有图形型变时
		 * 
		 * 才会改动到原始尺寸；图形缩放和旋转时原始尺寸不改变，
		 * 
		 * 改变的仅是scale和angle；
		 */
		public function get height():Number
		{
			return _height;
		}
		
		/**
		 * @private
		 */
		public function set height(value:Number):void
		{
			_height = value;
			if (pageVO) pageVO.height = value;
		}
		
		/**
		 */		
		protected var _height:Number = 50;
		
		/**
		 */
		public function get width():Number
		{
			return _width;
		}
		
		/**
		 * @private
		 */
		public function set width(value:Number):void
		{
			_width = value;
			if (pageVO) pageVO.width = value;
		}
		
		/**
		 */		
		protected var _width:Number = 50;
		
		
		/**
		 * 元件比例， 元件创建时，原始尺寸恒定，元件比例 * 画布整体缩放比例要  = 1
		 * 
		 * 这样任何地方创建的图形都是标准效果；
		 * 
		 * 元件自身缩放时， 原始尺寸不动，仅调节比例；
		 * 
		 * 元件拉伸（横向/纵向）时， 元件比例不变， 仅调节原始尺寸；
		 */	
		public function get scale():Number
		{
			return _scale;
		}
		
		public function set scale(value:Number):void
		{
			_scale = value;
			if (pageVO) pageVO.scale = value;
		}
		
		protected var _scale:Number = 1;
		
		/**
		 * 旋转角度，0~360范围取值
		 */		
		public function get rotation():Number
		{
			return _rotation;
		}
		
		/**
		 * @private
		 */
		public function set rotation(value:Number):void
		{
			_rotation = value;
			if (pageVO) pageVO.rotation = value;
		}
		
		protected var _rotation:Number = 0;
		
		
		
		
		
		
		
		//---------------------------------------------------
		//
		// 每一种元件都有几套样式模板，隶属于全局样式模板中；
		//
		// 全局样式决定整体风格和元件的局部样式模板；  
		// 
		// 元件的局部样式模板中有一类是可以自定义颜色的，但风格受全局
		//
		// 影响，属于一种可以自定义颜色的局部样式模板
		//
		//----------------------------------------------------
		
		
		/**
		 * 样式ID, 决定了元件的样式局部样式模板
		 */
		public function set styleID(value:String):void
		{
			_styleID = value;	
		}
		
		/**
		 */
		public function get styleID():String
		{
			return _styleID;
		}
		
		/**
		 */
		protected var _styleID:String = null;
		
		/**
		 * 样式类型，配合样式ID，用来获取样式文件
		 */		
		public var styleType:String = '';
		
		/**
		 * 样式模板
		 */
		public function get style():Style
		{
			return _style;
		}
		
		/**
		 */
		public function set style(value:Style):void
		{
			_style = value;
		}
		
		/**
		 * 在未给元素应用样式之前是无法渲染的, 默认无样式
		 */		
		protected var _style:Style;
		
		/**
		 * 自定义颜色值
		 */
		public function set color(value:Object):void
		{
			_color = StyleManager.setColor(value);
		}
		
		/**
		 *  获取颜色值
		 */
		public function get color():Object
		{
			return _color;
		}
		
		/**
		 * 内填充颜色
		 */
		protected var _color:Object = 0x728F1C;
		
		/**
		 * 颜色序号， 每一套样式风格都会给不同类型的
		 * 
		 * 元素分配一组颜色值，也是颜色面板中的可选颜色值；
		 * 
		 * 每个颜色对应一个序号，整体样式风格切换后，元素根据旧的颜色序号
		 * 
		 * 从新颜色列表中匹配新颜色
		 */		
		public var colorIndex:uint = 0;
		
		/**
		 * 边框的粗细
		 */		
		public function set thickness(value:Number):void
		{
			_thickness = value;
		}
		
		public function get thickness():Number
		{
			return _thickness;
		}
		protected var _thickness:Number = 6;
		
		public var pageVO:PageVO;
		
		public function exportData(template:XML):XML
		{
			if(!template)
				template = <element/>;
			template.@id = id;
			template.@property = property;
			template.@type = type;
			template.@styleType = styleType;
			template.@styleID = styleID;
			template.@x = x;
			template.@y = y;
			template.@width = width;
			template.@height = height;
			template.@rotation = rotation;
			template.@color = color.toString(16);
			template.@colorIndex = colorIndex;
			template.@scale = scale;
			return template;
		}
	}
}