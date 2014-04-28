package landray.kp.utils
{
	import com.kvs.utils.ClassUtil;
	import com.kvs.utils.RexUtil;
	import com.kvs.utils.StageUtil;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	import com.kvs.utils.XMLConfigKit.XMLVOLib;
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	import com.kvs.utils.graphic.BitmapUtil;
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	
	import model.vo.BgVO;
	import model.vo.ElementVO;
	
	import util.StyleUtil;
	import util.img.ImgLib;

	public class CoreUtil
	{
		
		public static function ifHasText(value:Object):Boolean
		{
			return RexUtil.ifHasText(value);
		}
		
		public static function initApplication(container:Sprite, handler:Function):void
		{
			StageUtil.initApplication(container, handler);
		}
		
		public static function drawBitmapDataToShape(bmd:BitmapData, ui:Shape, w:Number, h:Number, tx:Number = 0, ty:Number = 0, smooth:Boolean = true, radius:uint = 0):void
		{
			BitmapUtil.drawBitmapDataToShape(bmd, ui, w, h, tx, ty, smooth, radius);
		}
		
		public static function getObjByClassPath(path:String):Object
		{
			return ClassUtil.getObjectByClassPath(path);
		}
		
		public static function applyStyle(vo:ElementVO, stypeID:String = null):void
		{
			StyleUtil.applyStyleToElement(vo, stypeID);
		}
		
		public static function getColor(value:BgVO):uint
		{
			return uint((value.color) 
				? value.color 
				: setColor(XML(getStyle('bg', 'colors')).children()[value.colorIndex].toString()));
		}
		
		public static function setColor(value:Object):Object
		{
			return StyleManager.setColor(value);
		}
		
		public static function imageLibGetData(value:uint):ByteArray
		{
			return ImgLib.getData(value);
		}
		
		public static function imageLibHasData(value:uint):Boolean
		{
			return ImgLib.ifHasData(value);
		}
		
		public static function mapping(obj:*, vo:*, parentVO:ElementVO=null):void
		{
			XMLVOMapper.fuck(obj, vo, parentVO);
		}
		
		public static function getStyle(key:String, type:String):*
		{
			return (XMLVOLib.currentLib) ? XMLVOLib.getXML(key, type) : null;
		}
		
		public static function clearLibPart(lib:XMLVOLib = null):void
		{
			if(!lib) lib = XMLVOLib.currentLib;
			if( lib) lib.clearPartLib();
		}
		
		public static function registLib(lib:XMLVOLib):void
		{
			XMLVOLib.currentLib = lib;
		}
		
		public static function registLibXMLWhole(key:String, xml:*, type:String, lib:XMLVOLib = null):void
		{
			if(!lib) lib = XMLVOLib.currentLib;
			lib.registWholeXML(key, xml, type);
		}
		
		public static function registLibXMLPart(key:String, xml:*, type:String, lib:XMLVOLib = null):void
		{
			if(!lib) lib = XMLVOLib.currentLib;
			if( lib) lib.registerPartXML(key, xml, type);
		}
		
	}
}