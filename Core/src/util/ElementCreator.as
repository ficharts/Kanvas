package util
{
	import com.kvs.utils.Map;
	
	import model.vo.ElementVO;
	import model.vo.ShapeVO;
	
	import view.element.ElementBase;
	import view.element.shapes.Circle;
	
	
	/**
	 * 负责图形创建
	 */	
	public class ElementCreator
	{
		/**
		 */		
		public function ElementCreator()
		{
		}
		
		/**
		 * 根据图形类型，获取VO， 默认为 ShapeVO
		 */		
		public static function getElementVO(type:String):ElementVO
		{
			var element:ElementVO = new (voMap.getValue(type) as Class) as ElementVO;
			
			if (element == null)
				element = new ShapeVO;
			
			element.id = ElementCreator.id;
			element.type = type;
			
			return element;
		}
		
		/**
		 * 根据图形类型获取UI，默认为Circle
		 */		
		public static function getElementUI(elementVO:ElementVO):ElementBase
		{
			var element:ElementBase = new (uiMap.getValue(elementVO.type) as Class)(elementVO) as ElementBase;
			
			if (element == null)
				element = new Circle(elementVO as ShapeVO);
			
			return element;
		}
		
		/**
		 */		
		public static function registerElement(type:String, uiClass:Class, voClass:Class):void
		{
			uiMap.put(type, uiClass);
			voMap.put(type, voClass);
		}
		
		/**
		 */		
		private static var voMap:Map = new Map;
		
		/**
		 */		
		private static var uiMap:Map = new Map;
		
		/**
		 * 全局的元素ID都从这里分配
		 */		
		public static function get id():uint
		{
			return _shapeID ++;
		}
		
		/**
		 */		
		public static function setID(value:uint):void
		{
			if (value > _shapeID)
				_shapeID = value;
		}
		
		/**
		 */		
		private static var _shapeID:uint = 1;
		
		
	}
}