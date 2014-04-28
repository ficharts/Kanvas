package model.vo
{
	import com.kvs.utils.XMLConfigKit.StyleManager;
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	/**
	 * 背景的数据模型， 包括背景颜色，图片等信息
	 */	
	public class BgVO
	{
		public function BgVO()
		{
		}
		
		/**
		 */		
		public function get xml():XML
		{
			return <bg color={color.toString(16)} colorIndex={colorIndex} imgURL={imgURL} imgID={imgID}/>
		}
		
		/**
		 */		
		private var _colorIndex:uint = 0;

		/**
		 */
		public function get colorIndex():uint
		{
			return _colorIndex;
		}

		/**
		 * @private
		 */
		public function set colorIndex(value:uint):void
		{
			_colorIndex = value;
		}
		
		/**
		 */		
		private var _color:Object = 0xFFFFFF;

		/**
		 */
		public function get color():Object
		{
			return _color;
		}

		/**
		 * @private
		 */
		public function set color(value:Object):void
		{
			_color = StyleManager.setColor(value);
		}
		
		/**
		 */		
		private var _img:String = '';

		/**
		 */
		public function get imgURL():String
		{
			return _img;
		}

		/**
		 * @private
		 */
		public function set imgURL(value:String):void
		{
			_img = value;
		}
		
		/**
		 */		
		public var imgID:uint = 0;
		
		/**
		 */		
		public var imgData:BitmapData;


	}
}