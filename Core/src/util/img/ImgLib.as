package util.img
{
	import com.kvs.utils.Map;
	
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
		public static function register(id:String, imgData:ByteArray, type:String):void
		{
			//预览图不需要
			if (id != PRE_IMG && uint(id) != 0)
			{
				setID(uint(id));
				
				dataMap.put(uint(id), imgData);
				typeMap.put(id, type);
			}
		}
		
		/**
		 */		
		private static var typeMap:Map = new Map;
		
		/**
		 * 预览图名称
		 */		
		public static const PRE_IMG:String = 'preview';
		
		/**
		 */		
		public static function unRegister(id:uint):void
		{
			dataMap.remove(id);
			typeMap.remove(id);
		}
		
		/**
		 */		
		public static function getData(id:uint):ByteArray
		{
			return dataMap.getValue(id) as ByteArray;		
		}
		
		/**
		 */		
		public static function getType(id:uint):String
		{
			return typeMap.getValue(id); 
		}
		
		/**
		 */		
		public static function clear():void
		{
			dataMap.clear();
			typeMap.clear();
		}
		
		/**
		 */		
		public static function ifHasData(id:uint):Boolean
		{
			return dataMap.containsKey(id);
		}
		
		/**
		 */		
		public static function get keys():Array
		{
			return dataMap.keys;
		}
		
		/**
		 */		
		public static function get allData():Array
		{
			return dataMap.values();
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
		private static var dataMap:Map = new Map;
		
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