package util.img
{
	import com.kvs.utils.Map;
	
	import flash.display.BitmapData;
	import flash.utils.ByteArray;

	/**
	 * 图片数据存储库，根据ID管理图片数据
	 */	
	public class ImgLib
	{
		/**
		 */		
		public static function setID(id:uint):void
		{
			if (id > _imgID)
				_imgID = id;
		}
		
		/**
		 */		
		public static function register(id:String, imgData:ByteArray):void
		{
			//预览图不需要
			if (id != PRE_IMG && uint(id) != 0)
			{
				setID(uint(id));
				imgMap.put(uint(id), imgData);
			}
		}
		
		/**
		 * 预览图名称
		 */		
		public static const PRE_IMG:String = 'preview';
		
		/**
		 */		
		public static function unRegister(id:uint):void
		{
			imgMap.remove(id);
		}
		
		/**
		 */		
		public static function getData(id:uint):ByteArray
		{
			return imgMap.getValue(id) as ByteArray;		
		}
		
		/**
		 */		
		public static function clear():void
		{
			imgMap.clear();
		}
		
		/**
		 */		
		public static function ifHasData(id:uint):Boolean
		{
			return imgMap.containsKey(id);
		}
		
		/**
		 */		
		public static function get imgKeys():Array
		{
			return imgMap.keys;
		}
		
		/**
		 */		
		public static function get imgs():Array
		{
			return imgMap.values();
		}
		
		/**
		 */		
		public static function get imgID():uint
		{
			_imgID += 1;
			
			return _imgID;
		}
		
		/**
		 */		
		private static var _imgID:uint = 0;
		
		/**
		 */		
		private static var imgMap:Map = new Map;
		
		/**
		 */		
		public function ImgLib(key:Key)
		{
		}
	}
}

/**
 */
class Key 
{
	public function Key()
	{
		
	}
}